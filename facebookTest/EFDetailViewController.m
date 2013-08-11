//
//  EFDetailViewController.m
//  facebookTest
//
//  Created by Vlad Andersen on 8/7/13.
//  Copyright (c) 2013 empatika. All rights reserved.
//

#import "EFDetailViewController.h"

@interface EFDetailViewController ()
- (void)configureView;
@end

@implementation EFDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.friendFacebookId.text = [[self.detailItem valueForKey:@"id"] description];
        self.friendName.text = [[self.detailItem valueForKey:@"name"] description];
        self.friendGender.text = [[self.detailItem valueForKey:@"gender"] description];
        self.friendUserpic.text = [[self.detailItem valueForKey:@"picture"] description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
