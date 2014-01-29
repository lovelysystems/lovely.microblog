//  Copyright (c) 2014 lovelysystems. All rights reserved.

#import <UIKit/UIKit.h>
#import "BlogPost.h"

@interface BlogPostTableViewCell : UITableViewCell

@property(nonatomic, strong)UILabel* dateLabel;
@property(nonatomic, strong)UILabel* creatorLabel;
@property(nonatomic, strong)BlogPost* blogPost;

+ (float)heightForBlogPost:(BlogPost*)blogPost;

@end