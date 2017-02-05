//
//  Tasks.m
//  Task
//
//  Created by Naveen Dangeti on 30/01/17.
//  Copyright © 2017 Naveen Dangeti. All rights reserved.
//

#import "Tasks.h"
#import "Location.h"

@implementation Tasks

// Insert code here to add functionality to your managed object subclass
@dynamic highPriTasks;
@dynamic primitiveDueDate;


-(NSNumber *) isOverDue{
    
    BOOL isTaskOverDue = NO;
    
    NSDate* today=[NSDate date];
    if (self.dueDate!=nil) {
        if ([self.dueDate compare:today]==NSOrderedAscending) {
            isTaskOverDue=YES;
        }
    }
    
    return [NSNumber numberWithBool:isTaskOverDue];
}

-(void)awakeFromInsert{
    
    //core data calls this function first time the receiver is inserted into a context
    [super awakeFromInsert];
    
    //set due date date to 3 days from now (in seconds)
    
    NSDate* defaultDate=[[NSDate alloc]initWithTimeIntervalSinceNow:60*60*24*3];
    
    //use custom primitive accesor to set Due date field
    
    self.primitiveDueDate=defaultDate;
    
}


-(BOOL)validateDueDate:(id*)ioValue error:(NSError **)outError{
    
    //Due dates in the past are not valid
    //enforce that a due date has to be >=today's date
    if ([*ioValue compare:[NSDate date]]==NSOrderedAscending) {
        if (outError!=NULL) {
            NSString* errorStr=@"Due date must be today or later";
            NSDictionary* userInfoDictionary=[NSDictionary dictionaryWithObject:errorStr forKey:@"ErrorString"];
            NSError* error=[[NSError alloc]initWithDomain:TASKS_ERROR_DOMAIN code:DUEDATE_VALIDATION_ERROR_CODE userInfo:userInfoDictionary];
            *outError=error;
        }
        return NO;
    }
    else{
        
        return YES;
    }
}


-(BOOL)validateAllData:(NSError **)outError{
    
    NSDate* compareDate=[[NSDate alloc]initWithTimeIntervalSinceNow:60*60*24*3];
    //due dates for the hi priority tasks must be today, tomorrow, or the next day
    if ([self.dueDate compare:compareDate]==NSOrderedDescending && [self.priority intValue]==3) {
        if (outError!=NULL) {
            NSString* errorStr=@"Hi-Pri tasks must have a due date within two days of today";
            NSDictionary* userInfoDictionary=[NSDictionary dictionaryWithObject:errorStr forKey:@"ErrorString"];
            NSError* error=[[NSError alloc]initWithDomain:TASKS_ERROR_DOMAIN code:PRIORITY_DUEDATE_VALIDATION_ERROR_CODE userInfo:userInfoDictionary];
            *outError=error;
        }
        return NO;
    }
    else{
        
        return YES;
    }
}

-(BOOL)validateForInsert:(NSError **)outError{
    
    //call the superclass validateForInsert first
    if ([super validateForInsert:outError]==NO) {
        return NO;
    }
    
    //call out validation function
    if ([self validateAllData:outError]==NO) {
        return NO;
    }
    else{
        return YES;
    }
    
}


-(BOOL)validateForUpdate:(NSError **)outError{
    
    //call the superclass validateForUpdate first
    if ([super validateForUpdate:outError]==NO) {
        return NO;
    }
    
    //call out validation function
    if ([self validateAllData:outError]==NO) {
        return NO;
    }
    else{
        return YES;
    }
    
}

@end
