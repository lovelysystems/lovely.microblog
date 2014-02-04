//  Copyright (c) 2014 lovelysystems.

#define loginErrorWidth 300.0
#define loginViewTopMargin 70.0
#define loginViewRightMargin 20.0
#define loginViewLeftMargin 20.0
#define loginViewSpacing 10.0
#define loginFontSize 18.0
#define errorSize 10.0

#import "LoginView.h"

@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _name = [[UITextField alloc] initWithFrame:CGRectZero];
        [_name setPlaceholder:@"Name"];
        [_name setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_name setFont:[UIFont fontWithName:@"Avenir-Light" size:loginFontSize]];
        [_name setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_name];
        
        _password = [[UITextField alloc] initWithFrame:CGRectZero];
        [_password setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_password setPlaceholder:@"Password"];
        [_password setFont:[UIFont fontWithName:@"Avenir-Light" size:loginFontSize]];
        [_password setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_password];
        
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_errorLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:errorSize]];
        [_errorLabel setTextAlignment:NSTextAlignmentCenter];
        [_errorLabel setTextColor:[UIColor redColor]];
        [self addSubview:_errorLabel];
    }
    return self;
}

- (void)layoutSubviews {
    _name.frame = CGRectMake(loginViewLeftMargin,
                             loginViewTopMargin,
                             self.bounds.size.width -
                             (loginViewLeftMargin +
                              loginViewRightMargin),
                             44.0);
    
    _password.frame = CGRectMake(loginViewLeftMargin,
                                 _name.frame.origin.y +
                                 _name.bounds.size.height +
                                 loginViewSpacing,
                                 self.bounds.size.width -
                                 (loginViewLeftMargin +
                                  loginViewRightMargin),
                                 44.0);
    
    _errorLabel.frame = CGRectMake(self.bounds.size.width / 2 -
                                    loginErrorWidth / 2,
                                    _password.frame.origin.y +
                                    _password.bounds.size.height +
                                    loginViewSpacing,
                                    loginErrorWidth, 44.0);
    
}

- (void)showError:(NSString *)error {
    [_errorLabel setText:error];
}

@end
