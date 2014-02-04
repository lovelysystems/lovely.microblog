//  Copyright (c) 2014 lovelysystems.

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate;

@interface LoginViewController : UIViewController

@property (nonatomic, weak)id<LoginViewControllerDelegate> delegate;

@end

@protocol LoginViewControllerDelegate <NSObject>

-(void)loginViewController:(LoginViewController*)loginViewController didFinishWithLogin:(BOOL)loggedIn;

@end