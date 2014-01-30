//  Copyright (c) 2014 lovelysystems.

#import <UIKit/UIKit.h>

@protocol CreateBlogPostDelegate;

@interface CreateBlogPostViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) id<CreateBlogPostDelegate> delegate;

@end

@protocol CreateBlogPostDelegate <NSObject>

- (void)dismissCreateBlogPost;

@end