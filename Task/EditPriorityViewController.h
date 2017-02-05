//
//  EditPriorityViewController.h
//  Task
//
//  Created by Naveen Dangeti on 30/01/17.
//  Copyright © 2017 Naveen Dangeti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tasks.h"

@interface EditPriorityViewController : UITableViewController

@property (nonatomic,retain) Tasks* managedTaskObject;
@property (nonatomic,retain) NSManagedObjectContext* managedObjectContext;
@property (weak,nonatomic) IBOutlet UITableViewCell* priNone;
@property (weak,nonatomic) IBOutlet UITableViewCell* priLow;
@property (weak,nonatomic) IBOutlet UITableViewCell* priMedium;
@property (weak,nonatomic) IBOutlet UITableViewCell* priHigh;
@end
