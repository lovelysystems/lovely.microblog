//  Copyright (c) 2014 lovelysystems.

#import "User.h"

@implementation User

+(RKObjectMapping *)mapping {
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[User class]];
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"name": @"name",
                                                  @"password": @"password"
                                                  }];
    return mapping;
}

@end
