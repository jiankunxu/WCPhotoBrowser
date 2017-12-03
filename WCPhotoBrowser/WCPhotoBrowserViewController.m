//
//  WCPhotoBrowserViewController.m
//  PhotoBrowserDemo
//
//  Created by 王超 on 2017/11/28.
//  Copyright © 2017年 王超. All rights reserved.
//

#import "WCPhotoBrowserViewController.h"
#import "WCPhotoBrowserView.h"
#import "WCPhotoModel.h"
#import "UIImage+Bundle.h"
#import "UIViewController+TopViewController.h"
#import "WCMaskAnimatedTransition.h"

@interface WCPhotoBrowserViewController () <WCPhotoBrowserDelegate> {
    WCMaskAnimatedTransition *_maskAnimatedTransition;
}

@property (weak, nonatomic) IBOutlet WCPhotoBrowserView *photoBrowserView;
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UILabel *photoOrderLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *photoPageControl;

@end

@implementation WCPhotoBrowserViewController

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray<WCPhotoModel *> *)images {
    if (self = [super init]) {
        self.images = images;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNetworkImages:(NSArray *)networkImages {
    if (self = [super init]) {
        self.networkImages = networkImages;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithLocalImages:(NSArray<UIImage *> *)localImages {
    if (self = [super init]) {
        self.localImages = localImages;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _displayPhotoOrderInfo = NO;
    _displayPageControl = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavigationBar];
    [self setupPhotoOrderLabel];
    [self setupPhotoPageControl];
    self.photoBrowserView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return self.showStatusBar;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)show {
    if (!self.transitioningDelegate) {
        _maskAnimatedTransition = [[WCMaskAnimatedTransition alloc] init];
        self.transitioningDelegate = _maskAnimatedTransition;
    }
    self.modalPresentationStyle = UIModalPresentationCustom;
    [[UIViewController topViewController] presentViewController:self animated:YES completion:nil];
}

- (void)setupNavigationBar {
    self.navigationBarView.backgroundColor = [UIColor clearColor];
    [self.cancleButton setImage:[UIImage wc_imageNamed:@"wc_photobrowser_cancle" bundleName:@"WCPhotoBrowser"] forState:UIControlStateNormal];
    [self.cancleButton setImage:[UIImage wc_imageNamed:@"wc_photobrowser_cancle" bundleName:@"WCPhotoBrowser"] forState:UIControlStateHighlighted];
}

- (void)setupPhotoOrderLabel {
    if (self.displayPhotoOrderInfo) {
        [self.photoOrderLabel setHidden:NO];
        self.photoOrderLabel.textColor = [UIColor whiteColor];
    } else {
        [self.photoOrderLabel setHidden:YES];
    }
}

- (void)setupPhotoPageControl {
    if (self.displayPageControl) {
        self.photoPageControl.hidden = NO;
        self.photoPageControl.hidesForSinglePage = YES;
        self.photoPageControl.defersCurrentPageDisplay = YES;
        self.photoPageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor ? self.currentPageIndicatorTintColor: [UIColor whiteColor];
        self.photoPageControl.pageIndicatorTintColor = self.pageIndicatorTintColor ? self.pageIndicatorTintColor : [UIColor lightGrayColor];
        self.photoPageControl.numberOfPages = self.images.count;
    } else {
        self.photoPageControl.hidden = YES;
    }
}

#pragma mark PhotoBrowser Delegate

- (NSInteger)numberOfPhotosInPhotoBrowser:(WCPhotoBrowserView *)photoBrowser {
    return self.images.count;
}

- (WCPhotoModel *)photoBrowser:(WCPhotoBrowserView *)photoBrowser photoDataForIndex:(NSInteger)index {
    return [self.images objectAtIndex:index];
}

- (void)photoBrowser:(WCPhotoBrowserView *)photoBrowser currentDisplayPhotoIndex:(NSInteger)index {
    if (self.displayPhotoOrderInfo) {
        [self.photoOrderLabel setText:[NSString stringWithFormat:@"%td/%td", index + 1, self.images.count]];
    }
    if (self.displayPageControl) {
        self.photoPageControl.currentPage = index;
    }
}

- (NSInteger)firstDisplayPhotoIndexInPhotoBrowser:(WCPhotoBrowserView *)photoBrowser {
    return self.firstDisplayPhotoIndex;
}

- (UIImage *)placeholderImageForPhotoBrowser:(WCPhotoBrowserView *)photoBrowser {
    return self.placehoderImage;
}

#pragma mark IBAction

- (IBAction)cancleButtonDidClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter and setter

- (void)setNetworkImages:(NSArray *)networkImages {
    _networkImages = networkImages;
    if (_images == nil && networkImages.count > 0) {
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (int i = 0; i < networkImages.count; i ++) {
            WCPhotoModel *photoModel = [[WCPhotoModel alloc] initWithImageURL:[networkImages objectAtIndex:i]];
            [images addObject:photoModel];
        }
        _images = [images copy];
    }
}

- (void)setLocalImages:(NSArray<UIImage *> *)localImages {
    _localImages = localImages;
    if (_images == nil && localImages.count > 0) {
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:localImages.count];
        for (int i = 0; i < _localImages.count; i ++) {
            id image = [_localImages objectAtIndex:i];
            if ([image isKindOfClass:[UIImage class]]) {
                WCPhotoModel *photoModel = [[WCPhotoModel alloc] initWithLocalImage:image];
                [images addObject:photoModel];
            }
        }
        _images = [images copy];
    }
}

- (void)setDisplayPhotoOrderInfo:(BOOL)displayPhotoOrderInfo {
    _displayPhotoOrderInfo = displayPhotoOrderInfo;
    [self setupPhotoOrderLabel];
}

- (void)setDisplayPageControl:(BOOL)displayPageControl {
    _displayPageControl = displayPageControl;
    [self setupPhotoPageControl];
}

@end
