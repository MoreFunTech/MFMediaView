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

    
    [self configureSvga];
//    [self configurePag];
//    [self configureFileHeaderCodePag];
//    [self configureImage];
    
//
    

}

- (void)configureSvga {
    
    //    "https://ruiqu-1304540262.sutanapp.com/0ae374225118bdb137f7d7e23206b5cf.pag"

    //    NSString *localPath = [NSBundle.mainBundle pathForResource:@"神仙伴侣内侧用的" ofType:@"svga"];
//        NSString *localPath = [NSBundle.mainBundle pathForResource:@"2_0080" ofType:@"pag"];
    NSString *netUrl = @"https://ruiqu-1304540262.sutanapp.com/cb8b4ad7755390853249455ec1ea4a02.svga";
    MFMediaViewModel *mediaViewModel = [MFMediaViewModel modelWithStyle:MFMediaViewModelStyleSvga url:netUrl];
    mediaViewModel.svgaConfig.repeatCount = 1;
    [mediaViewModel.svgaConfig setOnAnimationStartAction:^{
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n  动画开始播放\n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
    }];
    [mediaViewModel.svgaConfig setOnAnimationEndAction:^{
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n  动画结束播放\n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
    }];
    [mediaViewModel.svgaConfig setOnFileLoadingAction:^(CGFloat progress) {
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n  文件下载中: %f\n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n", progress);
    }];
    [mediaViewModel.svgaConfig setOnFileLoadFailureAction:^(NSError *error) {
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n  文件下载失败: %@\n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n", error.localizedDescription);
    }];
    [mediaViewModel.svgaConfig setOnFileLoadSuccessAction:^{
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

- (void)playNextPag {
    NSString *localPath = [NSBundle.mainBundle pathForResource:@"每日任务-仙狐-幼年期.pag" ofType:@""];
    MFMediaViewModel *mediaViewModel = self.mediaView.model;
    mediaViewModel.localPath = localPath;
    self.mediaView.model = mediaViewModel;
}

- (void)configurePag {
    
    __weak typeof(self) weakSelf = self;
    
    //    "https://ruiqu-1304540262.sutanapp.com/0ae374225118bdb137f7d7e23206b5cf.pag"
    //    NSString *localPath = [NSBundle.mainBundle pathForResource:@"神仙伴侣内侧用的" ofType:@"svga"];
    
//    NSString *netUrl = @"https://ruiqu-1304540262.sutanapp.com/40b82ce094db24f0c68dec790264e9a0.pag";
    NSString *netUrl = @"https://ruiqu-1304540262.sutanapp.com/0ae374225118bdb137f7d7e23206b5cf.pag";
    MFMediaViewModel *mediaViewModel = [MFMediaViewModel modelWithStyle:MFMediaViewModelStylePag url:netUrl];
    
//    NSString *localPath = [NSBundle.mainBundle pathForResource:@"2_0080.pag" ofType:@""];
//    NSString *localPath = [NSBundle.mainBundle pathForResource:@"text3.pag" ofType:@""];
//    NSString *localPath = [NSBundle.mainBundle pathForResource:@"pet_levelUp_animate.pag" ofType:@""];
//    NSString *localPath = [NSBundle.mainBundle pathForResource:@"animate017.pag" ofType:@""];
    
//    MFMediaViewModel *mediaViewModel = [MFMediaViewModel modelWithStyle:MFMediaViewModelStylePag localPath:localPath];
    
    mediaViewModel.pagConfig.repeatCount = 0;
    mediaViewModel.pagConfig.repeatStartTime = 1;
    mediaViewModel.pagConfig.repeatEndTime = 0;
    mediaViewModel.pagConfig.isAutoPlay = YES;
    
    mediaViewModel.pagConfig.scaleMode = MFMediaViewModelPAGConfigStyleScaleModeAspectToFit;
    mediaViewModel.pagConfig.maxFrameRate = 60;
    
    [mediaViewModel.pagConfig setOnAnimationStartAction:^{
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n  动画开始播放\n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
    }];
    [mediaViewModel.pagConfig setOnAnimationEndAction:^{
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n  动画结束播放\n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
//        [weakSelf playNextPag];
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
    
    
    [mediaViewModel.pagConfig.replaceLayerList addObject:
         [MFMediaViewModelPAGConfigReplaceLayerModel modelWithImage:nil layerName:@"mask_changebale.png"]
    ];
    
    [mediaViewModel.pagConfig.replaceLayerList addObject:
         [MFMediaViewModelPAGConfigReplaceLayerModel modelWithText:@"芜湖的" layerName:@"测试"]
    ];
    [mediaViewModel.pagConfig.replaceLayerList addObject:
         [MFMediaViewModelPAGConfigReplaceLayerModel modelWithText:@"323123123" layerName:@"text_pet_levelUp_changeable"]
    ];
    [mediaViewModel.pagConfig.replaceLayerList addObject:
         [MFMediaViewModelPAGConfigReplaceLayerModel modelWithImage:[UIImage imageNamed:@"pet_levelUp_image_age1"] layerName:@"image_pet_origin_changeable"]
    ];
    [mediaViewModel.pagConfig.replaceLayerList addObject:
         [MFMediaViewModelPAGConfigReplaceLayerModel modelWithImage:[UIImage imageNamed:@"pet_levelUp_image_age2"] layerName:@"image_pet_levelUp_changeable"]
    ];
    
    
    self.mediaView = [[MFMediaView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
    [self.view addSubview:self.mediaView];
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mediaView.model = mediaViewModel;
    });
}

- (void)configureFileHeaderCodePag {
    
    //    "https://ruiqu-1304540262.sutanapp.com/0ae374225118bdb137f7d7e23206b5cf.pag"

    //    NSString *localPath = [NSBundle.mainBundle pathForResource:@"神仙伴侣内侧用的" ofType:@"svga"];
    
//    NSString *netUrl = @"https://ruiqu-1304540262.sutanapp.com/40b82ce094db24f0c68dec790264e9a0.pag";
//    MFMediaViewModel *mediaViewModel = [MFMediaViewModel modelWithStyle:MFMediaViewModelStylePag url:netUrl];
    
//    NSString *localPath = [NSBundle.mainBundle pathForResource:@"test_replace_file.pag" ofType:@""];
//    NSString *localPath = [NSBundle.mainBundle pathForResource:@"升级-幼年期-成长期.pag" ofType:@""];
    NSString *localPath = [NSBundle.mainBundle pathForResource:@"弹窗.pag" ofType:@""];
    
//    NSString *localPath = [NSBundle.mainBundle pathForResource:@"升级-幼年期-成长期.pag" ofType:@""];
//    NSString *localPath = [NSBundle.mainBundle pathForResource:@"每日任务-仙狐-幼年期.pag" ofType:@""];
    
   
    
    NSData *fileData = [NSData dataWithContentsOfFile:localPath];
    
    int char1 = 0, char2 = 0;
    [fileData getBytes:&char1 range:NSMakeRange(0, 1)];
    [fileData getBytes:&char2 range:NSMakeRange(1, 1)];
    NSString *numCode = [NSString stringWithFormat:@"%d%d", char1, char2];
    NSLog(@"%@", numCode);
    
    NSMutableData *mutableData = [NSMutableData dataWithData:fileData];
    
    [mutableData replaceBytesInRange:NSMakeRange(0, 1) withBytes:"1"];
    [mutableData replaceBytesInRange:NSMakeRange(1, 1) withBytes:"1"];

    int char3 = 0, char4 = 0;
    [mutableData getBytes:&char3 range:NSMakeRange(0, 1)];
    [mutableData getBytes:&char4 range:NSMakeRange(1, 1)];
    NSString *numCode2 = [NSString stringWithFormat:@"%d%d", char3, char4];
    NSLog(@"%@", numCode2);
    
    NSString *path0 = [NSString stringWithFormat:@"%@/file0", [MFViewController documentBaseDirection]];
    if ([NSFileManager.defaultManager fileExistsAtPath:path0]) {
        NSError *error;
        [NSFileManager.defaultManager removeItemAtPath:path0 error:&error];
    }
    [mutableData writeToFile:path0 atomically:YES];
    
    [mutableData replaceBytesInRange:NSMakeRange(0, 1) withBytes:"P"];
    [mutableData replaceBytesInRange:NSMakeRange(1, 1) withBytes:"A"];

    int char5 = 0, char6 = 0;
    [mutableData getBytes:&char5 range:NSMakeRange(0, 1)];
    [mutableData getBytes:&char6 range:NSMakeRange(1, 1)];
    NSString *numCode3 = [NSString stringWithFormat:@"%d%d", char5, char6];
    NSLog(@"%@", numCode3);
    
    NSString *path = [NSString stringWithFormat:@"%@/file", [MFViewController documentBaseDirection]];
    if ([NSFileManager.defaultManager fileExistsAtPath:path]) {
        NSError *error;
        [NSFileManager.defaultManager removeItemAtPath:path error:&error];
    }
    [mutableData writeToFile:path atomically:YES];
    NSLog(@"%@", path);
    
    MFMediaViewModel *mediaViewModel = [MFMediaViewModel modelWithStyle:MFMediaViewModelStylePag localPath:path];
    
    
//    mediaViewModel.pagConfig.repeatCount = 1;
    mediaViewModel.pagConfig.scaleMode = MFMediaViewModelPAGConfigStyleScaleModeAspectToFit;
    mediaViewModel.pagConfig.maxFrameRate = 60;
    mediaViewModel.pagConfig.repeatCount = 1;
    [mediaViewModel.pagConfig setOnAnimationStartAction:^{
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n  动画开始播放\n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
    }];
    [mediaViewModel.pagConfig setOnAnimationEndAction:^{
        NSLog(@"\n┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n  动画结束播放\n┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
        
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
    
    [mediaViewModel.pagConfig.replaceLayerList addObject:
         [MFMediaViewModelPAGConfigReplaceLayerModel modelWithImage:nil layerName:@"mask_changeable.png"]
    ];

    self.mediaView = [[MFMediaView alloc] initWithFrame:CGRectMake(60, 100, 250, 250)];
    [self.view addSubview:self.mediaView];
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mediaView.model = mediaViewModel;
    });
}



- (void)configureImage {
//    NSString *urlStr = @"https://lmg.jj20.com/up/allimg/4k/s/02/2109242332225H9-0-lp.jpg";
    NSString *urlStr = @"https://img.zcool.cn/community/0197d259ccc891a8012053f8cb26e3.gif";
    MFMediaViewModel *mediaViewModel = [MFMediaViewModel modelWithStyle:MFMediaViewModelStyleGif url:urlStr];
    mediaViewModel.gifConfig.contentMode = UIViewContentModeScaleAspectFill;
    mediaViewModel.gifConfig.repeatCount = 1;
    mediaViewModel.gifConfig.isAutoPlay = NO;
    mediaViewModel.gifConfig.onFileLoadingAction = ^ (CGFloat progress) {
        NSLog(@"onFileLoadingAction : %f", progress);
    };
    mediaViewModel.gifConfig.onFileLoadSuccessAction = ^ {
        NSLog(@"onFileLoadSuccessAction");
    };
    mediaViewModel.gifConfig.onAnimationStartAction = ^ {
        NSLog(@"onAnimationStartAction");
    };
    mediaViewModel.gifConfig.onAnimationEndAction = ^ {
        NSLog(@"onAnimationEndAction");
    };
    
    
    
    self.mediaView = [[MFMediaView alloc] initWithFrame:CGRectMake(60, 100, 250, 250)];
    [self.view addSubview:self.mediaView];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mediaView.model = mediaViewModel;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mediaView startPlayAnimate];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mediaView stopPlayAnimate];
    });
    
    
}



+ (NSString *)dataBaseDirection {
//    NSString *rootDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *rootDirectory = @"";
    rootDirectory = [rootDirectory stringByAppendingPathComponent:@"MFPodFiles"];
    rootDirectory = [rootDirectory stringByAppendingPathComponent:@"MediaView"];
    return rootDirectory;
}

+ (NSString *)documentBaseDirection {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
