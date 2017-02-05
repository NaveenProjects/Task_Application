//
//  LocationTasksViewController.h
//  Task
//
//  Created by Naveen Dangeti on 05/02/17.
//  Copyright © 2017 Naveen Dangeti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LocationTasksViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property(nonatomic,retain) NSManagedObjectContext* managedObjectContext;
@property(nonatomic,retain) NSFetchedResultsController *fetchResultsController;

@end
