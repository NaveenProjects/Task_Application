//
//  EditDateViewController.h
//  Task
//
//  Created by Naveen Dangeti on 05/02/17.
//  Copyright © 2017 Naveen Dangeti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tasks.h"

@interface EditDateViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) Tasks* managedTaskObject;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong) IBOutlet UIDatePicker* datePicker;
@property (nonatomic,strong) IBOutlet UITableView* tv;

-(IBAction)dateChanged:(id)sender;

@end
