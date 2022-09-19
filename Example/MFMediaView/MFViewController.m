//
//  MFViewController.m
//  MFMediaView
//
//  Created by NealWills on 08/08/2022.
//  Copyright (c) 2022 NealWills. All rights reserved.
//

#import "MFViewController.h"

#import <MFMediaView/MFMediaView.h>

@interface MFViewController ()

@property(nonatomic, strong) MFMediaView *mediaView;

@end

@implementation MFViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    [self configureSvga];
//    [self configurePag];
    [self configureImage];
    
//
    

}

- (void)configureSvga {
    
    //    "https://ruiqu-1304540262.sutanapp.com/0ae374225118bdb137f7d7e23206b5cf.pag"

    //    NSString *localPath = [NSBundle.mainBundle pathForResource:@"神仙伴侣内侧用的" ofType:@"svga"];
//        NSString *localPath = [NSBundle.mainBundle pathForResource:@"2_0080" ofType:@"pag"];
    NSString *netUrl = @"https://ruiqu-1304540262.sutanapp.com/cb8b4ad7755390853249455ec1ea4a02.svga";
    MFMediaViewModel *mediaViewModel = [MFMediaViewModel modelWithStyle:MFMediaViewModelStyleSvga url:netUrl];
    [mediaViewModel.pagConfig setOnAnimateStopAction:^{
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n \n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
    }];
    [mediaViewModel.pagConfig setOnFileLoadingAction:^(CGFloat progress) {
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n  文件下载中: %f\n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n", progress);
    }];
    [mediaViewModel.pagConfig setOnFileLoadFailureAction:^(NSError *error) {
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n  文件下载失败: %@\n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n", error.localizedDescription);
    }];
    [mediaViewModel.pagConfig setOnFileLoadSuccessAction:^{
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n  文件下载成功\n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
    }];
    
    [mediaViewModel.svgaConfig setOnAnimationStartAction:^{
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n-====----\n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
    }];

    self.mediaView = [[MFMediaView alloc] initWithFrame:CGRectMake(60, 100, 250, 250)];
    [self.view addSubview:self.mediaView];
    self.mediaView.mediaLoadFinishBlock = ^(MFMediaViewModel *model) {
        NSLog(@"%@", model);
    };

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mediaView.model = mediaViewModel;
    });
}

- (void)configurePag {
    
    //    "https://ruiqu-1304540262.sutanapp.com/0ae374225118bdb137f7d7e23206b5cf.pag"

    //    NSString *localPath = [NSBundle.mainBundle pathForResource:@"神仙伴侣内侧用的" ofType:@"svga"];
//        NSString *localPath = [NSBundle.mainBundle pathForResource:@"2_0080" ofType:@"pag"];
    NSString *netUrl = @"https://ruiqu-1304540262.sutanapp.com/40b82ce094db24f0c68dec790264e9a0.pag";
    MFMediaViewModel *mediaViewModel = [MFMediaViewModel modelWithStyle:MFMediaViewModelStylePag url:netUrl];
    mediaViewModel.pagConfig.repeatCount = 40;
    mediaViewModel.pagConfig.scaleMode = MFMediaViewModelPAGConfigStyleScaleModeAspectToFit;
    mediaViewModel.pagConfig.maxFrameRate = 60;
    [mediaViewModel.pagConfig setOnAnimateStopAction:^{
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n \n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
    }];
    [mediaViewModel.pagConfig setOnFileLoadingAction:^(CGFloat progress) {
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n  文件下载中: %f\n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n", progress);
    }];
    [mediaViewModel.pagConfig setOnFileLoadFailureAction:^(NSError *error) {
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n  文件下载失败: %@\n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n", error.localizedDescription);
    }];
    [mediaViewModel.pagConfig setOnFileLoadSuccessAction:^{
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n  文件下载成功\n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
    }];

    self.mediaView = [[MFMediaView alloc] initWithFrame:CGRectMake(60, 100, 250, 250)];
    [self.view addSubview:self.mediaView];
    self.mediaView.mediaLoadFinishBlock = ^(MFMediaViewModel *model) {
        NSLog(@"%@", model);
    };

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mediaView.model = mediaViewModel;
    });
}


- (void)configureImage {
    NSString *urlStr = @"https://lmg.jj20.com/up/allimg/4k/s/02/2109242332225H9-0-lp.jpg";
    MFMediaViewModel *mediaViewModel = [MFMediaViewModel modelWithStyle:MFMediaViewModelStyleGif url:urlStr];
    mediaViewModel.imageConfig.contentMode = UIViewContentModeScaleAspectFill;
    self.mediaView = [[MFMediaView alloc] initWithFrame:CGRectMake(60, 100, 250, 250)];
    [self.view addSubview:self.mediaView];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mediaView.model = mediaViewModel;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
