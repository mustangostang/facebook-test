//
//  EFCell.m
//  facebookTest
//
//  Created by Vlad Andersen on 8/7/13.
//  Copyright (c) 2013 empatika. All rights reserved.
//

#import "EFCell.h"
#import "EFFriend.h"
#import <UIImageView+AFNetworking.h>

@implementation EFCell

- (void)configureWithObject: (EFFriend*) object
{
    self.userName.text = object.name;
    
    NSDictionary* genderMap = @{ @"male": @"♂", @"female": @"♀" };
    self.userGender.text = @"?";
    if (genderMap[object.gender]) {
        self.userGender.text = genderMap[object.gender];
    }
    self.userFacebookID.text = object.facebookId;
    [self.userpic setImageWithURL: [NSURL URLWithString: object.picture]];

}

@end
