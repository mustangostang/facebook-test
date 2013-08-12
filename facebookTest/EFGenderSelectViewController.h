//
//  EFGenderSelectViewController.h
//  facebookTest
//
//  Created by Vlad Andersen on 8/12/13.
//  Copyright (c) 2013 empatika. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFGenderSelectViewController : UITableViewController

@property (strong, nonatomic) NSString* selectedGender;

@property (strong, nonatomic) NSDictionary* genderValues;
@property (strong, nonatomic) NSArray* genderKeys;

@end
