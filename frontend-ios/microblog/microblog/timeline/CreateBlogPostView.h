//  Copyright (c) 2014 lovelysystems.

#import <UIKit/UIKit.h>

@interface CreateBlogPostView : UIView

@property(nonatomic, strong)UITextView* textView;

-(void)showError:(NSString*)error;
-(void)hideError;

@end
