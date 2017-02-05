//
//  MasterViewController.h
//  Task
//
//  Created by Naveen Dangeti on 26/12/16.
//  Copyright © 2016 Naveen Dangeti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

//@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)toolbarFilterAll:(id)sender;

- (IBAction)locationButtonPressed:(id)sender;

- (IBAction)toolbarFilterHiPri:(id)sender;
- (IBAction)toolbarSortOrderChanged:(id)sender;

@end

