//
// Created by Neal on 2022/8/8.
//

#import "MFMediaViewPAGView.h"
#import "MFMediaViewModel.h"
#include <libpag/PAGView.h>
#include <MFFileDownloader/MFFileDownloader.h>

@interface MFMediaViewPAGView () <PAGViewListener>

/**
 * pag文件加载视图
 */
@property(nonatomic, strong) PAGView *pagView;

/**
 * pag文件资源文件
 */
@property(nonatomic, strong) PAGFile *pagFile;

@end

@implementation MFMediaViewPAGView {

}

- (void)configureDefaultView:(MFMediaViewModel *)model {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.pagView) {

            self.pagView = [[PAGView alloc] initWithFrame:self.bounds];
            self.pagView.maxFrameRate = model.pagConfig.maxFrameRate;
            [self.pagView addListener:self];
            [self.pagView setRepeatCount:(int) model.pagConfig.repeatCount];
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
        MFFileDownloaderCommonResultModel *fileDownloadModel = [MFFileDownloader addDownloadFile:model resultBlock:^(MFFileDownloaderDownloadResultModel * _Nonnull resultModel) {
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
                if (weakSelf.model.pagConfig.onFileLoadSuccessAction) {
                    weakSelf.model.pagConfig.onFileLoadSuccessAction();
                }
                [weakSelf configureViewStartPlayWith:resultModel.fileModel.fullLocalPath];
            } else if (resultModel.downloadStatus == MFFileDownloaderDownloadStatusDownloadError) {
                if (weakSelf.model.pagConfig.onFileLoadFailureAction) {
                    weakSelf.model.pagConfig.onFileLoadFailureAction(resultModel.error);
                }
            }
        }];
        
        if (fileDownloadModel.status == -3) {
            if ([fileDownloadModel.data isKindOfClass:[MFFileDownloaderFileModel class]]) {
                if (self.model.pagConfig.onFileLoadSuccessAction) {
                    self.model.pagConfig.onFileLoadSuccessAction();
                }
                if ([fileDownloadModel.data isKindOfClass:[MFFileDownloaderFileModel class]]) {
                    MFFileDownloaderFileModel *modelL = fileDownloadModel.data;
                    [self configureViewStartPlayWith:modelL.fullLocalPath];
                }
                
            }
        } else if (fileDownloadModel.status < 0) {
            if (self.model.pagConfig.onFileLoadFailureAction) {
                self.model.pagConfig.onFileLoadFailureAction([NSError errorWithDomain:@"MFFileDownloaderPagError" code:fileDownloadModel.status userInfo:@{NSURLLocalizedLabelKey: fileDownloadModel.msg}]);
            }
        }
        
    });
}


- (void)configureViewStartPlayWith:(NSString *)localPath {
    if (!_pagFile && [self isStringNotNull:localPath]) {
        _pagFile = [PAGFile Load:localPath];
    }
    if (_pagFile) {
        [self.pagView setComposition:self.pagFile];
        [self.pagView play];
        self.model.imageWidth = self.pagFile.width;
        self.model.imageHeight = self.pagFile.height;
        self.model.during = self.pagFile.duration;
        if (self.mediaLoadFinishBlock) {
            self.mediaLoadFinishBlock(self.model);
        }
    }
}

- (void)resetSubviews {
    self.pagView.frame = self.bounds;
}

- (void)clear {
    [_pagView removeListener:self];
}

/**
 * Notifies the end of the animation.
 */
- (void)onAnimationEnd:(PAGView *)pagView {
    if (self.model.pagConfig.onAnimateStopAction) {
        self.model.pagConfig.onAnimateStopAction();
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
