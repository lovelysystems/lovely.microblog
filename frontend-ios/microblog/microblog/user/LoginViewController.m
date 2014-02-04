//  Copyright (c) 2014 lovelysystems.

#import <RestKit/RestKit.h>
#import "LoginViewController.h"
#import "LoginView.h"
#import "User.h"

@interface LoginViewController ()

- (void)cancel:(id)sender;
- (void)login:(id)sender;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Login";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(cancel:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login"
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(login:)];
    }
    return self;
}

- (void)loadView {
    LoginView* loginView = [[LoginView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = loginView;
}

- (void)login:(id)sender {
    LoginView* view = (LoginView*)self.view;
    User* user = [[User alloc] init];
    user.name = [[view name] text];
    user.password = [[view password] text];
    [[RKObjectManager sharedManager] postObject:user
                                           path:@"/users/login"
                                     parameters:Nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            [self.delegate loginViewController:self didFinishWithLogin:YES];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if(operation.HTTPRequestOperation.response.statusCode == 401){
            [view showError:@"You have entered an invalid username or password"];
        } else {
            [view showError:@"An error occured, please try again later"];
        }
    }];
    
}

- (void)cancel:(id)sender {
    [self.delegate loginViewController:self didFinishWithLogin:NO];
}

@end
