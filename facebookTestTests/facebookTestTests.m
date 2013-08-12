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
    
    for (EFFriend* friend in [self all]) {
        [self.managedObjectContext deleteObject: friend];
    }
    
    EFFriend* jane = [EFFriend insertInContext: self.managedObjectContext];
    jane.facebookId = @"1928202810";
    jane.name       = @"Jane Doe";
    jane.gender     = @"female";
    jane.picture    = @"http://fc01.deviantart.net/fs71/i/2011/192/1/7/jane_doe_digital_painting_by_jennyjen91-d3n7qch.jpg";
    
    EFFriend* john = [EFFriend insertInContext: self.managedObjectContext];
    john.facebookId = @"7778261";
    john.name       = @"John Smith";
    john.gender     = @"male";
    john.picture    = @"http://www.adweek.com/files/imagecache/node-blog/blogs/ge_agent_smith.jpg";
    
    [EFFriend commit];

}

// All records in CoreData
- (NSArray*)all
{
    NSFetchRequest* allFriendsFetchRequest = [EFFriend fetchRequestForContext: self.managedObjectContext];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending: YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [allFriendsFetchRequest setSortDescriptors:sortDescriptors];
    return [EFFriend executeFetchRequest: allFriendsFetchRequest ForContext: self.managedObjectContext];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCount
{
    // NSLog (@"%@", [self all]);
    STAssertTrue([[self all] count] == 2, @"Count of friends at start");
}

- (void)testDelete
{
    for (EFFriend* friend in [self all]) {
        [self.managedObjectContext deleteObject: friend];
    }
    [EFFriend commit];
    STAssertTrue([[self all] count] == 0, @"Count of friends after deleting all");
}

- (void) testAdd
{
    EFFriend* barak = [EFFriend insertInContext: self.managedObjectContext];
    barak.facebookId = @"1231313";
    barak.name       = @"Barak Obama";
    barak.gender     = @"male";
    barak.picture    = @"http://www.adweek.com/files/imagecache/node-blog/blogs/ge_agent_smith.jpg";    
    [EFFriend commit];
    
    STAssertTrue([[self all] count] == 3, @"Count of friends after inserting");
}

- (void) testSort
{
    EFFriend* barak = [EFFriend insertInContext: self.managedObjectContext];
    barak.facebookId = @"1231313";
    barak.name       = @"Barak Obama";
    barak.gender     = @"male";
    barak.picture    = @"http://www.adweek.com/files/imagecache/node-blog/blogs/ge_agent_smith.jpg";
    
    EFFriend *obama = [[self all] objectAtIndex: 0];
    STAssertTrue([obama.name isEqualToString: @"Barak Obama"], @"Correct sort");
}

- (void) testChange
{
    EFFriend *jane = [[self all] objectAtIndex: 0];
    STAssertTrue([jane.name isEqualToString: @"Jane Doe"], @"Default sort");
    STAssertTrue([jane.facebookId isEqualToString: @"1928202810"], @"Default value");
    
    jane.facebookId = @"600600";
    [EFFriend commit];
    
    EFFriend *changedJane = [[self all] objectAtIndex: 0];
    STAssertTrue([changedJane.name isEqualToString: @"Jane Doe"], @"After change");
    STAssertTrue([changedJane.facebookId isEqualToString: @"600600"], @"After change");
    
}

- (void) testFailingGender
{
    
    EFFriend* barak = [EFFriend insertInContext: self.managedObjectContext];
    barak.facebookId = @"1231313";
    barak.name       = @"Barak Obama";
    barak.gender     = @"kangooroo";
    barak.picture    = @"http://www.adweek.com/files/imagecache/node-blog/blogs/ge_agent_smith.jpg";
    NSError *error = nil;
    STAssertFalse ([barak validateForInsert: &error], @"Invalid gender");
    
    
    EFFriend* obama = [EFFriend insertInContext: self.managedObjectContext];
    obama.facebookId = @"1231313";
    obama.name       = @"Barak Obama";
    obama.gender     = @"male";
    obama.picture    = @"http://www.adweek.com/files/imagecache/node-blog/blogs/ge_agent_smith.jpg";
    error = nil;
    STAssertTrue ([obama validateForInsert: &error], @"Valid gender");
    
    obama.gender     = @"butterfly";
    error = nil;
    STAssertFalse ([obama validateForUpdate: &error], @"Invalid gender");
    
}


@end
