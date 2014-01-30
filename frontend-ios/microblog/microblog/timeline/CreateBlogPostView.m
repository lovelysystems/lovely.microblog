//  Copyright (c) 2014 lovelysystems.

#import "CreateBlogPostView.h"

#define marginLeft 10
#define marginTop 10
#define spacing 10
#define textViewHeight 155
#define navigationBarHeight 70
#define errorSize 10

@interface CreateBlogPostView ()

@property(nonatomic, strong)UILabel* errorLabel;

@end

@implementation CreateBlogPostView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.layer.borderWidth = 1.0;
        _textView.layer.borderColor = [[UIColor grayColor] CGColor];
        [_textView becomeFirstResponder];
        [self addSubview:_textView];
        
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_errorLabel setHidden:YES];
        _errorLabel.font = [UIFont fontWithName:@"Avenir-Light" size:errorSize];
        _errorLabel.textColor = [UIColor redColor];

        [self addSubview:_errorLabel];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = CGRectMake(marginLeft,
                                     navigationBarHeight + marginTop,
                                     self.bounds.size.width - (marginTop + marginLeft),
                                     textViewHeight);
    _errorLabel.frame = CGRectMake(marginLeft,
                                   _textView.frame.origin.y + _textView.frame.size.height + spacing,
                                   self.bounds.size.width - (marginTop + marginLeft),
                                   errorSize);
}

-(void)showError:(NSString *)error {
    [_errorLabel setText:error];
    [_errorLabel setHidden:NO];
}

-(void)hideError {
    [_errorLabel setHidden:YES];
}

@end
