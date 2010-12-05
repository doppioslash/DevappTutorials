//
//  CoreDataPart1AppDelegate.h
//  CoreDataPart1
//
//  Created by Developer on 03/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataPart1AppDelegate : NSObject <UIApplicationDelegate, UITableViewDataSource> {
    
    UIWindow *window;
	
	IBOutlet UITextField *nameField;
	IBOutlet UITextField *surnameField;
	IBOutlet UITextField *nickField;
	IBOutlet UITableView *contattiTable;
	
	NSArray *contattiList;
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

- (IBAction) showContatti;
- (IBAction) addContatto;

@end

