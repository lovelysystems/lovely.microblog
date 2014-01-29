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

-(NSString*)formattedDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDoesRelativeDateFormatting:YES];
    return [dateFormatter stringFromDate:self.created];
}

@end
