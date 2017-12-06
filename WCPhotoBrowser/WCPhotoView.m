//
//  WCPhotoView.m
//  PhotoBrowserDemo
//
//  Created by 王超 on 2017/11/28.
//  Copyright © 2017年 王超. All rights reserved.
//

#import "WCPhotoView.h"
#import "WCPhotoModel.h"
#import "WCPhotoBrowserView.h"
#import "UIImage+Bundle.h"
#import <SDWebImage/UIImageView+WebCache.h>

static const CGFloat kMaximumZoomScaleForPhotoScrollView = 3.0;
static const CGFloat kMinimumZoomScaleForPhotoScrollView = 1.0;
static const CGFloat kDefaultZoomScaleForPhotoScrollView = 1.0;
static const CGFloat kTresholdPanLengthForScrollView = 200.0f;

@interface WCPhotoView () <UIScrollViewDelegate> {
    UITapGestureRecognizer *_singleTapGesture;
    UITapGestureRecognizer *_doubleTapGesure;
}

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) CGFloat currentZoomScale;

@end

@implementation WCPhotoView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.photoImageView = [[UIImageView alloc] init];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.photoImageView.userInteractionEnabled = YES;
    self.photoImageView.backgroundColor = [UIColor clearColor];
    [self.photoScrollView addSubview:self.photoImageView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.photoImageView addSubview:self.activityIndicatorView];
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    _doubleTapGesure = doubleTapGesture;
    [self.photoImageView addGestureRecognizer:doubleTapGesture];
    self.photoScrollView.maximumZoomScale = kMaximumZoomScaleForPhotoScrollView;
    self.photoScrollView.minimumZoomScale = kMinimumZoomScaleForPhotoScrollView;
    self.photoScrollView.zoomScale = kDefaultZoomScaleForPhotoScrollView;
    self.currentZoomScale = kDefaultZoomScaleForPhotoScrollView;
    self.photoScrollView.delegate = self;
    [self resetPhotoScrollViewState];
    [self.photoScrollView.panGestureRecognizer addTarget:self action:@selector(handlePhotoScrollViewPanGesture:)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.photoImageView.frame = self.photoScrollView.bounds;
    self.activityIndicatorView.center = self.photoImageView.center;
    self.photoScrollView.contentSize = CGSizeMake(self.photoImageView.bounds.size.width, self.photoImageView.bounds.size.height + 1);
}

- (void)prepareForReuse {
    self.photoIndex = 0;
    self.photoImageView.image = nil;
    [self.activityIndicatorView stopAnimating];
    [self.photoScrollView setZoomScale:kDefaultZoomScaleForPhotoScrollView animated:YES];
    [self resetPhotoScrollViewState];
}

- (void)resetPhotoScrollViewState {
    self.photoScrollView.contentOffset = CGPointZero;
    self.photoScrollView.contentInset = UIEdgeInsetsZero;
    self.photoScrollView.contentSize = CGSizeMake(self.photoImageView.bounds.size.width, self.photoImageView.bounds.size.height + 1);
}

- (void)setPhotoModel:(WCPhotoModel *)photoModel {
    _photoModel = photoModel;
    if (photoModel.imageURL.length > 0) {
        __weak typeof(self) weakSelf = self;
        [self.activityIndicatorView startAnimating];
        self.activityIndicatorView.hidden = NO;
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.imageURL] placeholderImage:self.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [weakSelf.activityIndicatorView stopAnimating];
        }];
    } else if (photoModel.localImage) {
        [self.photoImageView setImage:photoModel.localImage];
    }
}

- (void)setSingleTapGestureEnabled:(BOOL)singleTapGestureEnabled {
    _singleTapGestureEnabled = singleTapGestureEnabled;
    if (_singleTapGestureEnabled && _singleTapGesture == nil) {
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        singleTapGesture.numberOfTapsRequired = 1;
        singleTapGesture.delaysTouchesBegan = YES;
        _singleTapGesture = singleTapGesture;
        [_singleTapGesture requireGestureRecognizerToFail:_doubleTapGesure];
        [self.photoImageView addGestureRecognizer:singleTapGesture];
    }
    if (!_singleTapGestureEnabled && _singleTapGesture){
        [self.photoImageView removeGestureRecognizer:_singleTapGesture];
    }
}

- (void)handleSingleTapGesture:(UIGestureRecognizer *)gesture {
    self.photoBrowserView.photoBrowserDidDisappear();
}

- (void)doubleTapGesture:(UIGestureRecognizer *)gesture {
    if (self.currentZoomScale != kDefaultZoomScaleForPhotoScrollView) {
        [self.photoScrollView setZoomScale:kDefaultZoomScaleForPhotoScrollView animated:YES];
    } else {
        // 以触摸点为中心放大
        CGPoint touchPoint = [gesture locationInView:self.photoImageView];
        CGFloat width = self.photoImageView.bounds.size.width / kMaximumZoomScaleForPhotoScrollView;
        CGFloat height = self.photoImageView.bounds.size.height / kMaximumZoomScaleForPhotoScrollView;
        [self.photoScrollView zoomToRect:CGRectMake(touchPoint.x - width/2.0, touchPoint.y - height/2.0, width, height) animated:YES];
    }
}

- (void)handlePhotoScrollViewPanGesture:(UIGestureRecognizer *)gesture {
    if (self.photoScrollView.zoomScale != kDefaultZoomScaleForPhotoScrollView) return;
    CGFloat offsetY = self.photoScrollView.contentOffset.y;
//    NSLog(@"%f ---- %f", offsetY, self.photoScrollView.contentInset.top);
    if (gesture.state == UIGestureRecognizerStateEnded) {
        __weak typeof(self) weakSelf = self;
        if (ABS(offsetY) < kTresholdPanLengthForScrollView) {
            // 下拉距离小于阀值，photoBrowser会恢复原始状态
            self.photoBrowserView.photoBrowserWillAppear();
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.photoScrollView.contentInset = UIEdgeInsetsZero;
            }];
        } else {
            // 下拉距离大于阀值，photoBrowser消失
            CGFloat photoScrollViewHeight = self.photoScrollView.bounds.size.height;
            [UIView animateWithDuration:0.25 animations:^{
                CGRect photoImageFrame = weakSelf.photoImageView.frame;
                photoImageFrame.origin.y = photoScrollViewHeight;
                weakSelf.photoImageView.frame = photoImageFrame;
            } completion:^(BOOL finished) {
                weakSelf.photoBrowserView.photoBrowserBackgroundColorDidChange(0.0, 0.0);
                weakSelf.photoBrowserView.photoBrowserDidDisappear();
            }];
        }
    } else {
        // 设置下拉距离为scrollView的Inset.top，同时预示着photoBrowser将会消失
        self.photoBrowserView.photoBrowserWillDisappear();
        self.photoScrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, 0, 0);
    }
}

#pragma mark - ScrollView Delegagte

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%f -- %@", scrollView.contentOffset.y, NSStringFromUIEdgeInsets(scrollView.contentInset));
    // 下拉距离小于某一阀值时，调整Photobrowser背景颜色的alpha值
    if (ABS(scrollView.contentOffset.y) < kTresholdPanLengthForScrollView) {
        CGFloat alpha = 1 - ABS(scrollView.contentOffset.y / (kTresholdPanLengthForScrollView + 50));
        self.photoBrowserView.photoBrowserBackgroundColorDidChange(alpha, 1.0);
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photoImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 居中缩放
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    self.photoImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    _currentZoomScale = scale;
    if (scale == kDefaultZoomScaleForPhotoScrollView) {
        [self resetPhotoScrollViewState];
    }
}

@end
