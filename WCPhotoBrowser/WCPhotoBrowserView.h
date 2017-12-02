//
//  WCPhotoBrowserView.h
//  PhotoBrowserDemo
//
//  Created by 王超 on 2017/11/28.
//  Copyright © 2017年 王超. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCPhotoBrowserView, WCPhotoView, WCPhotoModel;

@protocol WCPhotoBrowserDelegate <NSObject>

@required

/**
 展示图片的总数

 @param photoBrowser 图片浏览器
 @return 返回图片张数
 */
- (NSInteger)numberOfPhotosInPhotoBrowser:(WCPhotoBrowserView *)photoBrowser;

/**
 根据指定索引返回数据

 @param photoBrowser 图片浏览器
 @param index 索引
 @return 数据
 */
- (WCPhotoModel *)photoBrowser:(WCPhotoBrowserView *)photoBrowser photoDataForIndex:(NSInteger)index;

@optional

/**
 返回图片浏览器的占位图

 @param photoBrowser 图片浏览器
 @return 占位图
 */
- (UIImage *)placeholderImageForPhotoBrowser:(WCPhotoBrowserView *)photoBrowser;

/**
 当展示图片改变时回调

 @param photoBrowser 图片浏览器
 @param index 当前展示图片的索引
 */
- (void)photoBrowser:(WCPhotoBrowserView *)photoBrowser currentDisplayPhotoIndex:(NSInteger)index;

/**
 设置各个图片之间的间隙，默认为20

 @param photoBrowser 图片浏览器
 @return 展示photo视图之间的间隙
 */
- (CGFloat)photoSpacingInPhotoBrowser:(WCPhotoBrowserView *)photoBrowser;

/**
 设置首次所展示的图片，默认为0

 @param photoBrowser 图片浏览器
 @return 首次展示图片的索引
 */
- (NSInteger)firstDisplayPhotoIndexInPhotoBrowser:(WCPhotoBrowserView *)photoBrowser;

@end

@interface WCPhotoBrowserView : UIView

@property (nonatomic, weak) id<WCPhotoBrowserDelegate> delegate;

@end
