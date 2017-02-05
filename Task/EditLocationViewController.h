//
//  EditLocationViewController.h
//  Task
//
//  Created by Naveen Dangeti on 02/02/17.
//  Copyright © 2017 Naveen Dangeti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tasks.h"
#import "Location.h"

@interface EditLocationViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic,retain) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic,retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,retain) Tasks* managedTaskObject;

@end
