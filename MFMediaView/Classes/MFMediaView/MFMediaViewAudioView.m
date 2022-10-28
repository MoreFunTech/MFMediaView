//
// Created by Neal on 2022/8/8.
//

#import "MFMediaViewAudioView.h"

#import <MFFileDownloader/MFFileDownloader.h>
#import "MFMediaViewModel.h"

@interface MFMediaViewAudioView ()

@property (nonatomic, strong) __kindof UIView <MFMediaViewModelAudioConfigPlayerContentViewDelegate> *audioPlayer;

@end

@implementation MFMediaViewAudioView {

}


- (void)startPlayAnimate {
    [self impDelegatePlay];
}

- (void)stopPlayAnimate {
    [self impDelegateStop];
}

- (void)configureDefaultView:(MFMediaViewModel *)model {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.audioPlayer) {
            self.audioPlayer = [self impDelegatePlayerView];
            if (self.audioPlayer) {
                self.audioPlayer.frame = self.bounds;
                [self impDelegateConfigureAutoPlay:NO];
                self.audioPlayer.frame = self.bounds;
                [self addSubview:self.audioPlayer];
            }
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
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self impDelegatePlayButtonClickBlock:^{
            [weakSelf impDelegateAudioPlayerPlayAction];
        }];
        
        [self impDelegateFileLoadSuccess:^(double during) {
            [weakSelf playerFileLoadSuccess:during];
            [weakSelf impDelegateConfigureReadyToPlay:during];
        }];
        
        [self impDelegateAudioPlayingBlock:^(double current, double during) {
            [weakSelf playerAudioPlaying:current during:during];
        }];
        
        [self impDelegateAudioPlayerStatusChange:^(MFMediaViewModelAudioStatus status) {
            [weakSelf playeraStatusChange:status];
        }];
        
        [self impDelegateConfigureViewWithCustomModel:self.customModel];
        
    });
    
    
}

- (void)configureView:(MFMediaViewModel *)model {
    
    [self impDelegateConfigureViewWithStatus:(MFMediaViewModelAudioStatusLoading)];
    
    MFFileDownloaderFileModel *fileModel = [[MFFileDownloaderFileModel alloc] init];
    fileModel.mediaType = 4;
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
                if (weakSelf.model.audioConfig.onFileLoadingAction) {
                    double completeCount = 0;
                    double totalCount = 1;
                    completeCount = @(resultModel.progress.completedUnitCount).doubleValue;
                    totalCount = @(resultModel.progress.totalUnitCount).doubleValue;
                    if (totalCount < 1) {
                        totalCount = 1;
                    }
                    weakSelf.model.audioConfig.onFileLoadingAction(completeCount / totalCount);
                }
            } else if (resultModel.downloadStatus == MFFileDownloaderDownloadStatusDownloadFinish) {
                if (weakSelf.model.audioConfig.onFileLoadSuccessAction) {
                    weakSelf.model.audioConfig.onFileLoadSuccessAction();
                }
                [weakSelf configureViewStartPlayWith:resultModel.fileModel.fullLocalPath];
            } else if (resultModel.downloadStatus == MFFileDownloaderDownloadStatusDownloadError) {
                [self impDelegateConfigureViewWithStatus:MFMediaViewModelAudioStatusLoadFailure];
                if (weakSelf.model.audioConfig.onFileLoadFailureAction) {
                    weakSelf.model.audioConfig.onFileLoadFailureAction(resultModel.error);
                }
            } else {
                if (weakSelf.model.audioConfig.onFileLoadFailureAction) {
                    weakSelf.model.audioConfig.onFileLoadFailureAction(resultModel.error);
                }
            }
        }];
        
    });
}


- (void)configureViewStartPlayWith:(NSString *)localPath {
        
    if (![self isStringNotNull:localPath]) {
        [self impDelegateConfigureViewWithStatus:MFMediaViewModelAudioStatusLoadFailure];
        return;
    }
    
    [self impDelegateConfigureViewWithStatus:(MFMediaViewModelAudioStatusReady)];
    if (self.model.audioConfig.voiceEffect > -1) {
        [self impDelegateConfigureLocalPath:localPath voiceEffect:self.model.audioConfig.voiceEffect];
    } else {
        [self impDelegateConfigureLocalPath:localPath];
    }
    
    if (self.model.audioConfig.isAutoPlay) {
        [self impDelegatePlay];
    }
    if (self.mediaLoadFinishBlock) {
        self.mediaLoadFinishBlock(self.model);
    }
    
}

- (void)playerFileLoadSuccess:(double)during {
    [self impDelegateConfigureViewWithStatus:MFMediaViewModelAudioStatusReady];
}

- (void)playerAudioPlaying:(double)current during:(double)during {
    [self impDelegateConfigureViewWithPlaying:current during:during];
}

- (void)playeraStatusChange:(MFMediaViewModelAudioStatus)status {
    [self impDelegateConfigureViewWithStatus:status];
    if (status == MFMediaViewModelAudioStatusStop) {
        if (self.model.audioConfig.onAudioEndAction) {
            self.model.audioConfig.onAudioEndAction();
        }
    }
    if (status == MFMediaViewModelAudioStatusPlaying) {
        if (self.model.audioConfig.onAudioStartAction) {
            self.model.audioConfig.onAudioStartAction();
        }
    }
    
}

- (void)resetSubviews {
    if (_audioPlayer) {
        _audioPlayer.frame = self.bounds;
    }
}

- (void)clear {
    [self impDelegateStop];
    [self.audioPlayer removeFromSuperview];
    self.audioPlayer = nil;
}

- (void)setCustomModel:(id)customModel {
    _customModel = customModel;
    [self impDelegateConfigureViewWithCustomModel:customModel];
}

#pragma mark - 触发代理

- (void)impDelegateConfigureViewWithStatus:(MFMediaViewModelAudioStatus)status {
    if (!_audioPlayer) {
        return;
    }
    [_audioPlayer configureViewWithStatus:status];
}

- (void)impDelegateConfigureViewWithPlaying:(double)current during:(double)during {
    if (!_audioPlayer) {
        return;
    }
    [_audioPlayer configureViewWithPlaying:current during:during];
}

- (void)impDelegatePlayButtonClickBlock:(void(^)(void))playActionBlock {
    if (!_audioPlayer) {
        return;
    }
    [_audioPlayer playButtonClickBlock:playActionBlock];
}

- (void)impDelegateConfigureViewWithCustomModel:(id)customModel {
    if (!_audioPlayer) {
        return;
    }
    if (![_audioPlayer respondsToSelector:@selector(configureViewWithCustomModel:)]) {
        return;
    }
    [_audioPlayer configureViewWithCustomModel:customModel];
}

- (void)impDelegateConfigureReadyToPlay:(double)during {
    if (!_audioPlayer) {
        return;
    }
    if (![_audioPlayer respondsToSelector:@selector(configureReadyToPlay:)]) {
        return;
    }
    [_audioPlayer configureReadyToPlay:during];
}

- (UIView <MFMediaViewModelAudioConfigPlayerContentViewDelegate> * _Nullable)impDelegatePlayerView {
    if (!self.model.audioConfig.playerViewDelegate) {
        return nil;
    }
    if (![self.model.audioConfig.playerViewDelegate respondsToSelector:@selector(playerViewClass)]) {
        return nil;
    }
    Class class = [self.model.audioConfig.playerViewDelegate playerViewClass];
    return [[class alloc] init];;
}

- (void)impDelegateConfigureLocalPath:(NSString *)localPath {
    if (!self.model.audioConfig.playerDelegate) {
        return;
    }
    if (![self.model.audioConfig.playerDelegate respondsToSelector:@selector(configureLocalPath:)]) {
        return;
    }
    [self.model.audioConfig.playerDelegate configureLocalPath:localPath];
}

- (void)impDelegateConfigureLocalPath:(NSString *)localPath voiceEffect:(int)voiceEffect {
    if (!self.model.audioConfig.playerDelegate) {
        return;
    }
    if (![self.model.audioConfig.playerDelegate respondsToSelector:@selector(configureLocalPath:voiceEffect:)]) {
        return;
    }
    [self.model.audioConfig.playerDelegate configureLocalPath:localPath voiceEffect:voiceEffect];
}

- (void)impDelegateConfigureAutoPlay:(BOOL)autoPlay {
    if (!self.model.audioConfig.playerDelegate) {
        return;
    }
    if (![self.model.audioConfig.playerDelegate respondsToSelector:@selector(configureAutoPlay:)]) {
        return;
    }
    [self.model.audioConfig.playerDelegate configureAutoPlay:autoPlay];
}

- (void)impDelegatePlay {
    if (!self.model.audioConfig.playerDelegate) {
        return;
    }
    if (![self.model.audioConfig.playerDelegate respondsToSelector:@selector(play)]) {
        return;
    }
    [self.model.audioConfig.playerDelegate play];
}

- (void)impDelegatePause {
    if (!self.model.audioConfig.playerDelegate) {
        return;
    }
    if (![self.model.audioConfig.playerDelegate respondsToSelector:@selector(pause)]) {
        return;
    }
    [self.model.audioConfig.playerDelegate pause];
}

- (void)impDelegateStop {
    if (!self.model.audioConfig.playerDelegate) {
        return;
    }
    if (![self.model.audioConfig.playerDelegate respondsToSelector:@selector(stop)]) {
        return;
    }
    [self.model.audioConfig.playerDelegate stop];
}

- (void)impDelegateReplay {
    if (!self.model.audioConfig.playerDelegate) {
        return;
    }
    if (![self.model.audioConfig.playerDelegate respondsToSelector:@selector(replay)]) {
        return;
    }
    [self.model.audioConfig.playerDelegate replay];
}

- (void)impDelegateFileLoadSuccess:(void(^)(double during))loadSuccessBlock {
    if (!self.model.audioConfig.playerDelegate) {
        return;
    }
    if (![self.model.audioConfig.playerDelegate respondsToSelector:@selector(fileLoadSuccess:)]) {
        return;
    }
    [self.model.audioConfig.playerDelegate fileLoadSuccess:loadSuccessBlock];
}

- (void)impDelegateAudioPlayingBlock:(void(^)(double current, double during))audioPlayingBlock {
    if (!self.model.audioConfig.playerDelegate) {
        return;
    }
    if (![self.model.audioConfig.playerDelegate respondsToSelector:@selector(audioPlayingBlock:)]) {
        return;
    }
    [self.model.audioConfig.playerDelegate audioPlayingBlock:audioPlayingBlock];
}


- (void)impDelegateAudioPlayerStatusChange:(void(^)(MFMediaViewModelAudioStatus status))statusChangeBlock {
    if (!self.model.audioConfig.playerDelegate) {
        return;
    }
    if (![self.model.audioConfig.playerDelegate respondsToSelector:@selector(audioPlayerStatusChange:)]) {
        return;
    }
    [self.model.audioConfig.playerDelegate audioPlayerStatusChange:statusChangeBlock];
}

- (void)impDelegateAudioPlayerPlayAction; {
    if (!self.model.audioConfig.playerDelegate) {
        return;
    }
    if (![self.model.audioConfig.playerDelegate respondsToSelector:@selector(audioPlayerPlayAction)]) {
        return;
    }
    [self.model.audioConfig.playerDelegate audioPlayerPlayAction];
}

#pragma mark - Init


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
