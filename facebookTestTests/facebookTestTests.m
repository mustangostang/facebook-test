//
//  facebookTestTests.m
//  facebookTestTests
//
//  Created by Vlad Andersen on 8/7/13.
//  Copyright (c) 2013 empatika. All rights reserved.
//

#import "facebookTestTests.h"
#import "EFAppDelegate.h"
#import "EFFriend.h"

@implementation facebookTestTests

- (void)setUp
{
    [super setUp];
    EFAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    // Sample data
    
    for (NSManagedObject* friend in [self all]) {
        [self.managedObjectContext deleteObject: friend];
    }
    
    NSManagedObject* jane = [EFFriend insertInContext: self.managedObjectContext];
    [jane setValue: @"1928202810" forKey: @"id"];
    [jane setValue: @"Jane Doe" forKey: @"name"];
    [jane setValue: @"female" forKey: @"gender"];
    [jane setValue: @"http://fc01.deviantart.net/fs71/i/2011/192/1/7/jane_doe_digital_painting_by_jennyjen91-d3n7qch.jpg" forKey: @"picture"];
    
    NSManagedObject* john = [EFFriend insertInContext: self.managedObjectContext];
    [john setValue: @"7778261" forKey: @"id"];
    [john setValue: @"John Smith" forKey: @"name"];
    [john setValue: @"male" forKey: @"gender"];
    [john setValue: @"http://www.adweek.com/files/imagecache/node-blog/blogs/ge_agent_smith.jpg" forKey: @"picture"];
    
    [EFFriend commit];

}

// All records in CoreData
- (NSArray*)all
{
    NSFetchRequest* allFriendsFetchRequest = [EFFriend fetchRequestForContext: self.managedObjectContext];
    return [EFFriend executeFetchRequest: allFriendsFetchRequest ForContext: self.managedObjectContext];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCount
{
    NSLog (@"%@", [self all]);
    STAssertTrue([[self all] count] == 2, @"Count of friends at start");
}

- (void)testDelete
{
    for (NSManagedObject* friend in [self all]) {
        [self.managedObjectContext deleteObject: friend];
    }
    [EFFriend commit];
    STAssertTrue([[self all] count] == 0, @"Count of friends after deleting all");
}

- (void) testAdd
{
    NSManagedObject* barak = [EFFriend insertInContext: self.managedObjectContext];
    [barak setValue: @"1231313" forKey: @"id"];
    [barak setValue: @"Barak Obama" forKey: @"name"];
    [barak setValue: @"male" forKey: @"gender"];
    [barak setValue: @"http://www.adweek.com/files/imagecache/node-blog/blogs/ge_agent_smith.jpg" forKey: @"picture"];
    
    [EFFriend commit];
    
    STAssertTrue([[self all] count] == 3, @"Count of friends after inserting");
}

- (void) testSort
{
    NSManagedObject* barak = [EFFriend insertInContext: self.managedObjectContext];
    [barak setValue: @"1231313" forKey: @"id"];
    [barak setValue: @"Barak Obama" forKey: @"name"];
    [barak setValue: @"male" forKey: @"gender"];
    [barak setValue: @"http://www.adweek.com/files/imagecache/node-blog/blogs/ge_agent_smith.jpg" forKey: @"picture"];    
    
    NSFetchRequest* fetchRequest = [EFFriend fetchRequestForContext: self.managedObjectContext];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending: YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *friends = [EFFriend executeFetchRequest: fetchRequest ForContext: self.managedObjectContext];
    NSManagedObject *obama = [friends objectAtIndex: 0];
    STAssertTrue([[obama valueForKey: @"name"] isEqualToString: @"Barak Obama"], @"Correct sort");
}

- (void) testChange
{
    NSManagedObject *jane = [[self all] objectAtIndex: 0];
    STAssertTrue([[jane valueForKey: @"name"] isEqualToString: @"Jane Doe"], @"Default sort");
    STAssertTrue([[jane valueForKey: @"id"] isEqualToString: @"1928202810"], @"Default value");
    
    [jane setValue: @"600600" forKey: @"id"];
    [EFFriend commit];
    
    NSManagedObject *changedJane = [[self all] objectAtIndex: 0];
    STAssertTrue([[changedJane valueForKey: @"name"] isEqualToString: @"Jane Doe"], @"After change");
    STAssertTrue([[changedJane valueForKey: @"id"] isEqualToString: @"600600"], @"After change");
    
    
}



@end
