//
//  EditTextViewController.h
//  Task
//
//  Created by Naveen Dangeti on 30/01/17.
//  Copyright © 2017 Naveen Dangeti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tasks.h"
#import "Location.h"

@interface EditTextViewController : UITableViewController

@property (nonatomic,retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,retain) NSManagedObject* managedObject;
@property (nonatomic,strong) NSString* keyString;
@property (weak,nonatomic) IBOutlet UITextField *textField;

@end
