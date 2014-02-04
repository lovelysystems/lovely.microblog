//  Copyright (c) 2014 lovelysystems.

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface User : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* password;

+ (RKObjectMapping*)mapping;

@end
