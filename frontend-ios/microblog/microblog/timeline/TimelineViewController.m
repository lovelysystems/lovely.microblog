//  Copyright (c) 2014 lovelysystems.

#import "TimelineViewController.h"
#import <RestKit/RestKit.h>

@interface TimelineViewController ()

@end

@implementation TimelineViewController


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if(self){
        self.title = @"Timeline";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

@end
