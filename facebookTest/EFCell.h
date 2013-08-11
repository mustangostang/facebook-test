//
//  EFCell.h
//  facebookTest
//
//  Created by Vlad Andersen on 8/7/13.
//  Copyright (c) 2013 empatika. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userpic;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userFacebookID;
@property (weak, nonatomic) IBOutlet UILabel *userGender;

@end
