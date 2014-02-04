//  Copyright (c) 2014 lovelysystems.

#import <RestKit/RestKit.h>
#import "AppDelegate.h"
#import "BlogPost.h"
#import "User.h"
#import "TimelineViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setUpRestKit];
    
    // TimeLineViewController
    TimelineViewController* timeLineViewController = [[TimelineViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController* timeLineNavigationController = [[UINavigationController alloc] initWithRootViewController:timeLineViewController];
    timeLineNavigationController.title = @"Timeline";
    self.window.rootViewController = timeLineNavigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setUpRestKit {
    RKObjectManager* manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://localhost:9210"]];
    [manager.HTTPClient setParameterEncoding:AFJSONParameterEncoding];
    [manager setRequestSerializationMIMEType:RKMIMETypeJSON];
    
    NSIndexSet* statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor* blogPostGetResponse = [RKResponseDescriptor responseDescriptorWithMapping:[BlogPost mapping]
                                                                                    method:RKRequestMethodGET
                                                                               pathPattern:@"/blogposts"
                                                                                    keyPath:@"data.blogposts"
                                                                               statusCodes:statusCodes];
    
    RKResponseDescriptor* blogPostPostResponse = [RKResponseDescriptor responseDescriptorWithMapping:[BlogPost mapping]
                                                                                    method:RKRequestMethodPOST
                                                                               pathPattern:@"/blogposts"
                                                                                   keyPath:nil
                                                                               statusCodes:statusCodes];
    
    RKRequestDescriptor* blogPostPostRequest = [RKRequestDescriptor requestDescriptorWithMapping:[[BlogPost mapping] inverseMapping]
                                                                                     objectClass:[BlogPost class]
                                                                                     rootKeyPath:nil
                                                                                          method:RKRequestMethodPOST];
    

    RKRequestDescriptor* loginRequest = [RKRequestDescriptor requestDescriptorWithMapping:[[User mapping] inverseMapping]
                                                                              objectClass:[User class]
                                                                              rootKeyPath:nil
                                                                                   method:RKRequestMethodPOST];
    RKObjectMapping * emptyMapping = [RKObjectMapping mappingForClass:[NSObject class]];
    RKResponseDescriptor* loginResponse = [RKResponseDescriptor responseDescriptorWithMapping:emptyMapping
                                                                                       method:RKRequestMethodPOST
                                                                                  pathPattern:@"/users/login"
                                                                                      keyPath:nil
                                                                                  statusCodes:statusCodes];
    [manager addResponseDescriptorsFromArray:@[blogPostGetResponse, blogPostPostResponse, loginResponse]];
    [manager addRequestDescriptorsFromArray:@[blogPostPostRequest, loginRequest]];
    [RKObjectManager setSharedManager:manager];
}

@end
