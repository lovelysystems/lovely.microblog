//  Copyright (c) 2014 lovelysystems.

#import "CreateBlogPostViewController.h"
#import "CreateBlogPostView.h"
#import "BlogPost.h"
#import <RestKit/RestKit.h>

@interface CreateBlogPostViewController ()

- (void)sendPost:(id)sender;
- (void)dismiss:(id)sender;

@end

@implementation CreateBlogPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // this is necessary for ios 7, else editing would start in the middle of
        // the textView
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationItem.title = @"New Post";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(sendPost:)];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(dismiss:)];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    return self;
}

- (void)loadView {
    CreateBlogPostView* createBlogPostView = [[CreateBlogPostView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [createBlogPostView.textView setDelegate:self];
    self.view = createBlogPostView;
}

- (void)sendPost:(id)sender {
    BlogPost* post = [[BlogPost alloc] init];
    post.text = [(CreateBlogPostView*)self.view textView].text;
    [[RKObjectManager sharedManager] postObject:post
                                           path:@"/blogposts"
                                     parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            [self dismiss:nil];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if(operation.HTTPRequestOperation.response.statusCode == 403){
            LoginViewController* loginViewController = [[LoginViewController alloc] initWithNibName:nil
                                                                                             bundle:nil];
            [loginViewController setDelegate:self];
            UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController
                               animated:YES
                             completion:nil];
        }
        [(CreateBlogPostView*)self.view showError:@"An error occured, please try again later."];
    }];
    
}

-(void)textViewDidChange:(UITextView *)textView {
    [self.navigationItem.rightBarButtonItem setEnabled:textView.text.length > 0];
}

- (void)dismiss:(id)sender {
    [self.delegate dismissCreateBlogPost];
}

- (void)loginViewController:(LoginViewController *)loginViewController didFinishWithLogin:(BOOL)loggedIn {
    [self dismissViewControllerAnimated:YES completion:^(){
        if(loggedIn){
            [self sendPost:nil];
        }
    }];
}

@end
