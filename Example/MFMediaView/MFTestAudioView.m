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
}

- (void)pause {
    [NIMSDK.sharedSDK.mediaManager stopPlay];
}

- (void)stop {
    [NIMSDK.sharedSDK.mediaManager stopPlay];
}

- (void)replay {
    [NIMSDK.sharedSDK.mediaManager stopPlay];
    [NIMSDK.sharedSDK.mediaManager play:self.localPath];
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
    if (error) {
        if (self.statusChangeBlock) {
            self.statusChangeBlock(MFMediaViewModelAudioStatusLoadFailure);
        }
        return;
    }
    if (self.statusChangeBlock) {
        self.statusChangeBlock(MFMediaViewModelAudioStatusPlaying);
    }
}

/**
 *  播放完音频的回调
 *
 *  @param filePath 音频文件路径
 *  @param error    错误信息
 */
- (void)playAudio:(NSString *)filePath didCompletedWithError:(nullable NSError *)error {
    if (self.statusChangeBlock) {
        self.statusChangeBlock(MFMediaViewModelAudioStatusStop);
    }
}

/**
 *  播放完音频的进度回调
 *
 *  @param filePath 音频文件路径
 *  @param value    播放进度 0.0 - 1.0
 */
- (void)playAudio:(NSString *)filePath progress:(float)value {
    
    NSLog(@"playAudio  %@ - %f", filePath, value);
    if (self.statusChangeBlock) {
        self.statusChangeBlock(MFMediaViewModelAudioStatusPlaying);
    }
    if (self.playingBlock) {
        self.playingBlock(self.during * value, self.during);
    }
}

/**
 *  停止播放音频的回调
 *
 *  @param filePath 音频文件路径
 *  @param error    错误信息
 */
- (void)stopPlayAudio:(NSString *)filePath didCompletedWithError:(nullable NSError *)error {
    if (self.statusChangeBlock) {
        self.statusChangeBlock(MFMediaViewModelAudioStatusStop);
    }
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
