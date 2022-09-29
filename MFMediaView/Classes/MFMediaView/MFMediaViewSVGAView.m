//
// Created by Neal on 2022/8/8.
//

#import "MFMediaViewSVGAView.h"
#import "MFMediaViewModel.h"
#import <SVGAPlayer/SVGA.h>
#import <MFFileDownloader/MFFileDownloader.h>


@interface MFMediaViewSVGAView () <SVGAPlayerDelegate>

@property(nonatomic, strong) SVGAPlayer *svgaPlayer;
@property(nonatomic, strong) SVGAParser *svgaParser;

@end

@implementation MFMediaViewSVGAView {

}


- (void)configureDefaultView:(MFMediaViewModel *)model {
    if (!_svgaPlayer) {
        _svgaPlayer = [[SVGAPlayer alloc] initWithFrame:self.bounds];
        _svgaPlayer.contentMode = model.svgaConfig.contentMode;
        _svgaPlayer.loops = (int) model.svgaConfig.repeatCount;
        _svgaPlayer.clearsAfterStop = model.svgaConfig.clearsAfterStop;
        _svgaPlayer.delegate = self;
        [self addSubview:_svgaPlayer];
    }
    [self configureView:model];
}

- (void)setModel:(MFMediaViewModel *)model {
    _model = model;
//    if (!model) {
//        [self configureView:model];
//    } else {
    [self configureDefaultView:model];
//    }
}

- (void)configureView:(MFMediaViewModel *)model {
    
    MFFileDownloaderFileModel *fileModel = [[MFFileDownloaderFileModel alloc] init];
    fileModel.mediaType = 5;
    fileModel.url = model.url;
    fileModel.localPath = model.localPath;
    
    if ([self isStringNotNull:fileModel.localPath]) {
        [self configureViewStartPlayWith:fileModel.localPath];
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
    if (!_svgaParser) {
        _svgaParser = [[SVGAParser alloc] init];
    }
    NSURL *url;
    if ([self isStringNotNull:localPath]) {
        url = [NSURL fileURLWithPath:localPath];
    }
    if (!url) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.svgaParser parseWithURL:url
                  completionBlock:^(SVGAVideoEntity *videoItem) {
                      if (videoItem) {
                          weakSelf.svgaPlayer.videoItem = videoItem;
                          [weakSelf.svgaPlayer startAnimation];
                          weakSelf.model.imageWidth = videoItem.videoSize.width;
                          weakSelf.model.imageHeight = videoItem.videoSize.height;
                          weakSelf.model.during = @(videoItem.frames).floatValue / @(videoItem.FPS).floatValue;
                          if (weakSelf.mediaLoadFinishBlock) {
                              weakSelf.mediaLoadFinishBlock(self.model);
                          }
                          if (weakSelf.model.svgaConfig.onAnimationStartAction) {
                              weakSelf.model.svgaConfig.onAnimationStartAction();
                          }
                      }
                  }
                     failureBlock:^(NSError *error) {

                     }];
}

- (void)resetSubviews {
    self.svgaPlayer.frame = self.bounds;
}

- (void)clear {
    self.svgaPlayer.delegate = nil;
}

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    if (self.model.svgaConfig.onAnimationEndAction) {
        self.model.svgaConfig.onAnimationEndAction();
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
