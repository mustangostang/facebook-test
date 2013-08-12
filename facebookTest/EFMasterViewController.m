//
//  EFMasterViewController.m
//  facebookTest
//
//  Created by Vlad Andersen on 8/7/13.
//  Copyright (c) 2013 empatika. All rights reserved.
//

#import "EFMasterViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "EFCell.h"

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
        if (error) {
            UIAlertView *networkError = [[UIAlertView alloc] initWithTitle: @"Can't open Facebook session" message: [error localizedDescription] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [networkError show];
            return;
        }
        
        [FBRequestConnection startWithGraphPath:@"me/friends" parameters: @{ @"fields": @"id,name,gender,picture" } HTTPMethod: @"GET" completionHandler:
         ^(FBRequestConnection *connection, id result, NSError *error) {
             
             if (error) {
                 UIAlertView *networkError = [[UIAlertView alloc] initWithTitle: @"Can't load Facebook friends" message: [error localizedDescription] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                 [networkError show];
                 return;
             }

             if (![result objectForKey:@"data"]) {
                 UIAlertView *networkError = [[UIAlertView alloc] initWithTitle: @"Can't load Facebook friends" message: @"Facebook returned invalid data" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                 [networkError show];
                 return;
             }
             
            NSArray* friends = [result objectForKey:@"data"];
             
            for (NSDictionary<FBGraphUser>* friend in friends) {
                for (NSUInteger i = 0; i < 10; i++) {
                    
                NSManagedObject* newFriend = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:self.managedObjectContext];
                [newFriend setValue: friend[@"id"] forKey: @"id"];
                [newFriend setValue: friend[@"name"] forKey: @"name"];
                [newFriend setValue: friend[@"gender"] forKey: @"gender"];
                [newFriend setValue: friend[@"picture"][@"data"][@"url"] forKey: @"picture"];

                }
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

- (EFCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EFCell" forIndexPath:indexPath];
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
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending: YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        UIAlertView *coreDataError = [[UIAlertView alloc] initWithTitle: @"CoreData Error" message: [error localizedDescription] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [coreDataError show];
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    return _fetchedResultsController;
}
 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

- (void)configureCell:(EFCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureWithObject: object];
}

@end
