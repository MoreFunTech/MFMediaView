//
// Created by Neal on 2022/8/8.
//

#import <Foundation/Foundation.h>


@class PAGFile;

typedef NS_ENUM(NSInteger, MFMediaViewModelPAGConfigStyleScaleMode) {
    /**
     * 无缩放
     */
    MFMediaViewModelPAGConfigStyleScaleModeNone = 0,
    /**
     * 压缩或拉伸以填满，会改变原始文件的比例
     */
    MFMediaViewModelPAGConfigStyleScaleModeFill = 1,
    /**
     * 按比例进行压缩或拉伸，使最长边填满容器最短边,容器内会留下部分空白
     */
    MFMediaViewModelPAGConfigStyleScaleModeAspectToFit = 2,
    /**
     * 按比例进行压缩或拉伸，使最短边填满容器最长边，会切割部分原始文件
     */
    MFMediaViewModelPAGConfigStyleScaleModeAspectToFill = 3,

};

@interface MFMediaViewModelPAGConfig : NSObject

/**
 * Pag循环的次数， 0无限循环， 默认0
 */
@property (nonatomic, assign) NSUInteger repeatCount;

/**
 * 循环模式 0 默认循环（常规循环）  -2 首次播放完后之后片段循环 衔接下面的属性, -3 区间循环模式（相对于-2不会执行第一遍的动画）， -4 卡帧模式（只显示固定帧）
 */
@property (nonatomic, assign) NSInteger repeatStyle;

/**
 * 片段循环区间 开始时间 循环次数 -2 时生效 设置 0 从头开始
 */
@property (nonatomic, assign) float repeatStartTime;

/**
 * 片段循环区间 结束时间 循环次数 -2 时生效 设置0 到尾结束
 */
@property (nonatomic, assign) float repeatEndTime;

/**
 * pag文件动画时长 动画加载完自动获取 请不要调用set方法 和下面的configure方法
 */
@property (nonatomic, readonly) float aniamteDuring;

/**
 * 开始进度
 */
@property (nonatomic) CGFloat startProgress;

/**
 * pag加载完毕后自动调用这个，请勿使用
 * file PAGFile
 */
- (void)configModelWithFile:(PAGFile *)file;

/**
 * 文件的展示方式 默认 MFMediaViewModelPAGConfigStyleScaleModeAspectToFit ，比例压缩
 */
@property (nonatomic, assign) MFMediaViewModelPAGConfigStyleScaleMode scaleMode;

/**
 * 自动播放
 */
@property (nonatomic) BOOL isAutoPlay;

/**
 * 最大渲染的帧率，默认60帧
 * 若该帧数低于文件帧数，会丢失部分画面，
 * 若该帧数高于文件帧数，无影响
 */
@property (nonatomic, assign) NSUInteger maxFrameRate;

@property (nonatomic, copy) void(^onAnimationStartAction)(void);
@property (nonatomic, copy) void(^onAnimationEndAction)(void);

@property (nonatomic, copy) void(^onFileLoadingAction)(CGFloat progress);
@property (nonatomic, copy) void(^onFileLoadSuccessAction)(void);
@property (nonatomic, copy) void(^onFileLoadFailureAction)(NSError *error);

+ (instancetype)defaultConfigure;

- (NSString *)description;

@end
