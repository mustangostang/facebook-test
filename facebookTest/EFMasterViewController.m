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
#import "EFFriend.h"

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
    UIBarButtonItem *refreshFromFacebookButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshFromFacebook:)];
    self.navigationItem.rightBarButtonItem = refreshFromFacebookButton;
}

- (void)refreshFromFacebook: (UIControl*)sender
{
    
    // Delete all existing friends
    
    NSFetchRequest* allFriendsFetchRequest = [EFFriend fetchRequestForContext: self.managedObjectContext];
    allFriendsFetchRequest.includesPropertyValues = NO;
    for (EFFriend* friend in [EFFriend executeFetchRequest: allFriendsFetchRequest ForContext: self.managedObjectContext]) {
        [self.managedObjectContext deleteObject: friend];
    }
    [EFFriend commit];

    
    // Add friends from Facebook
    
    if (FBSession.activeSession.isOpen) {
        [self getFriends];
        return;
    }
    
    [FBSession openActiveSessionWithReadPermissions: nil allowLoginUI: YES completionHandler: ^(FBSession *session, FBSessionState status, NSError *error) {
        if (error) {
            UIAlertView *networkError = [[UIAlertView alloc] initWithTitle: @"Can't open Facebook session" message: [error localizedDescription] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [networkError show];
            NSLog (@"Facebook session error: %@", error);
            return;
        }
        [self getFriends];
    }];
    
}

- (void) getFriends
{
    [FBRequestConnection startWithGraphPath:@"me/friends" parameters: @{ @"fields": @"id,name,gender,picture" } HTTPMethod: @"GET" completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         
         if (error) {
             UIAlertView *networkError = [[UIAlertView alloc] initWithTitle: @"Can't load Facebook friends" message: [error localizedDescription] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
             [networkError show];
             NSLog (@"Facebook error: %@", error);
             return;
         }
         
         if (![result objectForKey:@"data"]) {
             UIAlertView *networkError = [[UIAlertView alloc] initWithTitle: @"Can't load Facebook friends" message: @"Facebook returned invalid data" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
             [networkError show];
             NSLog (@"Facebook no data error: %@", error);
             return;
         }
         
         NSArray* friends = [result objectForKey:@"data"];
         
         for (NSDictionary<FBGraphUser>* friend in friends) {
             for (NSUInteger i = 0; i < 10; i++) {
                 EFFriend* newFriend = [EFFriend insertInContext: self.managedObjectContext];
                 newFriend.facebookId = friend[@"id"];
                 newFriend.name       = friend[@"name"];
                 newFriend.gender     = friend[@"gender"];
                 newFriend.picture    = friend[@"picture"][@"data"][@"url"];
                 NSError *error = nil;
                 if (![newFriend validateForInsert: &error]) {
                     UIAlertView *networkError = [[UIAlertView alloc] initWithTitle: @"Core Data Error" message: [error localizedDescription] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                     [networkError show];
                     NSLog (@"Core Data error: %@", error);
                     [EFFriend rollback];
                     return;
                 }
             }
         }
         
         [EFFriend commit];
         
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        EFFriend *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        EFDetailViewController* destinationController = [segue destinationViewController];
        destinationController.friendItem = object;
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest = [EFFriend fetchRequestForContext: self.managedObjectContext];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending: YES];
    NSArray *sortDescriptors = @[sortDescriptor];    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
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
    EFFriend *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureWithObject: object];
}

@end
