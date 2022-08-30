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

@property (nonatomic, strong) MFMediaView *mediaView;

@end

@implementation MFViewController

- (void)viewDidLoad {
    [super viewDidLoad];


//    "https://ruiqu-1304540262.sutanapp.com/0ae374225118bdb137f7d7e23206b5cf.pag"

    NSString *localPath = [NSBundle.mainBundle pathForResource:@"神仙伴侣内侧用的" ofType:@"svga"];
//    NSString *localPath = [NSBundle.mainBundle pathForResource:@"神仙伴侣2" ofType:@"pag"];
    MFMediaViewModel *mediaViewModel = [MFMediaViewModel modelWithStyle:MFMediaViewModelStylePag localPath:localPath];
//    mediaViewModel.pagConfig.repeatCount = 1;
//    mediaViewModel.pagConfig.scaleMode = MFMediaViewModelPAGConfigStyleScaleModeAspectToFit;
//    mediaViewModel.pagConfig.maxFrameRate = 60;
    [mediaViewModel.pagConfig setOnAnimateStopAction:^{
        NSLog(@"-====----");
    }];
    [mediaViewModel.svgaConfig setSvgaPlayerDidFinishedAnimation:^{
        NSLog(@"-====----");
    }];

    self.mediaView = [[MFMediaView alloc] initWithFrame:CGRectMake(60, 100, 250, 250)];
    [self.view addSubview:self.mediaView];
    self.mediaView.mediaLoadFinishBlock = ^(MFMediaViewModel *model) {
        NSLog(@"%@", model);
    };

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mediaView.model = mediaViewModel;
    });
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
