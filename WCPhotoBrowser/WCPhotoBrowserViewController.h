//
//  WCPhotoBrowserViewController.h
//  PhotoBrowserDemo
//
//  Created by 王超 on 2017/11/28.
//  Copyright © 2017年 王超. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCPhotoModel;

@interface WCPhotoBrowserViewController : UIViewController

/**
 设置statusBar的显示与隐藏，默认隐藏。
 */
@property (nonatomic, assign) BOOL showStatusBar;

/**
 是否显示导航栏上（1/6）的提示，默认隐藏。
 */
@property (nonatomic, assign) BOOL displayPhotoOrderInfo;

/**
 是否显示屏幕底部的pageControl，默认隐藏。
 */
@property (nonatomic, assign) BOOL displayPageControl;

/**
 pageIndicator的颜色,默认为浅灰色
 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

/**
 当前所在的pageIndicator的颜色，默认为白色
 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/**
 占位图片，默认为nil。
 */
@property (nonatomic, strong) UIImage *placehoderImage;

/**
 首次展示图片的index，默认为0
 */
@property (nonatomic, assign) NSInteger firstDisplayPhotoIndex;

/**
 要展示的图片
 */
@property (nonatomic, strong) NSArray *networkImages;

/**
 展示本地图片
 */
@property (nonatomic, strong) NSArray<UIImage *> *localImages;

/**
 要展示模型
 */
@property (nonatomic, strong) NSArray<WCPhotoModel *> *images;

/**
 根据类型为<WCPhotoModel *>的数组进行初始化

 @param images 类型为<WCPhotoModel *>的数组
 @return PhotoBrowser
 */
- (instancetype)initWithImages:(NSArray<WCPhotoModel *> *)images;

/**
 根据类型为图片url字符串的数组进行初始化

 @param networkImages 类型为图片url字符串的数组
 @return PhotoBrowser
 */
- (instancetype)initWithNetworkImages:(NSArray *)networkImages;

/**
 根据类型为<UIImage *>的数组进行初始化

 @param localImages 类型为<UIImage *>的数组
 @return PhotoBrowser
 */
- (instancetype)initWithLocalImages:(NSArray<UIImage *> *)localImages;

@end
