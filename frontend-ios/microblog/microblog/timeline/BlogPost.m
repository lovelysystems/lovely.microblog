//  Copyright (c) 2014 lovelysystems. All rights reserved.

#import "BlogPost.h"

@implementation BlogPost

+(RKObjectMapping*)mapping {
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[BlogPost class]];
    [mapping addAttributeMappingsFromDictionary:@{@"id": @"blogPostId",
                                                  @"created": @"created",
                                                  @"text": @"text",
                                                  @"creator": @"creator"
                                                  }];
    return mapping;
}

@end
