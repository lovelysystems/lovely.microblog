//  Copyright (c) 2014 lovelysystems. All rights reserved.

#define textFontSize 11.0
#define creatorFontSize 11.0
#define dateFontSize 11.0
#define cellTopMargin 10.0
#define cellLeftMargin 15.0
#define cellRightMargin 10.0
#define cellBottomMargin 10.0
#define cellSpacing 5.0

#import "BlogPostTableViewCell.h"

@interface BlogPostTableViewCell ()

+ (CGSize)textLabelSize:(NSString*)text;
+ (CGSize)creatorLabelSize:(NSString*)creator;

@end

@implementation BlogPostTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:textFontSize];
        
        _creatorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _creatorLabel.font = [UIFont fontWithName:@"Avenir-Light" size:creatorFontSize];
        _creatorLabel.textColor = [UIColor grayColor];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.font = [UIFont fontWithName:@"Avenir-Light" size:dateFontSize];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.textColor = [UIColor grayColor];
        
        [self.contentView addSubview:_creatorLabel];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

- (void)setBlogPost:(BlogPost *)blogPost {
    _blogPost = blogPost;
    self.textLabel.text = blogPost.text;
    self.creatorLabel.text = blogPost.creator;
    self.dateLabel.text = blogPost.formattedDate;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.creatorLabel.frame = CGRectMake(cellLeftMargin,
                                         cellTopMargin,
                                         [BlogPostTableViewCell maxCellWidth:self.contentView.bounds.size.width] / 2,
                                         [BlogPostTableViewCell creatorLabelSize:self.blogPost.creator].height);
    
    self.dateLabel.frame = CGRectMake(self.contentView.bounds.size.width - [BlogPostTableViewCell maxCellWidth:self.contentView.bounds.size.width] / 2,
                                      cellTopMargin,
                                      ([BlogPostTableViewCell maxCellWidth:self.contentView.bounds.size.width] / 2) - cellRightMargin,
                                      [BlogPostTableViewCell dateLabelSize:self.blogPost.formattedDate].height);
    
    self.textLabel.frame = CGRectMake(cellLeftMargin,
                                      _creatorLabel.frame.origin.y + _creatorLabel.frame.size.height + cellSpacing,
                                      [BlogPostTableViewCell maxCellWidth:self.contentView.bounds.size.width],
                                      [BlogPostTableViewCell textLabelSize:_blogPost.text].height);
}

#pragma mark - Helper methods

+ (float)heightForBlogPost:(BlogPost*)blogPost {
    return cellTopMargin +
    [BlogPostTableViewCell creatorLabelSize:blogPost.creator].height +
    cellSpacing +
    [BlogPostTableViewCell textLabelSize:blogPost.text].height +
    cellBottomMargin;
}

+(CGSize)textLabelSize:(NSString *)text {
    // Returns the minimum size for the textLabel
    CGSize applicationFrameSize = [[UIScreen mainScreen] applicationFrame].size;
    return [text boundingRectWithSize:applicationFrameSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light"
                                                                            size:textFontSize]}
                              context:nil].size;
}

+(CGSize)creatorLabelSize:(NSString *)creator {
    return [creator sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light"
                                                                             size:creatorFontSize]}];
}

+(CGSize)dateLabelSize:(NSString *)date {
    return [date sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light"
                                                                          size:creatorFontSize]}];
}

+ (CGFloat)maxCellWidth:(float)cellWidth {
    return cellWidth - cellLeftMargin - cellRightMargin;
}

@end
