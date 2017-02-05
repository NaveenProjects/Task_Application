//
//  ViewTaskController.h
//  Task
//
//  Created by Naveen Dangeti on 30/01/17.
//  Copyright © 2017 Naveen Dangeti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tasks.h"
#import "Location.h"

@interface ViewTaskController : UITableViewController

@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain) Tasks* managedTaskObject;
@property (strong, nonatomic) IBOutlet UILabel *taskText;
@property (strong, nonatomic) IBOutlet UILabel *taskPriority;
@property (strong, nonatomic) IBOutlet UILabel *taskDueDate;

@property (strong, nonatomic) IBOutlet UILabel *taskLocation;

@end
