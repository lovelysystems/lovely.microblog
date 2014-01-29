//  Copyright (c) 2014 lovelysystems.

#import "TimelineViewController.h"
#import "BlogPost.h"
#import "BlogPostTableViewCell.h"
#import <RestKit/RestKit.h>

@interface TimelineViewController ()

@property(nonatomic)NSArray* blogPosts;

@end

@implementation TimelineViewController


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if(self){
        self.title = @"Timeline";
        self.blogPosts = @[];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.blogPosts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BlogPostTableViewCell heightForBlogPost:[self.blogPosts objectAtIndex:indexPath.row]];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TimelineTableViewCell";
    BlogPostTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if( cell == nil){
        cell = [[BlogPostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    BlogPost* blogPost = [self.blogPosts objectAtIndex:indexPath.row];
    [cell setBlogPost:blogPost];
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/blogpost" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.blogPosts = [mappingResult array];
        [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        // DO nothing
    }];
}

@end
