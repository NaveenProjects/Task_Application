//
//  LocationTasksViewController.m
//  Task
//
//  Created by Naveen Dangeti on 05/02/17.
//  Copyright © 2017 Naveen Dangeti. All rights reserved.
//

#import "LocationTasksViewController.h"
#import "Tasks.h"
#import "Location.h"
#import "ViewTaskController.h"

@interface LocationTasksViewController ()

@end

@implementation LocationTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [NSFetchedResultsController deleteCacheWithName:nil];
    NSError* error;
    if (![[self fetchResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    //set the title to display to display in the navigation bar
    self.title=@"Tasks By Location";
}

-(NSFetchedResultsController*)fetchResultsController{
    
    if (_fetchResultsController!=nil) {
        return _fetchResultsController;
    }
    
    //set up the fetched results controller
    //create the fetch request for the entity
    NSFetchRequest* fetchRequest=[[NSFetchRequest alloc]init];
    //edit the entity name as appropriate
    NSEntityDescription* entity=[NSEntityDescription entityForName:@"Tasks" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    //edit the sort key as appropriate
    NSSortDescriptor* sortDescriptor=[[NSSortDescriptor alloc]initWithKey:@"location.name" ascending:YES];
    NSArray *sortDescriptors=[[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //edit the section name key path ans cache name if appropriate
    //nil for section name key path means "no sections"
    
    NSFetchedResultsController* aFetchedResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"location.name" cacheName:@"Tasks"];
    
    aFetchedResultsController.delegate=self;
    _fetchResultsController=aFetchedResultsController;
    return _fetchResultsController;
    
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    //in the simplest, most effecient, case, reload the table view
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    //return 0;
    
    return [[self.fetchResultsController sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    //return 0;
    id <NSFetchedResultsSectionInfo> sectionInfo=[[self.fetchResultsController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

//customize the appearance of table view cells
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* CellIdentifier=@"Cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //configure the cell
    Tasks* managedTaskObject=[self.fetchResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text=managedTaskObject.text;
    
    //change the text color if the task is overdue
    if (managedTaskObject.isOverDue==[NSNumber numberWithBool:YES]) {
        cell.textLabel.textColor=[UIColor redColor];
    }
    else{
        
        cell.textLabel.textColor=[UIColor blueColor];
    }
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    //deselect the currently selected row according to the HIG
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    
//    //navigation logic may go here -- for example, create and push another view controlle
//    Tasks* managedObject=[self.fetchResultsController objectAtIndexPath:indexPath];
//    ViewTaskController* taskController=[[ViewTaskController alloc]initWithStyle:UITableViewStyleGrouped];
//    
//    taskController.managedTaskObject=managedObject;
//    taskController.managedObjectContext=self.managedObjectContext;
//    
//    [self.navigationController pushViewController:taskController animated:YES];
//}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    id <NSFetchedResultsSectionInfo> sectionInfo=[[self.fetchResultsController sections]objectAtIndex:section];
    return [sectionInfo name];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
