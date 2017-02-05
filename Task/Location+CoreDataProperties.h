//
//  Location+CoreDataProperties.h
//  Task
//
//  Created by Naveen Dangeti on 30/01/17.
//  Copyright © 2017 Naveen Dangeti. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *tasks;

@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addTasksObject:(NSManagedObject *)value;
- (void)removeTasksObject:(NSManagedObject *)value;
- (void)addTasks:(NSSet<NSManagedObject *> *)values;
- (void)removeTasks:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
