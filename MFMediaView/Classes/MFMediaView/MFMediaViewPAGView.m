//
// Created by Neal on 2022/8/8.
//

#import "MFMediaViewPAGView.h"
#import "MFMediaViewModel.h"
#import <libpag/PAGView.h>
#import <libpag/PAGTextLayer.h>
#import <MFFileDownloader/MFFileDownloader.h>

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

@end

@implementation MFMediaViewPAGView {

}

- (void)startPlayAnimate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pagView play];
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
    [self.model.pagConfig configModelWithFile:_pagFile];
    [self.pagFile seTimeStretchMode:PAGTimeStretchModeScale];
    [self.pagView setRepeatCount:@(self.model.pagConfig.repeatCount).intValue];
    [self.pagView setComposition:_pagFile];
    
    if (self.model.pagConfig.isAutoPlay) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pagView play];
        });
    }
}

- (void)configRepeatStyleD2Animate {
    self.isAreaRepeatStart = NO;
    [self.model.pagConfig configModelWithFile:_pagFile];
    [self.pagFile seTimeStretchMode:PAGTimeStretchModeScale];
    [self.pagView setRepeatCount:1];
    [self.pagView setComposition:_pagFile];
    
    if (self.model.pagConfig.isAutoPlay) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pagView play];
        });
    }
}

- (void)configRepeatStyleD3Animate {
    self.isAreaRepeatStart = YES;
    [self.pagFile seTimeStretchMode:PAGTimeStretchModeScale];
    PAGComposition *composition = [PAGComposition Make:CGSizeMake(self.pagView.frame.size.width * UIScreen.mainScreen.scale, self.pagView.frame.size.height * UIScreen.mainScreen.scale)];
    
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
    
    [self.pagView setRepeatCount:@(self.model.pagConfig.repeatCount).intValue];
    [composition addLayer:self.pagFile];
    [self.pagView setComposition:composition];
    [self.pagView setRepeatCount:@(self.model.pagConfig.repeatCount).intValue];
    
    if (self.model.pagConfig.isAutoPlay) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pagView play];
        });
    }
}

- (void)configRepeatStyleD4Animate {
    self.isAreaRepeatStart = YES;
    [self.pagFile seTimeStretchMode:PAGTimeStretchModeScale];
    PAGComposition *composition = [PAGComposition Make:CGSizeMake(self.pagView.frame.size.width * UIScreen.mainScreen.scale, self.pagView.frame.size.height * UIScreen.mainScreen.scale)];
    
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
    
    [self.pagView setRepeatCount:1];
    [composition addLayer:self.pagFile];
    [self.pagView setComposition:composition];
    
    [self.pagView setRepeatCount:1];
    
    if (self.model.pagConfig.isAutoPlay) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pagView play];
        });
    }
}

- (void)replaceLayerAction {
    
    
    [self.model.pagConfig.replaceLayerList enumerateObjectsUsingBlock:^(MFMediaViewModelPAGConfigReplaceLayerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray * layerList = [self.pagFile getLayersByName:obj.layerName];
        if (layerList.count > 0) {
            PAGLayer *layer = layerList[0];
            
            if (layer.layerType == PAGLayerTypeImage &&
                [layer.layerName isEqualToString:obj.layerName] &&
                obj.style == MFMediaViewModelPAGConfigReplaceLayerModelStyleImage) {
                
                PAGImage *pagImage = [PAGImage FromCGImage:obj.image.CGImage];
                [self.pagFile replaceImage:@(layer.editableIndex).intValue data:pagImage];
                
            }
            
            if (layer.layerType == PAGLayerTypeText && obj.style == MFMediaViewModelPAGConfigReplaceLayerModelStyleText) {
                PAGTextLayer *textLayer = (PAGTextLayer *)layer;
                textLayer.text = obj.text;
            }
            
        }
    }];

}

- (void)resetSubviews {
    self.pagView.frame = self.bounds;
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

/**
 * Notifies the end of the animation.
 */
- (void)onAnimationEnd:(PAGView *)pagView {
    if (self.model.pagConfig.repeatStyle == 0) {
        
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

@end
