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

@dynamic gender;
@dynamic name;
@dynamic facebookId;
@dynamic picture;

#pragma mark - Validations

-(BOOL)validateGender:(id *)incomingValue error:(NSError **)outError {
    NSString *gender = *incomingValue;
    if (!gender) return YES;
    if ([gender isEqualToString: @"male"] || [gender isEqualToString: @"female"] || [gender isEqualToString: @"unknown"]) {
        return YES;
    }
    *outError = [NSError errorWithDomain:@"com.empatika.facebookTest" code:1 userInfo: @{ NSLocalizedDescriptionKey: [NSString stringWithFormat: @"Unknown gender: %@", gender ]}];
    return NO;
}

-(BOOL)validateName:(id *)incomingValue error:(NSError **)outError {
    NSString *name = *incomingValue;
    if (!name) return YES;
    name = [name stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if (![name isEqualToString: @""]) {
        return YES;
    }
    *outError = [NSError errorWithDomain:@"com.empatika.facebookTest" code:2 userInfo: @{ NSLocalizedDescriptionKey: @"Name could not be empty." }];
    return NO;
}

-(BOOL)validateFacebookId:(id *)incomingValue error:(NSError **)outError {
    NSString *facebookId = *incomingValue;
    if (!facebookId) return YES;
    facebookId = [facebookId stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    if (![facebookId isEqualToString: @""]) {
        return YES;
    }
    *outError = [NSError errorWithDomain:@"com.empatika.facebookTest" code:3 userInfo: @{ NSLocalizedDescriptionKey: @"Facebook ID could not be empty." }];
    return NO;
}

-(BOOL)validatePicture:(id *)incomingValue error:(NSError **)outError {
    NSString *picture = *incomingValue;
    if (!picture) return YES;
    if ([NSURL URLWithString: picture]) return YES;
    *outError = [NSError errorWithDomain:@"com.empatika.facebookTest" code:4 userInfo: @{ NSLocalizedDescriptionKey: @"Invalid URL for picture." }];
    return NO;
}

#pragma mark - Shortcuts for Core Data

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

+ (EFFriend *)insertInContext: (NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName: MODEL_NAME inManagedObjectContext: context];
}


// Shortcut for [AppDelegate saveContext]
+ (void)commit
{
    EFAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    [delegate saveContext];
}

// Shortcut for [AppDelegate saveContext]
+ (void)rollback
{
    EFAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    [delegate.managedObjectContext rollback];
}

@end
