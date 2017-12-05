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
    NSArray *images = @[
                        @"https://imgcloud4.fblife.com/FiecCeGGaQr7hL7Xh033UcaEFt8y",
                        @"https://imgcloud4.fblife.com/Fq-sMJWvLGe6rI9W3YcH-hM2_Q-2",
                        @"https://imgcloud4.fblife.com/Fo-9T-7gLxvfyx2oHjLzPuwdea7p",
                        @"https://imgcloud4.fblife.com/FvR5-J_jJcJ-Bm6wMF6duYLLvvTb",
                        @"https://imgcloud4.fblife.com/FrFQVSZikSPnYYd1nNVKwUFruggO",
                        @"https://imgcloud4.fblife.com/FgEAEnSXZCLZVkGdZ63QRPBDmmE_",
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1512032297305&di=0afdc563006d990bab463e33d4f21cc3&imgtype=0&src=http%3A%2F%2Fimg.ycwb.com%2Fnews%2Fattachement%2Fgif%2Fsite2%2F20160921%2F507b9d762551194c19be5f.gif"
                        ];
//    WCPhotoBrowserViewController *vc = [[WCPhotoBrowserViewController alloc] initWithNetworkImages:images];
    WCPhotoBrowserViewController *vc = [[WCPhotoBrowserViewController alloc] init];
    vc.networkImages = images;
    vc.firstDisplayPhotoIndex = 2;
    vc.showStatusBar = NO;
    vc.displayPhotoOrderInfo = YES;
    [vc show];
}

@end
