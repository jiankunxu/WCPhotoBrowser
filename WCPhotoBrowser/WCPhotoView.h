//
//  WCPhotoView.h
//  PhotoBrowserDemo
//
//  Created by 王超 on 2017/11/28.
//  Copyright © 2017年 王超. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCPhotoModel;

@interface WCPhotoView : UIView

/**
 图片所对应的索引
 */
@property (nonatomic, assign) NSUInteger photoIndex;

/**
 展示图片的数据源
 */
@property (nonatomic, strong) WCPhotoModel *photoModel;

/**
 占位图
 */
@property (nonatomic, strong) UIImage *placeholderImage;

/**
 准备复用的时候调用
 */
- (void)prepareForReuse;

@end
