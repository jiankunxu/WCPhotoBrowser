//
//  WCTableViewController.m
//  PhotoBrowserDemo
//
//  Created by 王超 on 2017/12/11.
//  Copyright © 2017年 王超. All rights reserved.
//

#import "WCTableViewController.h"
#import "WCPhotoBrowser.h"

@interface WCTableViewController ()

@property (nonatomic, strong) NSArray *localImages;

@end

@implementation WCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.images = self.localImages;
    return cell;
}

- (NSArray *)localImages {
    if (_localImages == nil) {
        NSInteger localImagesCount = 9;
        NSMutableArray *localImages = [NSMutableArray arrayWithCapacity:localImagesCount];
        for (NSInteger index = 0; index < localImagesCount; index ++) {
            [localImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"image%td", index]]];
        }
        _localImages = [localImages copy];
    }
    return _localImages;
}

@end

@interface WCTableViewCell () <WCPhotoBrowserAnimatorDelegate>

@property (nonatomic, strong) WCPhotoBrowserAnimator *animator;
@property (weak, nonatomic) IBOutlet UIImageView *image0;
@property (weak, nonatomic) IBOutlet UIImageView *image1;

@end

@implementation WCTableViewCell

- (IBAction)buttonDidClicked:(UIButton *)sender {
    WCPhotoBrowserViewController *photoBrowser = [[WCPhotoBrowserViewController alloc] init];
    photoBrowser.displayPageControl = NO;
    photoBrowser.displayPhotoOrderInfo = YES;
    photoBrowser.firstDisplayPhotoIndex = 0;
    photoBrowser.localImages = self.images;
    self.animator = [[WCPhotoBrowserAnimator alloc] init];
    self.animator.animatorDelegate = self;
    photoBrowser.transitioningDelegate = self.animator;
    [photoBrowser show];
}

- (UIImage *)willDisplayImageInPhotoBrowserAtIndex:(NSInteger)willDisplayImageIndex {
    return self.images[willDisplayImageIndex];
}

- (CGRect)willDisplayImageOfStartRectAtIndex:(NSInteger)willDisplayImageIndex {
    return [self.image0 convertRect:self.image0.frame toView:[UIApplication sharedApplication].keyWindow];
}

- (CGRect)willDisplayImageOfEndRectAtIndex:(NSInteger)willDisplayImageIndex {
    UIImage *image = [self.images objectAtIndex:willDisplayImageIndex];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = (screenWidth / image.size.width) * image.size.height;
    CGFloat y = 0;
    if (height < screenHeight) {
        y = (screenHeight - height) / 2.0;
    }
    NSLog(@"width: %f, height: %f", screenWidth, height);
    return CGRectMake(0, y, screenWidth, height);
}

@end
