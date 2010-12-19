//
//  CoreDataPart2AppDelegate.h
//  CoreDataPart2
//
//  Created by Developer on 18/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataPart2AppDelegate : NSObject <UIApplicationDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    UIWindow *window;
	
	IBOutlet UITextField *nameField;
	IBOutlet UITextField *surnameField;
	IBOutlet UITextField *nickField;
	IBOutlet UITableView *contattiTable;
	
	IBOutlet UIButton *addButton;
	NSInteger currentRecord;
	
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

- (void) showContatti;
- (void) clearFields;
- (IBAction) addContatto;
- (IBAction)deleteContatto;

@end

