//
//  WCPhotoView.m
//  PhotoBrowserDemo
//
//  Created by 王超 on 2017/11/28.
//  Copyright © 2017年 王超. All rights reserved.
//

#import "WCPhotoView.h"
#import "WCPhotoModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

static const CGFloat kMaximumZoomScaleForPhotoScrollView = 3.0;
static const CGFloat kMinimumZoomScaleForPhotoScrollView = 1.0;
static const CGFloat kDefaultZoomScaleForPhotoScrollView = 1.0;

@interface WCPhotoView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (strong, nonatomic) UIImageView *photoImageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) CGFloat currentZoomScale;

@end

@implementation WCPhotoView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.photoImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.photoImageView.userInteractionEnabled = YES;
    [self.photoScrollView addSubview:self.photoImageView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicatorView.center = self.photoImageView.center;
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self.photoImageView addSubview:self.activityIndicatorView];
    
    self.photoScrollView.maximumZoomScale = kMaximumZoomScaleForPhotoScrollView;
    self.photoScrollView.minimumZoomScale = kMinimumZoomScaleForPhotoScrollView;
    self.photoScrollView.zoomScale = kDefaultZoomScaleForPhotoScrollView;
    self.currentZoomScale = kDefaultZoomScaleForPhotoScrollView;
    self.photoScrollView.contentSize = self.photoImageView.bounds.size;
    self.photoScrollView.delegate = self;
    self.photoScrollView.contentInset = UIEdgeInsetsZero;
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.photoImageView addGestureRecognizer:doubleTapGesture];
}

- (void)prepareForReuse {
    self.photoIndex = 0;
    self.photoImageView.image = nil;
    [self.activityIndicatorView stopAnimating];
    [self.photoScrollView setZoomScale:kDefaultZoomScaleForPhotoScrollView animated:YES];
}

- (void)setPhotoModel:(WCPhotoModel *)photoModel {
    _photoModel = photoModel;
    if (photoModel.imageURL.length > 0) {
        __weak typeof(self) weakSelf = self;
        [self.activityIndicatorView startAnimating];
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.imageURL] placeholderImage:self.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [weakSelf.activityIndicatorView stopAnimating];
        }];
    } else if (photoModel.localImage) {
        [self.photoImageView setImage:photoModel.localImage];
    }
}

- (void)doubleTapGesture:(UIGestureRecognizer *)gesture {
    if (self.currentZoomScale != kDefaultZoomScaleForPhotoScrollView) {
        [self.photoScrollView setZoomScale:kDefaultZoomScaleForPhotoScrollView animated:YES];
    } else {
        [self.photoScrollView setZoomScale:kMaximumZoomScaleForPhotoScrollView animated:YES];
    }
}

#pragma mark ScrollView Delegagte

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photoImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    self.photoImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    _currentZoomScale = scale;
}

@end