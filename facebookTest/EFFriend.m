//
//  EFFriend.m
//  facebookTest
//
//  Created by Vlad Andersen on 8/12/13.
//  Copyright (c) 2013 empatika. All rights reserved.
//

#import "EFFriend.h"
#import "EFAppDelegate.h"

NSString *const MODEL_NAME = @"Friend";

@implementation EFFriend

+ (NSFetchRequest *) fetchRequestForContext: (NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:MODEL_NAME inManagedObjectContext: context]];
    return fetchRequest;
}

+ (NSArray *)executeFetchRequest: (NSFetchRequest *) request ForContext: (NSManagedObjectContext *)context
{
    NSError *error = nil;
    NSArray *friends = [context executeFetchRequest:request error:&error];
    
    if (error) {
        UIAlertView *coreDataError = [[UIAlertView alloc] initWithTitle: @"CoreData Error" message: [error localizedDescription] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [coreDataError show];
        NSLog(@"CoreData error %@, %@", error, [error userInfo]);
        }
    
    return friends;
}

+ (NSManagedObject *)insertInContext: (NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName: MODEL_NAME inManagedObjectContext: context];
}


// Shortcut for [AppDelegate saveContext]
+ (void)commit
{
    EFAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    [delegate saveContext];
}


@end
