//
//  Tasks+CoreDataProperties.h
//  Task
//
//  Created by Naveen Dangeti on 30/01/17.
//  Copyright © 2017 Naveen Dangeti. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tasks.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tasks (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *dueDate;
@property (nullable, nonatomic, retain) NSNumber *isOverDue;
@property (nullable, nonatomic, retain) NSNumber *priority;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) Location *location;

@end

NS_ASSUME_NONNULL_END
