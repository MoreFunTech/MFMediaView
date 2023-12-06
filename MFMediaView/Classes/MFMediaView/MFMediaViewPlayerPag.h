//
//  MFMediaViewPlayerPag.h
//  MFMediaView
//
//  Created by Administer on 2022/10/24.
//

#import <Foundation/Foundation.h>
#import "MFMediaViewModelPAGConfig.h"
#import <libpag/PAGTextLayer.h>
#import <libpag/PAGImageLayer.h>

@class MFMediaViewPAGView;
@class PAGLayer;

typedef NS_ENUM(NSInteger, MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyle) {
    MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleUnknown = 0,
    MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleNull = 1,
    MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleSolid = 2,
    MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleText = 3,
    MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleShape = 4,
    MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleImage = 5,
    MFMediaViewPlayerPagRepeatConfigPagLayerUnitStylePreCompose = 6,
};

@interface MFMediaViewPlayerPagRepeatConfigPagLayerUnit: NSObject

@property (nonatomic) MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyle style;

- (UIColor * _Nonnull)textFillColor;

- (NSString * _Nonnull)textFontFamily;

- (NSString * _Nonnull)textFontStyle;

- (UIColor * _Nonnull)textStrokeColor;

- (NSString * _Nonnull)textString;

- (int64_t)imageContentDuration;


- (instancetype _Nonnull)initWithLayer:(PAGLayer *_Nonnull)layer;
+ (instancetype _Nonnull)processLayerWithLayer:(PAGLayer *_Nonnull)layer;

@end


@interface MFMediaViewPlayerPagRepeatConfig : NSObject

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

+ (instancetype _Nonnull )configWithRepeatCount:(NSUInteger)repeatCount
                                    repeatStyle:(NSInteger)repeatStyle
                                repeatStartTime:(float)repeatStartTime
                                  repeatEndTime:(float)repeatEndTime;

@end

@interface MFMediaViewPlayerPag : NSObject

@property (nonatomic, strong) MFMediaViewPlayerPagRepeatConfig * _Nullable repeatConfig;

/**
 * 文件的展示方式 默认 MFMediaViewModelPAGConfigStyleScaleModeAspectToFit ，比例压缩
 */
@property (nonatomic, assign) MFMediaViewModelPAGConfigStyleScaleMode scaleMode;

/**
 * 自动播放
 */
@property (nonatomic) BOOL isAutoPlay;

@property (nonatomic, weak) NSMutableArray <MFMediaViewModelPAGConfigReplaceLayerModel *>* _Nullable replaceLayerList;

@property (nonatomic, weak) NSMutableArray <MFMediaViewModelPAGConfigTransformLayerModel *>* _Nullable transformLayerList;

@property (nonatomic, strong) NSMutableArray <MFMediaViewPlayerPagRepeatConfigPagLayerUnit *> *_Nullable layerUnitList;

/**
 * 最大渲染的帧率，默认60帧
 * 若该帧数低于文件帧数，会丢失部分画面，
 * 若该帧数高于文件帧数，无影响
 */
@property (nonatomic, assign) NSUInteger maxFrameRate;

@property (nonatomic, readonly, weak) MFMediaViewPAGView * _Nullable pagView;

@property (nonatomic, readonly, weak) MFMediaViewModelPAGConfig * _Nullable pagConfig;

- (void)configurePagView:(MFMediaViewPAGView * _Nullable)pagView;

- (void)configurePagConfig:(MFMediaViewModelPAGConfig * _Nullable)pagConfig;

- (void)seekToProgress:(CGFloat)progress;

@end
