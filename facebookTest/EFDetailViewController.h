//
//  EFDetailViewController.h
//  facebookTest
//
//  Created by Vlad Andersen on 8/7/13.
//  Copyright (c) 2013 empatika. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UITextField *friendName;
@property (weak, nonatomic) IBOutlet UITextField *friendFacebookId;
@property (weak, nonatomic) IBOutlet UITextField *friendGender;
@property (weak, nonatomic) IBOutlet UITextField *friendUserpic;
@end
