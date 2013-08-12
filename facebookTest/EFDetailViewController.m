//
//  EFDetailViewController.m
//  facebookTest
//
//  Created by Vlad Andersen on 8/7/13.
//  Copyright (c) 2013 empatika. All rights reserved.
//

#import "EFDetailViewController.h"
#import "EFGenderSelectViewController.h"
#import "EFAppDelegate.h"
#import "EFFriend.h"

@interface EFDetailViewController ()
- (void)configureView;
@end

@implementation EFDetailViewController

#pragma mark - Managing the detail item

- (void)setFriendItem:(EFFriend *) newFriendItem
{
    if (_friendItem != newFriendItem) {
        _friendItem = newFriendItem;
        [self configureView];
    }
}

- (IBAction)saveFriend: (id)sender
{
    self.friendItem.facebookId = self.friendFacebookId.text;
    self.friendItem.name       = self.friendName.text;
    self.friendItem.gender     = self.friendGender.text;
    self.friendItem.picture    = self.friendUserpic.text;
    
    NSError *error = nil;
    if (![self.friendItem validateForUpdate: &error]) {
        UIAlertView *networkError = [[UIAlertView alloc] initWithTitle: @"Core Data Error" message: [error localizedDescription] delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [networkError show];
        NSLog (@"Core Data error: %@", error);
        [EFFriend rollback];
        return;
    }
    
    [EFFriend commit];
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.friendItem) {
        self.friendFacebookId.text = self.friendItem.facebookId;
        self.friendName.text = self.friendItem.name;
        self.friendGender.text = self.friendItem.gender;
        self.friendUserpic.text = self.friendItem.picture;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_GENDER_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGender:) name:NOTIFICATION_GENDER_CHANGED object:nil];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)updateGender:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    self.friendGender.text = info[@"gender"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"sexView"]) {
        EFGenderSelectViewController* destinationController = [segue destinationViewController];
        destinationController.selectedGender = self.friendGender.text;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
