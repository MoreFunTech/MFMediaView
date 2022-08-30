//
// Created by Neal on 2022/8/8.
//

#import <Foundation/Foundation.h>

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
 * 文件的展示方式 默认 MFMediaViewModelPAGConfigStyleScaleModeAspectToFit ，比例压缩
 */
@property (nonatomic, assign) MFMediaViewModelPAGConfigStyleScaleMode scaleMode;
/**
 * 最大渲染的帧率，默认60帧
 * 若该帧数低于文件帧数，会丢失部分画面，
 * 若该帧数高于文件帧数，无影响
 */
@property (nonatomic, assign) NSUInteger maxFrameRate;

@property (nonatomic, copy) void(^onAnimateStopAction)(void);

+ (instancetype)defaultConfigure;

- (NSString *)description;

@end
