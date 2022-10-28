//
//  MFMediaViewModelAudioConfig.h
//  MFMediaView
//
//  Created by Administer on 2022/10/21.
//

#import <Foundation/Foundation.h>

@class MFMediaViewModel;

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, MFMediaViewModelAudioStatus) {
    /**
     * 音频加载完毕
     */
    MFMediaViewModelAudioStatusReady = 0,
    /**
     * 音频播放中
     */
    MFMediaViewModelAudioStatusPlaying = 1,
    /**
     * 音频暂停中
     */
    MFMediaViewModelAudioStatusPause = 2,
    /**
     * 音频播放完毕
     */
    MFMediaViewModelAudioStatusStop = 3,
    /**
     * 音频文件加载中
     */
    MFMediaViewModelAudioStatusLoading = 900,
    /**
     * 音频文件失败
     */
    MFMediaViewModelAudioStatusLoadFailure = 901,
};

@protocol MFMediaViewModelAudioConfigPlayerContentViewDelegate <NSObject>

- (void)configureViewWithStatus:(MFMediaViewModelAudioStatus)status;
- (void)configureViewWithPlaying:(double)current during:(double)during;
- (void)playButtonClickBlock:(void(^)(void))playActionBlock;

@optional
- (void)configureViewWithCustomModel:(id)customModel;

@optional
- (void)configureReadyToPlay:(double)during;

@end

@protocol MFMediaViewModelAudioConfigPlayerContentDelegate <NSObject>

- (Class<MFMediaViewModelAudioConfigPlayerContentViewDelegate>)playerViewClass;

@end

@protocol MFMediaViewModelAudioConfigPlayerDelegate <NSObject>

- (void)configureLocalPath:(NSString *)localPath;

@optional
- (void)configureLocalPath:(NSString *)localPath voiceEffect:(NSInteger)voiceEffect;

- (void)configureAutoPlay:(BOOL)autoPlay;

- (void)play;
- (void)pause;
- (void)stop;
- (void)replay;

- (void)fileLoadSuccess:(void(^)(double during))loadSuccessBlock;

- (void)audioPlayingBlock:(void(^)(double current, double during))playingBlock;

- (void)audioPlayerStatusChange:(void(^)(MFMediaViewModelAudioStatus status))statusChangeBlock;

- (void)audioPlayerPlayAction;

@end

@interface MFMediaViewModelAudioConfig : NSObject

@property (nonatomic, weak) id <MFMediaViewModelAudioConfigPlayerDelegate> playerDelegate;
@property (nonatomic, weak) id <MFMediaViewModelAudioConfigPlayerContentDelegate> playerViewDelegate;

@property (nonatomic, assign) BOOL isAutoPlay;

@property (nonatomic, copy) void(^onAudioStartAction)(void);
@property (nonatomic, copy) void(^onAudioEndAction)(void);
@property (nonatomic) NSInteger voiceEffect;

@property (nonatomic, copy) void(^onFileLoadingAction)(CGFloat progress);
@property (nonatomic, copy) void(^onFileLoadSuccessAction)(void);
@property (nonatomic, copy) void(^onFileLoadFailureAction)(NSError *error);

+ (instancetype)defaultConfigure;

@end

NS_ASSUME_NONNULL_END
