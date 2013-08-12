//
//  EFGenderSelectViewController.m
//  facebookTest
//
//  Created by Vlad Andersen on 8/12/13.
//  Copyright (c) 2013 empatika. All rights reserved.
//

#import "EFGenderSelectViewController.h"

@interface EFGenderSelectViewController ()

@end

@implementation EFGenderSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.genderValues = @{ @"male": @"Male", @"female": @"Female", @"unknown": @"Unknown (UFO)" };
    self.genderKeys   = @[ @"male", @"female", @"unknown" ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.genderKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EFSexCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSUInteger position = [indexPath indexAtPosition: 1];
    NSString *key = [self.genderKeys objectAtIndex: position];
    cell.textLabel.text = self.genderValues[key];
    
    cell.accessoryType = [self.selectedGender isEqualToString: key] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger position = [indexPath indexAtPosition: 1];
    NSString *selectedKey = [self.genderKeys objectAtIndex: position];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"UPDATE_GENDER" object: nil userInfo: @{ @"gender": selectedKey } ];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
