//
//  Tasks.h
//  Task
//
//  Created by Naveen Dangeti on 30/01/17.
//  Copyright © 2017 Naveen Dangeti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define TASKS_ERROR_DOMAIN     @"com.naveen.Tasks"
#define DUEDATE_VALIDATION_ERROR_CODE    1001
#define PRIORITY_DUEDATE_VALIDATION_ERROR_CODE   1002

@class Location;

NS_ASSUME_NONNULL_BEGIN

@interface Tasks : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@property (nonatomic,retain) NSArray* highPriTasks;
@property (nonatomic,retain) NSDate* primitiveDueDate;

@end

NS_ASSUME_NONNULL_END

#import "Tasks+CoreDataProperties.h"
