//
//  EFCell.m
//  facebookTest
//
//  Created by Vlad Andersen on 8/7/13.
//  Copyright (c) 2013 empatika. All rights reserved.
//

#import "EFCell.h"
#import <UIImageView+AFNetworking.h>

@implementation EFCell

- (void)configureWithObject: (NSManagedObject*) object
{
    self.userName.text = [[object valueForKey:@"name"] description];
    
    NSDictionary* genderMap = @{ @"male": @"♂", @"female": @"♀" };
    self.userGender.text = @"?";
    if (genderMap[[object valueForKey:@"gender"]]) {
        self.userGender.text = genderMap[[object valueForKey:@"gender"]];
    }
    self.userFacebookID.text = [[object valueForKey:@"id"] description];
    [self.userpic setImageWithURL: [NSURL URLWithString: [object valueForKey:@"picture"]]];

}

@end
