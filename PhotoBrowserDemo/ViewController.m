//
//  ViewController.m
//  PhotoBrowserDemo
//
//  Created by 王超 on 2017/11/28.
//  Copyright © 2017年 王超. All rights reserved.
//

#import "ViewController.h"
#import "WCPhotoBrowser.h"

@interface ViewController () <WCPhotoBrowserViewControllerDelegate>

@property (nonatomic, strong) NSArray *networkImages;
@property (nonatomic, strong) NSArray *localImages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PhotoBrowser View Controller Delegate

- (void)photoBrowser:(WCPhotoBrowserViewController *)photoBrowser currentDisplayImageIndex:(NSInteger)currentDisplayImageIndex {
    NSLog(@"currentDisplayImageIndex: =========> %td", currentDisplayImageIndex);
}

- (void)photoBrowser:(WCPhotoBrowserViewController *)photoBrowser currentDisplayImage:(UIImage *)currentDisplayImage currentDisplayImageIndex:(NSInteger)currentDisplayImageIndex {
    NSLog(@"currentDisplayImageIndex: ------> %td", currentDisplayImageIndex);
}

- (void)photoBrowser:(WCPhotoBrowserViewController *)photoBrowser longPressGestureTriggerAtCurrentDisplayImage:(UIImage *)currentDisplayImage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"发送给朋友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"发送给朋友...");
    }];
    UIAlertAction *saveImageAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"保存图片...");
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消...");
    }];
    [alertController addAction:shareAction];
    [alertController addAction:saveImageAction];
    [alertController addAction:cancleAction];
    if (photoBrowser.presentedViewController == nil) {
        [photoBrowser presentViewController:alertController animated:YES completion:nil];
    } else {
        [photoBrowser dismissViewControllerAnimated:NO completion:^{
            [photoBrowser presentViewController:alertController animated:YES completion:nil];
        }];
    }
}

- (IBAction)buttonDidClicked:(UIButton *)sender {
    WCPhotoBrowserViewController *photoBrowser = [[WCPhotoBrowserViewController alloc] init];
    photoBrowser.longPressGestureEnabled = YES;
    if (sender.tag == 1001) {
        photoBrowser.pageIndicatorTintColor = [UIColor lightGrayColor];
        photoBrowser.currentPageIndicatorTintColor = [UIColor redColor];
        photoBrowser.displayPageControl = YES;
        photoBrowser.showNavigationBar = NO;
        photoBrowser.networkImages = self.networkImages;
        photoBrowser.firstDisplayPhotoIndex = 4;
        
        photoBrowser.longPressGestureTriggerBlock = ^(WCPhotoBrowserViewController *photoBrowserViewController, UIImage *currentDisplayImage, NSInteger currentDisplayImageIndex) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"发送给朋友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"发送给朋友...");
            }];
            UIAlertAction *saveImageAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"保存图片...");
                if (currentDisplayImage) {
                    UIImageWriteToSavedPhotosAlbum(currentDisplayImage, nil, nil, nil);
                }
            }];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消...");
            }];
            [alertController addAction:shareAction];
            [alertController addAction:saveImageAction];
            [alertController addAction:cancleAction];
            if (photoBrowserViewController.presentedViewController == nil) {
                [photoBrowserViewController presentViewController:alertController animated:YES completion:nil];
            } else {
                [photoBrowserViewController.presentedViewController dismissViewControllerAnimated:NO completion:^{
                    [photoBrowserViewController presentViewController:alertController animated:YES completion:nil];
                }];
            }
        };
    } else {
        photoBrowser.displayPageControl = NO;
        photoBrowser.displayPhotoOrderInfo = YES;
        photoBrowser.firstDisplayPhotoIndex = 2;
        photoBrowser.localImages = self.localImages;
        photoBrowser.delegate = self;
    }
    [photoBrowser show];
}

- (NSArray *)networkImages {
    if (_networkImages == nil) {
        _networkImages = @[
                            @"https://imgcloud4.fblife.com/client_uploads/images/1368229/C6E0103BE0266BE12B8563685DE120E6",
                            @"https://imgcloud4.fblife.com/client_uploads/images/1368229/72073CE5BA2D0886B6E04F609ACE8A73",
                            @"https://imgcloud4.fblife.com/client_uploads/images/1368229/CEA3E04047B94C071822CAC72BE04F36",
                            @"https://imgcloud4.fblife.com/client_uploads/images/1368229/771B7FDBD6189EE36435021F5304AFE1",
                            @"https://imgcloud4.fblife.com/client_uploads/images/1368229/9D8A0B54C3D6FFFE0112FBEB4537A79C",
                            @"https://imgcloud4.fblife.com/client_uploads/images/1368229/F37766B1419F3F009467489E7D1E5B6D",
                            @"https://imgcloud4.fblife.com/client_uploads/images/1368229/73D44C10E4EABE104807BD9883891D63",
                            @"https://imgcloud4.fblife.com/client_uploads/images/1368229/19FB22FAB493DFA9963A552CEDE5CA17",
                            @"https://imgcloud4.fblife.com/client_uploads/images/1368229/42C328B2652A9FE0AB46CCF30BF051A6"
                            ];
    }
    return _networkImages;
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

//NSArray *images = @[
//                    @"https://imgcloud4.fblife.com/client_uploads/images/1368229/C6E0103BE0266BE12B8563685DE120E6",
//                    @"https://imgcloud4.fblife.com/client_uploads/images/1368229/72073CE5BA2D0886B6E04F609ACE8A73",
//                    @"https://imgcloud4.fblife.com/client_uploads/images/1368229/CEA3E04047B94C071822CAC72BE04F36",
//                    @"https://imgcloud4.fblife.com/client_uploads/images/1368229/771B7FDBD6189EE36435021F5304AFE1",
//                    @"https://imgcloud4.fblife.com/client_uploads/images/1368229/9D8A0B54C3D6FFFE0112FBEB4537A79C",
//                    @"https://imgcloud4.fblife.com/client_uploads/images/1368229/F37766B1419F3F009467489E7D1E5B6D",
//                    @"https://imgcloud4.fblife.com/client_uploads/images/1368229/73D44C10E4EABE104807BD9883891D63",
//                    @"https://imgcloud4.fblife.com/client_uploads/images/1368229/19FB22FAB493DFA9963A552CEDE5CA17",
//                    @"https://imgcloud4.fblife.com/client_uploads/images/1368229/42C328B2652A9FE0AB46CCF30BF051A6"
//                    ];

