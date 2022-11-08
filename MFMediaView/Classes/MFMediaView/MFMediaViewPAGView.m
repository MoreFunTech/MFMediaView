//
// Created by Neal on 2022/8/8.
//

#import "MFMediaViewPAGView.h"
#import "MFMediaViewModel.h"
#import <libpag/PAGView.h>
#import <libpag/PAGTextLayer.h>
#import <libpag/PAGImageLayer.h>
#import <MFFileDownloader/MFFileDownloader.h>
#import "MFMediaViewConfig.h"

@interface MFMediaViewPAGView () <PAGViewListener>

/**
 * pag文件加载视图
 */
@property(nonatomic, strong) PAGView *pagView;

/**
 * pag文件资源文件
 */
@property(nonatomic, strong) PAGFile *pagFile;

@property(nonatomic, assign) BOOL isAreaRepeatStart;

@property(nonatomic, strong) UIButton *testButton;

@end

@implementation MFMediaViewPAGView {

}

- (void)startPlayAnimate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pagView play];
    });
}

- (void)restartPlayAnimate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pagView play];
        [self.pagView setProgress:0];
    });
}

- (void)stopPlayAnimate {
    [self.pagView stop];
}

- (void)configureDefaultView:(MFMediaViewModel *)model {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.pagView) {

            self.pagView = [[PAGView alloc] initWithFrame:self.bounds];
            self.pagView.maxFrameRate = model.pagConfig.maxFrameRate;
            [self.pagView addListener:self];
            
            if ([MFMediaViewConfig isCurrentDebugMode]) {
//                self.pagView.userInteractionEnabled = YES;
//                UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pagViewLongPressAction:)];
//                longPressGes.minimumPressDuration = 1;
//                [self.pagView addGestureRecognizer:longPressGes];
                self.testButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 15, 30, 15)];
                self.testButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
                self.testButton.titleLabel.font = [UIFont systemFontOfSize:10];
                [self.testButton setTitle:@"调试" forState:(UIControlStateNormal)];
                [self.testButton setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:(UIControlStateNormal)];
                [self.testButton addTarget:self action:@selector(testClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
                [self addSubview:self.testButton];
            }
            
            if (model.pagConfig.repeatStyle == -2) {
                [self.pagView setRepeatCount:1];
            } if (model.pagConfig.repeatStyle == -3) {
                [self.pagView setRepeatCount:1];
            } if (model.pagConfig.repeatStyle == -4) {
                [self.pagView setRepeatCount:1];
            } else if (model.pagConfig.repeatCount >= 0) {
                [self.pagView setRepeatCount:(int) model.pagConfig.repeatCount];
            }
            switch (model.pagConfig.scaleMode) {
                case MFMediaViewModelPAGConfigStyleScaleModeNone:
                    self.pagView.scaleMode = PAGScaleModeNone;
                    break;
                case MFMediaViewModelPAGConfigStyleScaleModeFill:
                    self.pagView.scaleMode = PAGScaleModeStretch;
                    break;
                case MFMediaViewModelPAGConfigStyleScaleModeAspectToFit:
                    self.pagView.scaleMode = PAGScaleModeLetterBox;
                    break;
                case MFMediaViewModelPAGConfigStyleScaleModeAspectToFill:
                    self.pagView.scaleMode = PAGScaleModeZoom;
                    break;
            }
            [self addSubview:self.pagView];
        }
        [self configureView:model];
        if (self.testButton) {
            [self bringSubviewToFront:self.testButton];
        }
    });
    
    
}

- (void)setModel:(MFMediaViewModel *)model {
    _model = model;
    self.isAreaRepeatStart = NO;
    if (!model) {
        [self configureView:model];
    } else {
        [self configureDefaultView:model];
    }
}

- (void)configureView:(MFMediaViewModel *)model {
    
    MFFileDownloaderFileModel *fileModel = [[MFFileDownloaderFileModel alloc] init];
    fileModel.mediaType = 6;
    fileModel.url = model.url;
    fileModel.localPath = model.localPath;
    
    if ([self isStringNotNull:model.localPath]) {
        [self configureViewStartPlayWith:model.localPath];
    } else if ([self isStringNotNull:fileModel.url]) {
        [self configureViewStartDownload:fileModel];
    } else {
        [self.pagView stop];
        [self.pagFile removeAllLayers];
    }
    
}

- (void)configureViewStartDownload:(MFFileDownloaderFileModel *)model {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MFFileDownloaderFMDBManager defaultConfigure];
        __weak typeof(self) weakSelf = self;
        [MFFileDownloader addDownloadFile:model resultBlock:^(MFFileDownloaderDownloadResultModel * _Nonnull resultModel) {
            if (resultModel.downloadStatus == MFFileDownloaderDownloadStatusDownloading) {
                if (weakSelf.model.pagConfig.onFileLoadingAction) {
                    double completeCount = 0;
                    double totalCount = 1;
                    completeCount = @(resultModel.progress.completedUnitCount).doubleValue;
                    totalCount = @(resultModel.progress.totalUnitCount).doubleValue;
                    if (totalCount < 1) {
                        totalCount = 1;
                    }
                    weakSelf.model.pagConfig.onFileLoadingAction(completeCount / totalCount);
                }
            } else if (resultModel.downloadStatus == MFFileDownloaderDownloadStatusDownloadFinish) {
                weakSelf.model.localPath = resultModel.fileModel.fullLocalPath;
                [weakSelf configureViewStartPlayWith:resultModel.fileModel.fullLocalPath];
                if (weakSelf.model.pagConfig.onFileLoadSuccessAction) {
                    weakSelf.model.pagConfig.onFileLoadSuccessAction();
                }
            } else if (resultModel.downloadStatus == MFFileDownloaderDownloadStatusDownloadError) {
                if (weakSelf.model.pagConfig.onFileLoadFailureAction) {
                    weakSelf.model.pagConfig.onFileLoadFailureAction(resultModel.error);
                }
            } else {
                if (weakSelf.model.pagConfig.onFileLoadFailureAction) {
                    weakSelf.model.pagConfig.onFileLoadFailureAction(resultModel.error);
                }
            }
        }];
    
        
    });
}


- (void)configureViewStartPlayWith:(NSString *)localPath {
    if ([self isStringNotNull:localPath]) {
        _pagFile = [PAGFile Load:localPath];
    } else {
        _pagFile = nil;
    }
    
    if (!_pagFile) {
        if (self.model.pagConfig.onFileLoadFailureAction) {
            self.model.pagConfig.onFileLoadFailureAction([NSError errorWithDomain:@"com.MediaView.error" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"pag文件无法加载"}]);
        }
        return;
    }
    
    [self replaceLayerAction];
    
    self.model.imageWidth = self.pagFile.width;
    self.model.imageHeight = self.pagFile.height;
    self.model.during = self.pagFile.duration;
                
    if (self.model.pagConfig.repeatStyle == 0) {
        [self configRepeatStyle0Animate];
    } else if (self.model.pagConfig.repeatStyle == -2) {
        [self configRepeatStyleD2Animate];
    } else if (self.model.pagConfig.repeatStyle == -3) {
        [self configRepeatStyleD3Animate];
    } else if (self.model.pagConfig.repeatStyle == -4) {
        [self configRepeatStyleD4Animate];
    }
    
    if (self.mediaLoadFinishBlock) {
        self.mediaLoadFinishBlock(self.model);
    }

}

- (void)configRepeatStyle0Animate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.model.pagConfig configModelWithFile:self.pagFile];
        [self.pagFile seTimeStretchMode:PAGTimeStretchModeNone];
        [self.pagView setRepeatCount:@(self.model.pagConfig.repeatCount).intValue];
        [self.pagView setComposition:self.pagFile];
        if (self.model.pagConfig.isAutoPlay) {
            [self.pagView play];
            if (self.model.pagConfig.startProgress > 0) {
                [self.pagView setProgress:self.model.pagConfig.startProgress];
            }
        }
        [self.pagView setRepeatCount:@(self.model.pagConfig.repeatCount).intValue];
    });
    
}

- (void)configRepeatStyleD2Animate {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isAreaRepeatStart = NO;
        [self.model.pagConfig configModelWithFile:self.pagFile];
        [self.pagFile seTimeStretchMode:PAGTimeStretchModeNone];
        [self.pagView setRepeatCount:1];
        [self.pagView setComposition:self.pagFile];
        if (self.model.pagConfig.isAutoPlay) {
            [self.pagView play];
        }
        [self.pagView setRepeatCount:1];
    });
}

- (void)configRepeatStyleD3Animate {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isAreaRepeatStart = YES;
        [self.pagFile seTimeStretchMode:PAGTimeStretchModeNone];
        PAGComposition *composition = [PAGComposition Make:CGSizeMake([self.pagFile width], [self.pagFile height])];
        
        if (self.model.pagConfig.repeatStartTime < 0) {
            [self.pagFile setStartTime:0];
        } else {
            [self.pagFile setStartTime:-@(self.model.pagConfig.repeatStartTime * 1000000).intValue];
        }
        if (self.model.pagConfig.repeatEndTime < 0) {
            [self.pagFile setDuration:self.model.pagConfig.aniamteDuring];
        } else if (self.model.pagConfig.repeatEndTime < self.model.pagConfig.repeatStartTime) {
            [self.pagFile setDuration:self.model.pagConfig.aniamteDuring];
        } else {
            [self.pagFile setDuration:@(self.model.pagConfig.repeatEndTime * 1000000).intValue];
        }
        
        [composition addLayer:self.pagFile];
        [self.pagView setComposition:composition];
        [self.pagView setRepeatCount:@(self.model.pagConfig.repeatCount).intValue];
        if (self.model.pagConfig.isAutoPlay) {
            [self.pagView play];
        }
        [self.pagView setRepeatCount:@(self.model.pagConfig.repeatCount).intValue];
    });
}

- (void)configRepeatStyleD4Animate {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isAreaRepeatStart = YES;
        [self.pagFile seTimeStretchMode:PAGTimeStretchModeNone];
        
        CGFloat progress = self.model.pagConfig.repeatStartTime / (self.model.pagConfig.repeatEndTime + 1);
        progress = progress < 0 ? 0 : progress;
        progress = progress > 1 ? 1 : progress;
        
        [self.pagView setComposition:self.pagFile];
        [self.pagView play];
        [self.pagView setProgress:progress];
        [self.pagView stop];
        
    });
}

- (void)replaceLayerAction {
    
    int count = @(self.pagFile.numChildren).intValue;
    for (int i = 0; i < count; i++) {
        PAGLayer *layer = [self.pagFile getLayerAt:i];
        [self.model.pagConfig.replaceLayerList enumerateObjectsUsingBlock:^(MFMediaViewModelPAGConfigReplaceLayerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self isStringNotNull:obj.text] && layer.layerType == PAGLayerTypeText) {
                if ([layer.layerName isEqualToString:obj.layerName]) {
                    PAGTextLayer *textLayer = (PAGTextLayer *)layer;
                    textLayer.text = obj.text;
                } else if (i == obj.layerIndex) {
                    PAGTextLayer *textLayer = (PAGTextLayer *)layer;
                    textLayer.text = obj.text;
                }
            }
            if (obj.image && layer.layerType == PAGLayerTypeImage) {
                if ([layer.layerName isEqualToString:obj.layerName]) {
                    PAGImageLayer *imageLayer = (PAGImageLayer *)layer;
                    [imageLayer setImage:[PAGImage FromCGImage:obj.image.CGImage]];
                } else if (i == obj.layerIndex) {
                    PAGImageLayer *imageLayer = (PAGImageLayer *)layer;
                    [imageLayer setImage:[PAGImage FromCGImage:obj.image.CGImage]];
                }
            }
            
            if (obj.handleTyle == MFMediaViewModelPAGConfigHandleLayerStyleMatrix) {
                if ([layer.layerName isEqualToString:obj.layerName]) {
                    [layer setMatrix:obj.matrix];
                } else if (i == obj.layerIndex) {
                    [layer setMatrix:obj.matrix];
                }
            }
            
            if (obj.image && layer.layerType == PAGLayerTypePreCompose && obj.isSpecialBMP) {
                if ([layer.layerName isEqualToString:obj.layerName]) {
                    [self.pagFile replaceImage:i data:[PAGImage FromCGImage:obj.image.CGImage]];
                } else if (i == obj.layerIndex) {
                    [self.pagFile replaceImage:i data:[PAGImage FromCGImage:obj.image.CGImage]];
                }
            }
        }];
    }
    
//    [self.model.pagConfig.replaceLayerList enumerateObjectsUsingBlock:^(MFMediaViewModelPAGConfigReplaceLayerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSArray * layerList = [self.pagFile getLayersByName:obj.layerName];
//        if (layerList.count > 0) {
//            PAGLayer *layer = layerList[0];
//
//            if (layer.layerType == PAGLayerTypeImage &&
//                obj.style == MFMediaViewModelPAGConfigReplaceLayerModelStyleImage) {
//                if ([layer.layerName isEqualToString:obj.layerName]) {
//
//                } else if (obj.layerIndex == 0) {
//
//                }
//                PAGImage *pagImage = [PAGImage FromCGImage:obj.image.CGImage];
//                [self.pagFile replaceImage:@(layer.editableIndex).intValue data:pagImage];
//            }
//
//            if (layer.layerType == PAGLayerTypeText && obj.style == MFMediaViewModelPAGConfigReplaceLayerModelStyleText) {
//                PAGTextLayer *textLayer = (PAGTextLayer *)layer;
//                textLayer.text = obj.text;
//            }
//
//        }
//    }];

}

- (void)resetSubviews {
    CGRect newFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.pagView.frame = newFrame;
    self.testButton.frame = CGRectMake(0, self.bounds.size.height - 15, 30, 15);
//    self.testButton.frame = self.bounds;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (point.x > self.testButton.frame.origin.x - 30 &&
        point.x < self.testButton.frame.origin.x + self.testButton.frame.size.width + 30 &&
        point.y > self.testButton.frame.origin.y - 30 &&
        point.y < self.testButton.frame.origin.y + self.testButton.frame.size.height + 30) {
        return self.testButton;
    }
    return [super hitTest:point withEvent:event];
}

- (void)clear {
    [_pagView removeListener:self];
}

#pragma mark - Update Method

- (void)updatePagWithRepeatCount:(NSUInteger)repeatCount repeatStyle:(NSInteger)repeatStyle repeatStartTime:(float)repeatStartTime repeatEndTime:(float)repeatEndTime {
    self.isAreaRepeatStart = NO;
    self.model.pagConfig.repeatStyle = repeatStyle;
    self.model.pagConfig.repeatCount = repeatCount;
    self.model.pagConfig.repeatStartTime = repeatStartTime;
    self.model.pagConfig.repeatEndTime = repeatEndTime;
    [self configureView:self.model];
}

- (void)updatePagWithScaleMode:(NSInteger)scaleMode {
    self.pagView.scaleMode = (PAGScaleMode)scaleMode;
}

- (void)updatePagWithReplaceLayerList:(NSArray *)replaceLayerList {
    self.model.pagConfig.replaceLayerList = replaceLayerList.mutableCopy;
    [self configureView:self.model];
}

- (void)updatePagWithMaxFrameRate:(NSUInteger)maxFrameRate {
    self.pagView.maxFrameRate = maxFrameRate;
}

- (void)seekToProgress:(CGFloat)progress {
    [self.pagView setProgress:progress];
}

/**
 * Notifies the end of the animation.
 */
- (void)onAnimationEnd:(PAGView *)pagView {
    if (self.model.pagConfig.repeatStyle == 0) {
        if (self.model.pagConfig.onAnimationEndAction) {
            self.model.pagConfig.onAnimationEndAction();
        }
        return;
    }
    if (self.model.pagConfig.repeatStyle == -2) {
        if (self.isAreaRepeatStart) {
            return;
        }
        [self configRepeatStyleD3Animate];
        
        if (self.model.pagConfig.onAnimationEndAction) {
            self.model.pagConfig.onAnimationEndAction();
        }
        return;
    }
    if (self.model.pagConfig.repeatStyle == -3) {
        if (self.isAreaRepeatStart) {
            return;
        }
        if (self.model.pagConfig.onAnimationEndAction) {
            self.model.pagConfig.onAnimationEndAction();
        }
        return;
    }
    if (self.model.pagConfig.repeatStyle == -4) {
        if (self.isAreaRepeatStart) {
            return;
        }
        if (self.model.pagConfig.onAnimationEndAction) {
            self.model.pagConfig.onAnimationEndAction();
        }
        return;
    }
}

- (void)onAnimationStart:(PAGView *)pagView {
    if (self.model.pagConfig.onAnimationStartAction) {
        self.model.pagConfig.onAnimationStartAction();
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (BOOL)isStringNotNull:(NSString *)string {
    if ([string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    if (string.length <= 0) {
        return NO;
    }
    return YES;
}



- (void)testClickAction:(UIButton *)button {
    NSURL *fileUrl = [NSURL fileURLWithPath:self.model.localPath];
    NSArray *activityItem = @[fileUrl];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItem applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [MFMediaViewPAGView.getCurrentViewController.navigationController presentViewController:activityVC animated:YES completion:^{
            
    }];
    activityVC.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        if (completed) {
            
        } else {
            
        }
    };
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentViewController {
    UIViewController *current = nil;
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (!root) {
        root = [UIApplication sharedApplication].delegate.window.rootViewController;
    }
    do {
        if ([root isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)root;
            UIViewController *vc = [navi.viewControllers lastObject];
            current = vc;
            root = vc.presentedViewController;
            continue;
        } else if([root isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)root;
            current = tab;
            root = tab.viewControllers[tab.selectedIndex];
            continue;
        } else if([root isKindOfClass:[UIViewController class]]) {
            current = root;
            root = nil;
        }
    } while (root != nil);
    return current;
}

@end
