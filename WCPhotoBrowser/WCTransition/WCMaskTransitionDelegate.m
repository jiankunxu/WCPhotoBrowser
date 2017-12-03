//
//  WCMaskTransitionDelegate.m
//  PhotoBrowserDemo
//
//  Created by 王超 on 2017/12/2.
//  Copyright © 2017年 王超. All rights reserved.
//

#import "WCMaskTransitionDelegate.h"
#import "WCMaskAnimatedTransition.h"

@implementation WCMaskTransitionDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[WCMaskAnimatedTransition alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[WCMaskAnimatedTransition alloc] init];
}
@end
