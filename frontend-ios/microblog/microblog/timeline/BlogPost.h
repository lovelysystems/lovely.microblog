//  Copyright (c) 2014 lovelysystems. All rights reserved.

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface BlogPost : NSObject

@property(nonatomic, copy) NSString* blogPostId;
@property(nonatomic, copy) NSDate* created;
@property(nonatomic, copy) NSString* text;
@property(nonatomic, copy) NSString* creator;

+(RKObjectMapping *)mapping;

@end
