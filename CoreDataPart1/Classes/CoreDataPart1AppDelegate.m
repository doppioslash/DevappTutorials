//
//  CoreDataPart1AppDelegate.m
//  CoreDataPart1
//
//  Created by Developer on 03/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "CoreDataPart1AppDelegate.h"


@implementation CoreDataPart1AppDelegate

@synthesize window;

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	//in questo metodo facciamo in modo che quando l'utente preme 'Next' il focus passi al prossimo campo e quando 'Done' che la tastiera sparisca
	if (textField == nameField) {
		[surnameField becomeFirstResponder];
	}
	else if (textField == surnameField) {
		[nickField becomeFirstResponder];
	}

	[textField resignFirstResponder]; 
	return YES;
}

#pragma mark -
#pragma mark Core Data Methods
- (IBAction) addContatto {
	//apriamo alertView se i campi non sono riempiti
	if (nameField.text.length == 0 || surnameField.text.length == 0 || nickField.text.length == 0) {
		
		//Costruiamo l'alert che ci impedisce di inserire un record senza tutti i campi
		NSString *titolo = @"Problema";
		NSString *messaggio = @"Devi inserire tutti i campi!";
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titolo
														message:messaggio
													   delegate:self
											  cancelButtonTitle:@"OK, non lo farò più."
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
	} else {
		//per far sparire la tastiera
		if ([nameField isFirstResponder]) {
			[nameField resignFirstResponder];
		} else if ([surnameField isFirstResponder]) {
			[surnameField resignFirstResponder];
		} else if ([nickField isFirstResponder]){
			[nickField resignFirstResponder];
		}
		
		//Otteniamo il puntatore al NSManagedContext
		NSManagedObjectContext *context = [self managedObjectContext];
		
		//Creiamo un'istanza di NSManagedObject per l'Entità che ci interessa
		NSManagedObject *contatto = [NSEntityDescription
									 insertNewObjectForEntityForName:@"Contatto" 
									 inManagedObjectContext:context];
		
		//Usando il Key-Value Coding inseriamo i dati presi dall'interfaccia nell'istanza dell'Entità appena creata
		[contatto setValue:surnameField.text forKey:@"cognome"];
		[contatto setValue:nameField.text forKey:@"nome"];
		[contatto setValue:nickField.text forKey:@"nick"];
		
		//Effettuiamo il salvataggio gestendo eventuali errori
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Errore durante il salvataggio: %@", [error localizedDescription]);
		}
		
		//per pulire i campi
		NSString *clear = [NSString stringWithFormat:@""];
		
		[nameField setText:clear];
		[surnameField setText:clear];
		[nickField setText:clear];
	}

}

- (IBAction) showContatti {
	//Otteniamo il puntatore al NSManagedContext
	NSManagedObjectContext *context = [self managedObjectContext];
	
	//istanziamo la classe NSFetchRequest di cui abbiamo parlato in precedenza
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	//istanziamo l'Entità da passare alla Fetch Request
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"Contatto" inManagedObjectContext:context];
	//Settiamo la proprietà Entity della Fetch Request
	[fetchRequest setEntity:entity];
	
	//Eseguiamo la Fetch Request e salviamo il risultato in un array, per visualizzarlo nella tabella
	NSError *error;
	NSArray *fo = [context executeFetchRequest:fetchRequest error:&error];
	contattiList = [fo retain];
	
	[fetchRequest release];
	
	[contattiTable reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [contattiList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
									   reuseIdentifier:CellIdentifier] autorelease];
    }
	
    // Set up the cell...
	
	//istanziamo NSManagedObject perché gli oggetti dentro l'array sono di quel tipo
	NSManagedObject *contatto = [contattiList objectAtIndex:indexPath.row];
	
	//accediamo ai dati contenuti dal'oggetto utilizzando il Key-Value Coding
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [contatto valueForKey:@"nome"], [contatto valueForKey:@"cognome"]];
    cell.detailTextLabel.text = [contatto valueForKey:@"nick"];

    return cell;
	
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch.
	
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    
    NSError *error = nil;
    if (managedObjectContext_ != nil) {
        if ([managedObjectContext_ hasChanges] && ![managedObjectContext_ save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"CoreDataPart1" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"CoreDataPart1.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[contattiList release];
	
	[nameField release];
	[surnameField release];
	[nickField release];
	[contattiTable release];
    
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
    
    [window release];
    [super dealloc];
}


@end

