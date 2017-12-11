# WCPhotoBrowser

[![Build](https://img.shields.io/badge/build-passing-green.svg)]() [![MIT](https://img.shields.io/badge/License-MIT-blue.svg)]() [![iOS](https://img.shields.io/badge/platform-iOS-lightgrey.svg)]() [![Support](https://img.shields.io/badge/support-iOS%208%2B-blue.svg)]() [![Github](https://img.shields.io/badge/github-MeetDay-yellowgreen.svg)]()

简易好用的图片浏览器

### 演示：

<div align=center>

![iPhone8_index_h](https://github.com/MeetDay/WCPhotoBrowser/blob/master/Assets/iPhone8_index_v.gif)   ![iPhone8_pagecontrol_h](https://github.com/MeetDay/WCPhotoBrowser/blob/master/Assets/iPhone8_pagecontrol_v.gif)   ![iPhone8_animator_h](https://github.com/MeetDay/WCPhotoBrowser/blob/master/Assets/iPhone8_animator_v.gif)

</div>

![iPhone8_pagecontrol_v](https://github.com/MeetDay/WCPhotoBrowser/blob/master/Assets/iPhone8_pagecontrol_h.gif)  ![iPhone8_index_v](https://github.com/MeetDay/WCPhotoBrowser/blob/master/Assets/iPhone8_index_h.gif)

# Installation

- #### CocoaPods
  
  ​暂时没有，待完善后发布至CocoaPods


- #### 手动安装
  
  1. 下载WCPhotoBrowserDemo。
  2. 将WCPhotoBrowser文件夹中的源代码添加(拖放)到你的工程。
  3. 导入WCPhotoBrowser.h都文件即可。

# Usage

- #### 导入头文件：

``` objective-c
#import "WCPhotoBrowser.h"
```

- #### 显示顶部的图片索引( 例如：1/6 )，隐藏底部的PageControl。

``` objective-c
WCPhotoBrowserViewController *photoBrowser = [[WCPhotoBrowserViewController alloc] init];
// 不显示底部的pageControl
photoBrowser.displayPageControl = NO;
// 首次展示第几张图片
photoBrowser.firstDisplayPhotoIndex = 2;
// 展示的是网络图片
photoBrowser.networkImages = self.networkImages;
// 展示的是本地图片
// photoBrowser.localImages = self.localImages;
// 显示图片浏览器
[photoBrowser show];
```

- #### 显示底部的PageControl，隐藏顶部的图片索引( 例如：1/6 )。

``` objective-c
WCPhotoBrowserViewController *photoBrowser = [[WCPhotoBrowserViewController alloc] init];
// 隐藏顶部图片索引
photoBrowser.showNavigationBar = NO;
// 显示PageControl
photoBrowser.displayPageControl = YES;
// pageIndicator的颜色
photoBrowser.pageIndicatorTintColor = [UIColor lightGrayColor];
// 当前pageIndicator的颜色
photoBrowser.currentPageIndicatorTintColor = [UIColor redColor];
// 首次展示第几张图片
photoBrowser.firstDisplayPhotoIndex = 3;
// 图片加载时的占位图片
photoBrowser.placehoderImage = [UIImage imageNamed:@"placeholder"];
// 展示的是网络图片
photoBrowser.networkImages = self.networkImages;
// 展示的是本地图片
// photoBrowser.localImages = self.localImages;
// 显示图片浏览器
[photoBrowser show];
```

- ##### 若想实现类似微信的图片查看效果：查看图片时从图片的初始位置开始放大至占满全屏，消失时从全屏状态慢慢缩放至图片的初始状态。

``` objective-c
WCPhotoBrowserViewController *photoBrowser = [[WCPhotoBrowserViewController alloc] init];
// 隐藏底部的pageControl
photoBrowser.displayPageControl = NO;
// 显示顶部的图片索引信息(例如： 1/6)
photoBrowser.displayPhotoOrderInfo = YES;
// 首次展示的图片，可根据点击的图片而定
photoBrowser.firstDisplayPhotoIndex = 3;
// 展示的图片
photoBrowser.localImages = self.images;
// 设置PhotoBrowser的转场代理
WCPhotoBrowserAnimator *animator = [[WCPhotoBrowserAnimator alloc] init];
// 设置WCPhotoBrowser的animatorDelegate
animator.animatorDelegate = self;
self.animator = animator;
photoBrowser.transitioningDelegate = self.animator;
// 显示图片浏览器
[photoBrowser show];
```

- ##### 设置WCPhotoBrowserAnimator的animatorDelegate并实现以下代理方法

``` objective-c
@protocol WCPhotoBrowserAnimatorDelegate <NSObject>

@required

/**
 根据下标返回将要展示的图片

 @param willDisplayImageIndex 将要展示图片的下标
 @return 返回将要展示的图片
 */
- (UIImage *)willDisplayImageInPhotoBrowserAtIndex:(NSInteger)willDisplayImageIndex;

/**
 根据图片下标返回将要展示图片相对屏幕的开始位置

 @param willDisplayImageIndex 将要展示图片的下标
 @return 将要展示图片的开始位置
 */
- (CGRect)willDisplayImageOfStartRectAtIndex:(NSInteger)willDisplayImageIndex;

/**
 根据图片下标返回将要展示图片相对屏幕的结束位置

 @param willDisplayImageIndex 将要展示图片的下标
 @return 将要展示图片动画结束后的位置
 */
- (CGRect)willDisplayImageOfEndRectAtIndex:(NSInteger)willDisplayImageIndex;

@end
```

- #### 支持单击屏幕隐藏图片浏览器

``` objective-c
// 是否允许单击屏幕隐藏图片浏览器，默认为YES
// 若singleTapGestureEnabled = YES, 单击屏幕则隐藏图片浏览器
// 若singleTapGestureEnabled = NO, 则未启用单击手势，单击屏幕图片浏览器不会消失
photoBrowser.singleTapGestureEnabled = YES;
```

- #### 支持长按手势

``` objective-c
// 启用长按手势，默认为NO
photoBrowser.longPressGestureEnabled = YES;
// 长按手势触发时的回调Block
photoBrowser.longPressGestureTriggerBlock = ^(WCPhotoBrowserViewController *photoBrowserViewController, UIImage *currentDisplayImage, NSInteger currentDisplayImageIndex) {
  // photoBrowserViewController: 图片浏览器
  // currentDisplayImage: 当前展示的图片
  // currentDisplayImageIndex: 当前展示图片的索引(下标)
};

/**************************** 或者 ****************************/

// 启用长按手势，默认为NO
photoBrowser.longPressGestureEnabled = YES;
// 设置photoBrowser的delegate
photoBrowser.delegate = self;
// 实现WCPhotoBrowserViewControllerDelegate
// 长按手势触发时会调用此代理方法
- (void)photoBrowser:(WCPhotoBrowserViewController *)photoBrowser longPressGestureTriggerAtCurrentDisplayImage:(UIImage *)currentDisplayImage {
  // 长按手势触时调用
}
```

- #### PhotoBrowser的代理协议： WCPhotoBrowserViewControllerDelegate

``` objective-c
@protocol WCPhotoBrowserViewControllerDelegate <NSObject>

@optional

/**
 当前展示图片的索引改变时调用此方法

 @param photoBrowser 图片浏览控制器
 @param currentDisplayImageIndex 当前展示图片的索引
 */
- (void)photoBrowser:(WCPhotoBrowserViewController *)photoBrowser currentDisplayImageIndex:(NSInteger)currentDisplayImageIndex;

/**
 当前展示图片的索引改变时调用此方法

 @param photoBrowser 图片浏览控制器
 @param currentDisplayImage 当前展示的图片
 @param currentDisplayImageIndex 当前展示图片的索引
 */
- (void)photoBrowser:(WCPhotoBrowserViewController *)photoBrowser currentDisplayImage:(UIImage *)currentDisplayImage currentDisplayImageIndex:(NSInteger)currentDisplayImageIndex;

/**
 当长按手势触发时调用此方法

 @param photoBrowser 图片浏览控制器
 @param currentDisplayImage 当前展示的图片
 */
- (void)photoBrowser:(WCPhotoBrowserViewController *)photoBrowser longPressGestureTriggerAtCurrentDisplayImage:(UIImage *)currentDisplayImage;

@end
```



# Change Log

- 敬请期待V0.0.1

# Contact

- [MeetDay](https://github.com/MeetDay)

# LICENSE

- 详情见 [LICENSE](https://github.com/MeetDay/WCPhotoBrowser/blob/master/LICENSE) 文件。