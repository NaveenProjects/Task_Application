//
//  ViewTaskController.m
//  Task
//
//  Created by Naveen Dangeti on 30/01/17.
//  Copyright © 2017 Naveen Dangeti. All rights reserved.
//

#import "ViewTaskController.h"
#import "EditTextViewController.h"
#import "EditPriorityViewController.h"
#import "EditLocationViewController.h"
#import "EditDateViewController.h"
#import "AppDelegate.h"

@interface ViewTaskController ()

@end

@implementation ViewTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Task Detail";
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //reload the data for the table to refresh from the context
    [self configureView];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"showEditTextViewController"]) {
        EditTextViewController* EditTextViewController = [segue destinationViewController];
        EditTextViewController.managedObjectContext=self.managedObjectContext;
        EditTextViewController.managedObject=self.managedTaskObject;
        EditTextViewController.keyString=@"text";
    }
    else if ([[segue identifier] isEqualToString:@"showEditPriorityViewController"]) {
        EditPriorityViewController* editPriorityViewController = [segue destinationViewController];
        editPriorityViewController.managedObjectContext=self.managedObjectContext;
        editPriorityViewController.managedTaskObject=self.managedTaskObject;
    }
    else if ([[segue identifier] isEqualToString:@"showEditLocationViewController"]) {
        EditLocationViewController* editLocationViewController = [segue destinationViewController];
        editLocationViewController.managedObjectContext=self.managedObjectContext;
        editLocationViewController.managedTaskObject=self.managedTaskObject;
    }
    else if ([[segue identifier] isEqualToString:@"showEditDateViewController"]) {
        EditDateViewController* editDateViewController = [segue destinationViewController];
        editDateViewController.managedObjectContext=self.managedObjectContext;
        editDateViewController.managedTaskObject=self.managedTaskObject;
    }
}

-(void) configureView{
    
    if (self.managedTaskObject) {
        //refresh the context
        [self.managedObjectContext refreshObject:_managedTaskObject mergeChanges:YES];
        
        //set task text
        self.taskText.text = self.managedTaskObject.text;
        
        //set priority text
        //get the priority number and convert it to a string
        NSString * priorityString=nil;
        
        switch ([self.managedTaskObject.priority intValue]) {
            case 0:
                priorityString = @"None";
                break;
            case 1:
                priorityString = @"Low";
                break;
            case 2:
                priorityString=@"Medium";
                break;
            case 3:
                priorityString=@"High";
                break;
            default:
                break;
        }
        self.taskPriority.text=priorityString;
        
        //set due date text
        //create a date formatter to format the date from the picker
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateStyle:NSDateFormatterLongStyle];
        self.taskDueDate.text = [df stringFromDate:self.managedTaskObject.dueDate];
        
        //set location text
        Location* locationObject = self.managedTaskObject.location;
        if (locationObject!=nil) {
            self.taskLocation.text = locationObject.name;
        }
        else{
            self.taskLocation.text=@"Not Set";
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //deslect the currently selected ro according to the HIG
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //based on the selected row take some action
    
    if (indexPath.row==4) {
        //UIAlertController* alert =[[UIAlertController alloc]init];
        
        NSString* title=@"Hi-Pri Tasks";
        //NSString* message=nil;
        NSString* okButnTxt=@"OK";
        
        UIAlertController* alert=[UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton=[UIAlertAction actionWithTitle:okButnTxt style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okButton];
        
        //[self presentViewController:alert animated:YES completion:nil];
        
        NSArray* hiPriTasks = self.managedTaskObject.highPriTasks;
        NSMutableString* message=[[NSMutableString alloc]init];
        
        //loop through the each high priority task to create the string for the message
        
        for (Tasks* theTask in hiPriTasks) {
            [message appendString:theTask.text];
            [message appendString:@"\n"];
        }
        
        alert.message=message;
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else if (indexPath.row == 5){
        
        NSString* title=@"Tasks Due Sooner Than This";
        //NSString* message=nil;
        NSString* okButnTxt=@"OK";
        
        UIAlertController* alert=[UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton=[UIAlertAction actionWithTitle:okButnTxt style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okButton];
        NSMutableString* message=[[NSMutableString alloc]init];

        //need to get a handle to the managedObjectModel to user the stored fetch request
        AppDelegate* appDelegate=[UIApplication sharedApplication].delegate;
        NSManagedObjectModel* model=appDelegate.managedObjectModel;
        
        //get the stored fetch request
        NSDictionary* dict=[[NSDictionary alloc]initWithObjectsAndKeys:self.managedTaskObject.dueDate,@"DUE_DATE", nil];
        NSFetchRequest* request=[model fetchRequestFromTemplateWithName:@"tasksDueSooner" substitutionVariables:dict];
        
        NSError* error;
        NSArray* results=[self.managedObjectContext executeFetchRequest:request error:&error];
        
        //loop through each task to create the string for the message
        for (Tasks* theTask in results) {
            [message appendString:theTask.text];
            [message appendString:@"\n"];
        }
        
        alert.message=message;
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 6;
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
