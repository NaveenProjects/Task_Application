//
//  EditLocationViewController.m
//  Task
//
//  Created by Naveen Dangeti on 02/02/17.
//  Copyright © 2017 Naveen Dangeti. All rights reserved.
//

#import "EditLocationViewController.h"
#import "EditTextViewController.h"

@interface EditLocationViewController ()

@end

@implementation EditLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Set up the Add Button
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewLocation)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    NSError* error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    
    
    //set the title to the display in the navigation bar.
    self.title=@"Location";
}

- (void)insertNewLocation {
    
    NSManagedObjectContext* context = self.managedObjectContext;
    
    Location* newLocation = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    EditTextViewController* textController= [sb instantiateViewControllerWithIdentifier:@"EditTextViewController"];
    
    textController.managedObject=newLocation;
    textController.managedObjectContext=self.managedObjectContext;
    textController.keyString=@"name";
    
    [self.navigationController pushViewController:textController animated:YES];
    
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return  _fetchedResultsController;
    }
    
    //setup the fetched results controller
    //create the fetch request for the entity
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    //edit the entity name as appropriate
    NSEntityDescription* entity=[NSEntityDescription entityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    //edit the sort key as appropriate
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //edit the section name key path and cache name if approproate
    //nil for section name key path means "no sections."
    NSFetchedResultsController* aFetchResultsController=[[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchResultsController.delegate = self;
    _fetchedResultsController=aFetchResultsController;
    return _fetchedResultsController;
    
}

//NSFetchResultsControllerDelegate method to notify the delegate
//that all section and object changes have been processed

-(void)controllerDidChangeContent:(NSFetchedResultsController*)controller{
    
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
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    //return 0;
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

//customize the appearance of table view cells

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellIdentifier=@"cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Location* managedLocationObject=[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    //if the location in the task object is the same as the location object draw the check mark
    if (self.managedTaskObject.location==managedLocationObject) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    
    cell.textLabel.text=managedLocationObject.name;
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //deselect the curently selected row according to the HIG
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //set the task's location to the chosen location
    Location* newLocationObject=[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    self.managedTaskObject.location=newLocationObject;
    
    //save the context
    
    NSError* error=nil;
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        abort();
    }
    else{
        //pop the view
        [self.navigationController popViewControllerAnimated:YES];
    }
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSManagedObjectContext* context=[self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        
        //save the context
        
        NSError* error=nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
