//
//  EFMasterViewController.m
//  facebookTest
//
//  Created by Vlad Andersen on 8/7/13.
//  Copyright (c) 2013 empatika. All rights reserved.
//

#import "EFMasterViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#import "EFDetailViewController.h"
#import "EFAppDelegate.h"

@interface EFMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation EFMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
     
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    UIBarButtonItem *refreshFromFacebookButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshFromFacebook:)];
    self.navigationItem.rightBarButtonItem = refreshFromFacebookButton;
}

- (void)refreshFromFacebook: (UIControl*)sender
{
    
    // Delete all existing friends
    NSFetchRequest *allFriends = [[NSFetchRequest alloc] init];
    [allFriends setEntity:[NSEntityDescription entityForName:@"Friend" inManagedObjectContext:self.managedObjectContext]];
    [allFriends setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *friends = [self.managedObjectContext executeFetchRequest:allFriends error:&error];
    //error handling goes here
    for (NSManagedObject *friend in friends) {
        [self.managedObjectContext deleteObject: friend];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
    
    // Add new
    
    [FBSession openActiveSessionWithReadPermissions: nil allowLoginUI: YES completionHandler: ^(FBSession *session, FBSessionState status, NSError *error) {
        [FBRequestConnection startWithGraphPath:@"me/friends" parameters: @{ @"fields": @"id,name,gender,picture" } HTTPMethod: @"GET" completionHandler:
         ^(FBRequestConnection *connection, id result, NSError *error) {
            NSArray* friends = [result objectForKey:@"data"];
            NSLog(@"Found: %i friends", friends.count);
            for (NSDictionary<FBGraphUser>* friend in friends) {
                for (NSUInteger i = 0; i < 10; i++) {
                //    NSString *friendId = [NSString stringWithFormat: @"%@ (%d)", friend[@"id"], i];
                
                    
                NSManagedObject* newFriend = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:self.managedObjectContext];
                [newFriend setValue: friend[@"id"] forKey: @"id"];
                [newFriend setValue: friend[@"name"] forKey: @"name"];
                [newFriend setValue: friend[@"gender"] forKey: @"gender"];
                [newFriend setValue: friend[@"picture"][@"data"][@"url"] forKey: @"picture"];

                }
                    
                
                NSLog(@"%@", friend);
                NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
                
                
                
            }
             
             NSError *saveError = nil;
             [self.managedObjectContext save:&saveError];
             
             
        }];
    }];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}
 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"name"] description];
}

@end
