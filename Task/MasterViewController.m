//
//  MasterViewController.m
//  Task
//
//  Created by Naveen Dangeti on 26/12/16.
//  Copyright © 2016 Naveen Dangeti. All rights reserved.
//

#import "MasterViewController.h"
//#import "DetailViewController.h"
#import "ViewTaskController.h"
#import "Tasks.h"
#import "Location.h"
#import "LocationTasksViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
self.navigationItem.rightBarButtonItem = addButton;
//    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.title=@"Tasks";
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    
    Tasks *newTask=[NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
//    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
//        
//    // If appropriate, configure the new managed object.
//    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
//    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    ViewTaskController* taskController = [[ViewTaskController alloc] initWithStyle:UITableViewStyleGrouped];
    taskController.managedTaskObject=newTask;
    taskController.managedObjectContext=context;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
//        [controller setDetailItem:object];
//        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//        controller.navigationItem.leftItemsSupplementBackButton = YES;
   // }
    
    if ([[segue identifier] isEqualToString:@"showViewTaskController"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Tasks *taskObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        ViewTaskController* viewTaskController = [segue destinationViewController];
        viewTaskController.managedObjectContext=self.managedObjectContext;
        viewTaskController.managedTaskObject=taskObject;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    Tasks *managedTaskObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell withObject:managedTaskObject];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

//- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object {
    - (void)configureCell:(UITableViewCell *)cell withObject:(Tasks *)managedTaskObject {
    //cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
    //Tasks* managedTaskObject=[self.fetchedResultsController ]
    cell.textLabel.text=managedTaskObject.text;
        
    //change the color if the task is overdue.
        if (managedTaskObject.isOverDue==[NSNumber numberWithBool:YES]){
            
            cell.textLabel.textColor = [UIColor redColor];
        }
        else{
            
            cell.textLabel.textColor = [UIColor blackColor];
        }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tasks" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:NO];

    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    //NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (IBAction)toolbarFilterAll:(id)sender {
    
    NSLog(@"toolbarFilterAll");
    
    //change the fetch request to display all tasks
    //get the fetch request from the controller and change the predicate
    NSFetchRequest* fetchRequest=self.fetchedResultsController.fetchRequest;
    
    //clear the fetched results controller cache
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    //nil out the predicate to clear it and show all the objects again
    [fetchRequest setPredicate:nil];
    
    NSError* error=nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error,[error userInfo]);
    }
    [self.tableView reloadData];
}

- (IBAction)locationButtonPressed:(id)sender {
    
    NSLog(@"locationButtonPressed");
    
    LocationTasksViewController* Itvc=[[LocationTasksViewController alloc]initWithStyle:UITableViewStylePlain];
    Itvc.managedObjectContext=self.managedObjectContext;
    [self.navigationController pushViewController:Itvc animated:YES];
}

- (IBAction)toolbarFilterHiPri:(id)sender {
    NSLog(@"toolbarFilterHiPri");
    //change the fetch request to display only high_priority tasks
    //get the fetch request from the controller and change the predicate
    NSFetchRequest* fetchRequest=self.fetchedResultsController.fetchRequest;
    
    //clear the fetched results controller cache
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"priority==3"];
    [fetchRequest setPredicate:predicate];
    
    NSError* error=nil;
    if (![[self fetchedResultsController] performFetch:&error ]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
}

- (IBAction)toolbarSortOrderChanged:(id)sender {
    NSLog(@"toolbarSortOrderChanged");
    
    //get the fetch request from the controller and change the sort descriptor
    NSFetchRequest* fetchRequest=self.fetchedResultsController.fetchRequest;
    
    //edit the sort key based on which button was pressed
    BOOL ascendingOrder=NO;
    UIBarButtonItem* button=(UIBarButtonItem*)sender;
    if ([button.title compare:@"Asc"]==NSOrderedSame) {
        ascendingOrder=YES;
    }
    else{
        ascendingOrder=NO;
    }
    
    NSSortDescriptor* sortDescriptor=[[NSSortDescriptor alloc] initWithKey:@"text" ascending:ascendingOrder];
    NSArray* sortDescriptors=[[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError* error=nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@",error,[error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
}

@end
