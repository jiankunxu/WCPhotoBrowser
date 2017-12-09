//
//  ViewController.m
//  PhotoBrowserDemo
//
//  Created by 王超 on 2017/11/28.
//  Copyright © 2017年 王超. All rights reserved.
//

#import "ViewController.h"
#import "WCPhotoBrowser.h"

@interface ViewController ()

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

- (IBAction)buttonDidClicked:(UIButton *)sender {
    WCPhotoBrowserViewController *photoBrowser = [[WCPhotoBrowserViewController alloc] init];
    if (sender.tag == 1001) {
        photoBrowser.displayPageControl = YES;
        photoBrowser.pageIndicatorTintColor = [UIColor lightGrayColor];
        photoBrowser.currentPageIndicatorTintColor = [UIColor redColor];
        photoBrowser.showNavigationBar = NO;
        photoBrowser.firstDisplayPhotoIndex = 3;
        photoBrowser.networkImages = self.networkImages;
    } else {
        photoBrowser.displayPageControl = NO;
        photoBrowser.displayPhotoOrderInfo = YES;
        photoBrowser.firstDisplayPhotoIndex = 2;
        photoBrowser.localImages = self.localImages;
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

