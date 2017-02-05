//
//  EditDateViewController.m
//  Task
//
//  Created by Naveen Dangeti on 05/02/17.
//  Copyright © 2017 Naveen Dangeti. All rights reserved.
//

#import "EditDateViewController.h"

@interface EditDateViewController ()

@end

@implementation EditDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Add the save button
    UIBarButtonItem* saveButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector (saveButtonPressed:)];
    self.navigationItem.rightBarButtonItem=saveButton;
    //set the date to the one in the managed object, if it is set.
    //Else, set it to today
    NSDate* objectDate=self.managedTaskObject.dueDate;
    if (objectDate!=nil) {
        self.datePicker.date=objectDate;
    }
    
    else{
        
        self.datePicker.date=[NSDate date];
    }
}


-(void) saveButtonPressed: (id) sender{
  //configure the managed object
    self.managedTaskObject.dueDate=[self.datePicker date];
    //save the context
    NSError* error=nil;
    if(![self.managedObjectContext save:&error]){
        //there was an error validating the date
        //displaying the error information
        /*UIAlertView* alert=[[UIALertView alloc]initWithTitle:@"Invalid Due Date"
        message:[[error userINfo] valueForKey:@"errorString"]
         delegate:nil cancelButtonTitle:@"OK" otherButtonTitle:nil];
         [alert show]
         */
         //rollback the context to
        //revert to the original date
        //[self.managedObjectContext rollback];
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
    }
    else{
        
        
        //pop the view
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

-(IBAction)dateChanged:(id)sender;
{
    
    //refresh the date display
    [self.tv reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* CellIdentifier=@"Cell";
    
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //setup the cell
    if (indexPath.row==0) {
        //create the date formatter to format the date from the picker
        NSDateFormatter* df=[[NSDateFormatter alloc]init];
        [df setDateStyle:NSDateFormatterLongStyle];
        cell.textLabel.text=[df stringFromDate:self.datePicker.date];
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
