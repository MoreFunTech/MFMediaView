//
//  MFTestAudioView.m
//  MFMediaView_Example
//
//  Created by Administer on 2022/10/21.
//  Copyright © 2022 NealWills. All rights reserved.
//

#import "MFTestAudioView.h"

#import <NIMSDK/NIMSDK.h>
#import <MFMediaView/MFMediaView.h>
#import <AVKit/AVKit.h>


@interface MFTestAudioViewAudioPlayerContentView : UIView <MFMediaViewModelAudioConfigPlayerContentViewDelegate>

@end

@implementation MFTestAudioViewAudioPlayerContentView

- (void)configureViewWithStatus:(MFMediaViewModelAudioStatus)status {
    NSLog(@"configureViewWithStatus %ld", status);
}

- (void)configureViewWithPlaying:(double)current during:(double)during {
    NSLog(@"configureViewWithPlaying current: %.01f | during: %.01f", current, during);
}

- (void)playButtonClickBlock:(void(^)(void))playActionBlock {
    
}

@end


@interface MFTestAudioViewAudioPlayerContent : NSObject <MFMediaViewModelAudioConfigPlayerContentDelegate>

@end

@implementation MFTestAudioViewAudioPlayerContent

- (Class<MFMediaViewModelAudioConfigPlayerContentViewDelegate>)playerViewClass {
    return [MFTestAudioViewAudioPlayerContentView class];
}

@end

@interface MFTestAudioViewAudioPlayer : NSObject <MFMediaViewModelAudioConfigPlayerDelegate, NIMMediaManagerDelegate>

@property (nonatomic, copy) NSString *localPath;
@property (nonatomic) BOOL autoPlay;
@property (nonatomic) MFMediaViewModelAudioStatus playerStatus;
@property (nonatomic, copy) void(^loadSuccessBlock)(double during);
@property (nonatomic, copy) void(^playingBlock)(double current, double during);
@property (nonatomic, copy) void(^statusChangeBlock)(MFMediaViewModelAudioStatus status);
@property (nonatomic) double during;

@end

@implementation MFTestAudioViewAudioPlayer

- (void)configureLocalPath:(NSString *)localPath {

    __weak typeof(self) weakSelf = self;
//    NSDictionary *params = @{AVURLAssetReferenceRestrictionsKey: @(YES)};
    AVURLAsset *assets = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:localPath]];
    [NSThread detachNewThreadWithBlock:^{
        CMTime audioDuring = assets.duration;
        weakSelf.during = CMTimeGetSeconds(audioDuring);
        if (weakSelf.loadSuccessBlock) {
            weakSelf.loadSuccessBlock(weakSelf.during);
        }
        if (weakSelf.statusChangeBlock) {
            weakSelf.statusChangeBlock(MFMediaViewModelAudioStatusReady);
        }
        weakSelf.playerStatus = MFMediaViewModelAudioStatusReady;
    }];
    
    [NIMSDK.sharedSDK.mediaManager addDelegate:self];
    self.localPath = localPath;
    if (self.autoPlay) {
        [self play];
    }
}

- (void)configureAutoPlay:(BOOL)autoPlay {
    self.autoPlay = autoPlay;
}

- (void)play {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NIMSDK.sharedSDK.mediaManager play:self.localPath];
    });
    self.playerStatus = MFMediaViewModelAudioStatusReady;
}

- (void)pause {
    [NIMSDK.sharedSDK.mediaManager stopPlay];
    self.playerStatus = MFMediaViewModelAudioStatusStop;
}

- (void)stop {
    [NIMSDK.sharedSDK.mediaManager stopPlay];
    self.playerStatus = MFMediaViewModelAudioStatusStop;
}

- (void)replay {
    [NIMSDK.sharedSDK.mediaManager stopPlay];
    [NIMSDK.sharedSDK.mediaManager play:self.localPath];
    self.playerStatus = MFMediaViewModelAudioStatusPlaying;
}

- (void)fileLoadSuccess:(void(^)(double during))loadSuccessBlock {
    self.loadSuccessBlock = loadSuccessBlock;
}

- (void)audioPlayingBlock:(void(^)(double current, double during))playingBlock {
    self.playingBlock = playingBlock;
}

- (void)audioPlayerStatusChange:(void(^)(MFMediaViewModelAudioStatus status))statusChangeBlock {
    self.statusChangeBlock = statusChangeBlock;
}

- (void)audioPlayerPlayAction{
    if (self.playerStatus == MFMediaViewModelAudioStatusPlaying) {
        [self pause];
    } else {
        [self play];
    }
}

- (void)dealloc {
    if (self) {
        [NIMSDK.sharedSDK.mediaManager removeDelegate:self];
    }
}


/**
 *  开始播放音频的回调
 *
 *  @param filePath 音频文件路径
 *  @param error    错误信息
 */
- (void)playAudio:(NSString *)filePath didBeganWithError:(nullable NSError *)error {
    if (![filePath isEqualToString:self.localPath] && self.playerStatus == MFMediaViewModelAudioStatusPlaying) {
        if (self.statusChangeBlock) {
            self.statusChangeBlock(MFMediaViewModelAudioStatusStop);
        }
        self.playerStatus = MFMediaViewModelAudioStatusStop;
        return;
    }
    if (error) {
        if (self.statusChangeBlock) {
            self.statusChangeBlock(MFMediaViewModelAudioStatusLoadFailure);
        }
        self.playerStatus = MFMediaViewModelAudioStatusLoadFailure;
        return;
    }
    if (self.statusChangeBlock) {
        self.statusChangeBlock(MFMediaViewModelAudioStatusPlaying);
    }
    self.playerStatus = MFMediaViewModelAudioStatusPlaying;
}

/**
 *  播放完音频的回调
 *
 *  @param filePath 音频文件路径
 *  @param error    错误信息
 */
- (void)playAudio:(NSString *)filePath didCompletedWithError:(nullable NSError *)error {
    if (![filePath isEqualToString:self.localPath] && self.playerStatus == MFMediaViewModelAudioStatusPlaying) {
        if (self.statusChangeBlock) {
            self.statusChangeBlock(MFMediaViewModelAudioStatusStop);
        }
        self.playerStatus = MFMediaViewModelAudioStatusStop;
        return;
    }
    if (self.statusChangeBlock) {
        self.statusChangeBlock(MFMediaViewModelAudioStatusStop);
    }
    self.playerStatus = MFMediaViewModelAudioStatusStop;
}

/**
 *  播放完音频的进度回调
 *
 *  @param filePath 音频文件路径
 *  @param value    播放进度 0.0 - 1.0
 */
- (void)playAudio:(NSString *)filePath progress:(float)value {
    if (![filePath isEqualToString:self.localPath] && self.playerStatus == MFMediaViewModelAudioStatusPlaying) {
        if (self.statusChangeBlock) {
            self.statusChangeBlock(MFMediaViewModelAudioStatusStop);
        }
        self.playerStatus = MFMediaViewModelAudioStatusStop;
        return;
    }
    NSLog(@"playAudio  %@ - %f", filePath, value);
    if (self.statusChangeBlock) {
        self.statusChangeBlock(MFMediaViewModelAudioStatusPlaying);
    }
    if (self.playingBlock) {
        self.playingBlock(self.during * value, self.during);
    }
    self.playerStatus = MFMediaViewModelAudioStatusPlaying;
}

/**
 *  停止播放音频的回调
 *
 *  @param filePath 音频文件路径
 *  @param error    错误信息
 */
- (void)stopPlayAudio:(NSString *)filePath didCompletedWithError:(nullable NSError *)error {
    if (![filePath isEqualToString:self.localPath] && self.playerStatus == MFMediaViewModelAudioStatusPlaying) {
        if (self.statusChangeBlock) {
            self.statusChangeBlock(MFMediaViewModelAudioStatusStop);
        }
        self.playerStatus = MFMediaViewModelAudioStatusStop;
        return;
    }
    if (self.statusChangeBlock) {
        self.statusChangeBlock(MFMediaViewModelAudioStatusStop);
    }
    self.playerStatus = MFMediaViewModelAudioStatusStop;
}

@end



@interface MFTestAudioView ()

@property (nonatomic, strong) MFMediaView *mediaView;
@property (nonatomic, strong) MFTestAudioViewAudioPlayer *audioPlayer;
@property (nonatomic, strong) MFTestAudioViewAudioPlayerContent *audioPlayerContent;

@end

@implementation MFTestAudioView

- (void)configureSubviews {
    
    self.audioPlayer = [[MFTestAudioViewAudioPlayer alloc] init];
    self.audioPlayerContent = [[MFTestAudioViewAudioPlayerContent alloc] init];
    
    self.mediaView = [[MFMediaView alloc] initWithFrame:self.bounds];
    [self addSubview:self.mediaView];
    
    NSString *netUrl = @"http://yubaqinu.yubaapp.com/5655fc8af1595716c398089269586f16.aac";
    MFMediaViewModel *mediaModel = [MFMediaViewModel modelWithStyle:(MFMediaViewModelStyleAudio) url:netUrl];
    mediaModel.audioConfig.playerDelegate = self.audioPlayer;
    mediaModel.audioConfig.playerViewDelegate = self.audioPlayerContent;
    
    mediaModel.audioConfig.onFileLoadingAction = ^(CGFloat progress) {
        NSLog(@"onFileLoadingAction %f", progress);
    };
    
    mediaModel.audioConfig.onFileLoadFailureAction = ^(NSError * _Nonnull error) {
        NSLog(@"onFileLoadFailureAction %@", error);
    };
    
    mediaModel.audioConfig.onFileLoadSuccessAction = ^{
        NSLog(@"onFileLoadSuccessAction");
    };
    
    mediaModel.audioConfig.onAudioEndAction = ^{
        NSLog(@"onAudioEndAction");
    };
    
    mediaModel.audioConfig.onAudioStartAction = ^{
        NSLog(@"onAudioStartAction");
    };
    
    mediaModel.audioConfig.isAutoPlay = YES;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mediaView.model = mediaModel;
    });
    
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSubviews];
    }
    return self;
}

@end
