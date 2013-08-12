//
//  EFFriend.h
//  facebookTest
//
//  Created by Vlad Andersen on 8/12/13.
//  Copyright (c) 2013 empatika. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFFriend : NSManagedObject


+ (NSFetchRequest *) fetchRequestForContext: (NSManagedObjectContext *)context;
+ (NSArray *)executeFetchRequest: (NSFetchRequest *) request ForContext: (NSManagedObjectContext *)context;
+ (EFFriend *)insertInContext: (NSManagedObjectContext *)context;
+ (void)commit;
+ (void)rollback;

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* gender;
@property (strong, nonatomic) NSString* facebookId;
@property (strong, nonatomic) NSString* picture;

@end
