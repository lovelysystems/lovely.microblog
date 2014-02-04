//  Copyright (c) 2014 lovelysystems.

#import <UIKit/UIKit.h>

@interface LoginView : UIView

@property (nonatomic, strong) UITextField* name;
@property (nonatomic, strong) UITextField* password;
@property (nonatomic, strong) UILabel* errorLabel;

-(void)showError:(NSString*)error;

@end
