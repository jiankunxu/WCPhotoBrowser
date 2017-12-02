//
//  WCPhotoBrowserView.m
//  PhotoBrowserDemo
//
//  Created by 王超 on 2017/11/28.
//  Copyright © 2017年 王超. All rights reserved.
//

#import "WCPhotoBrowserView.h"
#import "WCPhotoModel.h"
#import "WCPhotoView.h"

#define kWCScreentWidth [UIScreen mainScreen].bounds.size.width
#define kWCScreentHeight [UIScreen mainScreen].bounds.size.height
static const CGFloat kWCPhotoBrowserDefaultPhotoSpacing = 20.0f;

@interface WCPhotoBrowserView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) NSMutableArray<WCPhotoView *> *visiblePhotos;
@property (nonatomic, strong) NSMutableSet<WCPhotoView *> *reuseablePhotos;
@property (nonatomic, assign) NSInteger displayPhotoIndex;
@property (nonatomic, assign) NSInteger totalPhotos;
@property (nonatomic, assign) CGFloat scrollViewWidth;
@property (nonatomic, assign) CGFloat scrollViewHeight;

@end

@implementation WCPhotoBrowserView

- (void)setupInterface {
    [self addSubview:self.scrollView];
    self.scrollViewWidth = kWCScreentWidth + [self photoSpacing];
    self.scrollViewHeight = kWCScreentHeight;
    CGRect frame = CGRectMake(0, 0, self.scrollViewWidth, self.scrollViewHeight);
    self.scrollView.frame = frame;
    self.scrollView.contentSize = CGSizeMake(self.scrollViewWidth*self.totalPhotos, self.scrollViewHeight);
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if ([_delegate respondsToSelector:@selector(placeholderImageForPhotoBrowser:)]) {
        UIImage *placeholderImage = [_delegate placeholderImageForPhotoBrowser:self];
        self.placeholderImage = placeholderImage;
    }
    if ([_delegate respondsToSelector:@selector(firstDisplayPhotoIndexInPhotoBrowser:)]) {
        NSInteger displayPhotoIndex = [_delegate firstDisplayPhotoIndexInPhotoBrowser:self];
        self.displayPhotoIndex = [self safeIndexForPhotoBrowserWithIndex:displayPhotoIndex];
    }
    WCPhotoView *photoView = [self photoViewAtIndex:self.displayPhotoIndex];
    if (photoView) {
        [self.visiblePhotos addObject:photoView];
        [self.scrollView scrollRectToVisible:photoView.frame animated:NO];
    }
}

#pragma mark ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (!(offsetX < 0 || offsetX + self.scrollViewWidth > self.scrollView.contentSize.width)) {
        WCPhotoView *firstPhotoViewInVisiblePhotos = [self.visiblePhotos firstObject];
        WCPhotoView *lastPhotoViewInVisiblePhotos = [self.visiblePhotos lastObject];
        //添加即将进入可视区域的photo
        if (offsetX + self.scrollViewWidth > CGRectGetMaxX(lastPhotoViewInVisiblePhotos.frame)) {
            NSInteger nextPhotoViewIndex = lastPhotoViewInVisiblePhotos.photoIndex + 1;
            while (nextPhotoViewIndex < self.totalPhotos) {
                WCPhotoView *nextPhotoView = [self photoViewAtIndex:nextPhotoViewIndex];
                if (nextPhotoView) {
                    [self.visiblePhotos addObject:nextPhotoView];
                    if ([self.reuseablePhotos containsObject:nextPhotoView]) {
                        [self.reuseablePhotos removeObject:nextPhotoView];
                    }
                    if (CGRectGetMaxX(nextPhotoView.frame) >= offsetX + self.scrollViewWidth) break;
                }
                nextPhotoViewIndex ++;
            }
        }
        if (offsetX < CGRectGetMinX(firstPhotoViewInVisiblePhotos.frame)) {
            NSInteger previousPhotoViewIndex = firstPhotoViewInVisiblePhotos.photoIndex - 1;
            while (previousPhotoViewIndex >= 0) {
                WCPhotoView *previousPhotoView = [self photoViewAtIndex:previousPhotoViewIndex];
                if (previousPhotoView) {
                    [self.visiblePhotos insertObject:previousPhotoView atIndex:0];
                    if ([self.reuseablePhotos containsObject:previousPhotoView]) {
                        [self.reuseablePhotos removeObject:previousPhotoView];
                    }
                    if (CGRectGetMinX(previousPhotoView.frame) <= offsetX) break;
                }
                previousPhotoViewIndex --;
            }
        }
        // 移除不在可视区域内的photo
        while(self.visiblePhotos.count > 0 && CGRectGetMinX(self.visiblePhotos.lastObject.frame) >= offsetX + self.scrollViewWidth) {
            WCPhotoView *lastPhotoView = self.visiblePhotos.lastObject;
            [lastPhotoView prepareForReuse];
            [self.reuseablePhotos addObject:lastPhotoView];
            [self.visiblePhotos removeObject:lastPhotoView];
            [lastPhotoView removeFromSuperview];
        }
        while(self.visiblePhotos.count > 0 && CGRectGetMaxX(self.visiblePhotos.firstObject.frame) <= offsetX) {
            WCPhotoView *firstPhotoView = self.visiblePhotos.firstObject;
            [firstPhotoView prepareForReuse];
            [self.reuseablePhotos addObject:firstPhotoView];
            [self.visiblePhotos removeObject:firstPhotoView];
            [firstPhotoView removeFromSuperview];
        }
        // 当前展示图片的索引
        self.displayPhotoIndex = ceil((offsetX  + self.scrollViewWidth / 2.0) / self.scrollViewWidth) - 1;
    }
}

/**
 根据给定的索引返回特定的需要展示图片

 @param index 索引
 @return 展示图片
 */
- (WCPhotoView *)photoViewAtIndex:(NSInteger)index {
    NSInteger safeIndex = [self safeIndexForPhotoBrowserWithIndex:index];
    WCPhotoView *photoView = self.reuseablePhotos.anyObject;
    if (photoView == nil) {
        photoView = [[[UINib nibWithNibName:@"WCPhotoView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    }
    if (photoView && ![self.scrollView.subviews containsObject:photoView]) {
        [self.scrollView addSubview:photoView];
        photoView.photoIndex = safeIndex;
        photoView.frame = CGRectMake(self.scrollViewWidth*safeIndex, 0, self.scrollViewWidth, self.scrollViewHeight);
        photoView.placeholderImage = self.placeholderImage;
        if ([_delegate respondsToSelector:@selector(photoBrowser:photoDataForIndex:)]) {
            WCPhotoModel *photoModel = [_delegate photoBrowser:self photoDataForIndex:safeIndex];
            photoView.photoModel = photoModel;
        }
    }
    return photoView;
}


/**
 根据当前的index，返回一个安全的index值，防止下标越界之类的问题。

 @param index 计算出的index
 @return 安全的index
 */
- (NSInteger)safeIndexForPhotoBrowserWithIndex:(NSInteger)index {
    NSInteger safeIndex = index;
    if (index < 0) {
        safeIndex = 0;
    }
    if (index >= self.totalPhotos) {
        safeIndex = self.totalPhotos - 1;
    }
    return safeIndex;
}

/**
 返回图片数量
 */
- (NSInteger)totalPhotos {
    NSInteger totalPhotos = 0;
    if ([_delegate respondsToSelector:@selector(numberOfPhotosInPhotoBrowser:)]) {
        totalPhotos = [_delegate numberOfPhotosInPhotoBrowser:self];
    }
    _totalPhotos = totalPhotos;
    return _totalPhotos;
}

/**
 返回展示图片间的间距
 */
- (CGFloat)photoSpacing {
    CGFloat photoSpacing = kWCPhotoBrowserDefaultPhotoSpacing;
    if ([_delegate respondsToSelector:@selector(photoSpacingInPhotoBrowser:)]) {
        photoSpacing = [_delegate photoSpacingInPhotoBrowser:self];
    }
    return photoSpacing;
}

#pragma mark getter and setter

- (void)setDisplayPhotoIndex:(NSInteger)displayPhotoIndex {
    if (_displayPhotoIndex != displayPhotoIndex) {
        _displayPhotoIndex = displayPhotoIndex;
        if ([_delegate respondsToSelector:@selector(photoBrowser:currentDisplayPhotoIndex:)]) {
            [_delegate photoBrowser:self currentDisplayPhotoIndex:displayPhotoIndex];
        }
    }
}

- (void)setDelegate:(id<WCPhotoBrowserDelegate>)delegate {
    if (_delegate != delegate) {
        _delegate = delegate;
        [self setupInterface];
    }
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = NO;
    }
    return _scrollView;
}

- (NSMutableArray<WCPhotoView *> *)visiblePhotos {
    if (_visiblePhotos == nil) {
        _visiblePhotos = [NSMutableArray<WCPhotoView *> array];
    }
    return _visiblePhotos;
}

- (NSMutableSet <WCPhotoView *> *)reuseablePhotos {
    if (_reuseablePhotos == nil) {
        _reuseablePhotos = [NSMutableSet<WCPhotoView *> set];
    }
    return _reuseablePhotos;
}

@end
