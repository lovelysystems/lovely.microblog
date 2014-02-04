//  Copyright (c) 2014 lovelysystems.

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@protocol CreateBlogPostDelegate;

@interface CreateBlogPostViewController : UIViewController <UITextViewDelegate, LoginViewControllerDelegate>

@property (nonatomic, weak) id<CreateBlogPostDelegate> delegate;

@end

@protocol CreateBlogPostDelegate <NSObject>

- (void)dismissCreateBlogPost;

@end