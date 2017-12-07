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

- (IBAction)buttonDidClicked:(id)sender {
    
    WCPhotoBrowserViewController *photoBrowser = [[WCPhotoBrowserViewController alloc] init];
    photoBrowser.displayPageControl = NO;
    photoBrowser.displayPhotoOrderInfo = YES;
//    photoBrowser.showStatusBar = NO;
    NSArray *images = @[
                        @"https://imgcloud4.fblife.com/FrFQVSZikSPnYYd1nNVKwUFruggO",
                        @"https://imgcloud4.fblife.com/FvR5-J_jJcJ-Bm6wMF6duYLLvvTb",
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
    photoBrowser.networkImages = images;
    [photoBrowser show];
}

@end
