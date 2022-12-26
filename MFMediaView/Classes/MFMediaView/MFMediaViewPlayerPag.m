//
//  MFMediaViewPlayerPag.m
//  MFMediaView
//
//  Created by Administer on 2022/10/24.
//

#import "MFMediaViewPlayerPag.h"
#import <libpag/PAGView.h>
#import "MFMediaViewPAGView.h"

@interface MFMediaViewPlayerPagRepeatConfigPagLayerUnit ()

@property (nonatomic, strong) UIColor *textFillColor;
@property (nonatomic, copy) NSString *textFontFamily;
@property (nonatomic, copy) NSString *textFontStyle;
@property (nonatomic, strong) UIColor *textStrokeColor;
@property (nonatomic, copy) NSString *textString;
@property (nonatomic) int64_t imageContentDuration;
@property (nonatomic, strong) NSData *imageBytes;

@end

@implementation MFMediaViewPlayerPagRepeatConfigPagLayerUnit

+ (instancetype)processLayerWithLayer:(PAGLayer *)layer {
    MFMediaViewPlayerPagRepeatConfigPagLayerUnit *unit = [[MFMediaViewPlayerPagRepeatConfigPagLayerUnit alloc] init];
    
    if (layer.layerType == PAGLayerTypeUnknown) {
        unit.style = MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleUnknown;
    } else if (layer.layerType == PAGLayerTypeNull) {
        unit.style = MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleNull;
    } else if (layer.layerType == PAGLayerTypeSolid) {
        unit.style = MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleSolid;
    } else if (layer.layerType == PAGLayerTypeText) {
        unit.style = MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleText;
        PAGTextLayer *textLayer = (PAGTextLayer *)layer;
        unit.textFillColor = textLayer.fillColor;
        unit.textStrokeColor = textLayer.strokeColor;
        unit.textString = textLayer.text;
        unit.textFontFamily = textLayer.font.fontFamily;
        unit.textFontStyle = textLayer.font.fontStyle;
    } else if (layer.layerType == PAGLayerTypeShape) {
        unit.style = MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleShape;
    } else if (layer.layerType == PAGLayerTypeImage) {
        unit.style = MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleImage;
        PAGImageLayer *imageLayer = (PAGImageLayer *)layer;
        unit.imageContentDuration = imageLayer.contentDuration;
        unit.imageBytes = imageLayer.imageBytes;
    } else if (layer.layerType == PAGLayerTypePreCompose) {
        unit.style = MFMediaViewPlayerPagRepeatConfigPagLayerUnitStylePreCompose;
    }

    return unit;
}

- (instancetype _Nonnull)initWithLayer:(PAGLayer *_Nonnull)layer {
    self = [super init];
    if (self) {
        if ([layer isKindOfClass:[PAGLayer class]]) {
            if (layer.layerType == PAGLayerTypeUnknown) {
                self.style = MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleUnknown;
            } else if (layer.layerType == PAGLayerTypeNull) {
                self.style = MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleNull;
            } else if (layer.layerType == PAGLayerTypeSolid) {
                self.style = MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleSolid;
            } else if (layer.layerType == PAGLayerTypeText) {
                self.style = MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleText;
                PAGTextLayer *textLayer = (PAGTextLayer *)layer;
                self.textFillColor = textLayer.fillColor;
                self.textStrokeColor = textLayer.strokeColor;
                self.textString = textLayer.text;
                self.textFontFamily = textLayer.font.fontFamily;
                self.textFontStyle = textLayer.font.fontStyle;
            } else if (layer.layerType == PAGLayerTypeShape) {
                self.style = MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleShape;
            } else if (layer.layerType == PAGLayerTypeImage) {
                self.style = MFMediaViewPlayerPagRepeatConfigPagLayerUnitStyleImage;
                PAGImageLayer *imageLayer = (PAGImageLayer *)layer;
                self.imageContentDuration = imageLayer.contentDuration;
                self.imageBytes = imageLayer.imageBytes;
            } else if (layer.layerType == PAGLayerTypePreCompose) {
                self.style = MFMediaViewPlayerPagRepeatConfigPagLayerUnitStylePreCompose;
            }
        }
    }
    return self;
}

+ (BOOL)isStringNotNull:(NSString *)string {
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

@implementation MFMediaViewPlayerPagRepeatConfig

+ (instancetype)configWithRepeatCount:(NSUInteger)repeatCount repeatStyle:(NSInteger)repeatStyle repeatStartTime:(float)repeatStartTime repeatEndTime:(float)repeatEndTime {
    return [[self alloc] initWithRepeatCount:(NSUInteger)repeatCount repeatStyle:(NSInteger)repeatStyle repeatStartTime:(float)repeatStartTime repeatEndTime:(float)repeatEndTime];
}

- (instancetype)initWithRepeatCount:(NSUInteger)repeatCount repeatStyle:(NSInteger)repeatStyle repeatStartTime:(float)repeatStartTime repeatEndTime:(float)repeatEndTime {
    self = [super init];
    if (self) {
        self.repeatCount = repeatCount;
        self.repeatStyle = repeatStyle;
        self.repeatStartTime = repeatStartTime;
        self.repeatEndTime = repeatEndTime;
    }
    return self;
}

@end

@interface MFMediaViewPlayerPag ()

@property (nonatomic, assign) float aniamteDuring;

@property (nonatomic, weak) MFMediaViewPAGView *pagView;

@end

@implementation MFMediaViewPlayerPag

@synthesize replaceLayerList = _replaceLayerList;
@synthesize transformLayerList = _transformLayerList;
@synthesize layerUnitList = _layerUnitList;
@synthesize repeatConfig = _repeatConfig;

- (void)configurePagView:(MFMediaViewPAGView *)pagView {
    _pagView = pagView;
}

- (void)configurePagConfig:(MFMediaViewModelPAGConfig *)pagConfig {
    
    _pagConfig = pagConfig;
    _repeatConfig = [MFMediaViewPlayerPagRepeatConfig configWithRepeatCount:pagConfig.repeatCount repeatStyle:pagConfig.repeatStyle repeatStartTime:pagConfig.repeatStartTime repeatEndTime:pagConfig.repeatEndTime];
    
    _scaleMode = pagConfig.scaleMode;
    _isAutoPlay = pagConfig.isAutoPlay;
    _replaceLayerList = pagConfig.replaceLayerList;
    _transformLayerList = pagConfig.transformLayerList;
    _maxFrameRate = pagConfig.maxFrameRate;
    
}

- (void)setRepeatConfig:(MFMediaViewPlayerPagRepeatConfig *)repeatConfig {
    _repeatConfig = repeatConfig;
    [self.pagView updatePagWithRepeatCount:repeatConfig.repeatCount repeatStyle:repeatConfig.repeatStyle repeatStartTime:repeatConfig.repeatStartTime repeatEndTime:repeatConfig.repeatEndTime];
}

- (void)setScaleMode:(MFMediaViewModelPAGConfigStyleScaleMode)scaleMode {
    _scaleMode = scaleMode;
    [self.pagView updatePagWithScaleMode:scaleMode];
}

- (void)setMaxFrameRate:(NSUInteger)maxFrameRate {
    _maxFrameRate = maxFrameRate;
    [self.pagView updatePagWithMaxFrameRate:maxFrameRate];
}

- (void)setReplaceLayerList:(NSMutableArray<MFMediaViewModelPAGConfigReplaceLayerModel *> *)replaceLayerList {
    _replaceLayerList = replaceLayerList;
    [self.pagView updatePagWithReplaceLayerList:replaceLayerList];
}

- (void)setTransformLayerList:(NSMutableArray<MFMediaViewModelPAGConfigTransformLayerModel *> *)transformLayerList {
    _transformLayerList = transformLayerList;
    [self.pagView updatePagWithTransformLayerList:transformLayerList];
}

- (void)setLayerUnitList:(NSMutableArray<MFMediaViewPlayerPagRepeatConfigPagLayerUnit *> *)layerUnitList {
    _layerUnitList = layerUnitList;
}

- (void)seekToProgress:(CGFloat)progress {
    [self.pagView seekToProgress:progress];
}

- (NSMutableArray<MFMediaViewModelPAGConfigReplaceLayerModel *> *)replaceLayerList {
    if (!_replaceLayerList) {
        _replaceLayerList = [NSMutableArray array];
    }
    return _replaceLayerList;
}

- (NSMutableArray<MFMediaViewModelPAGConfigTransformLayerModel *> *)transformLayerList {
    if (!_transformLayerList) {
        _transformLayerList = [NSMutableArray array];
    }
    return _transformLayerList;
}

- (NSMutableArray<MFMediaViewPlayerPagRepeatConfigPagLayerUnit *> *)layerUnitList {
    if (!_layerUnitList) {
        _layerUnitList = [NSMutableArray array];
    }
    return _layerUnitList;
}

- (MFMediaViewPlayerPagRepeatConfig *)repeatConfig {
    if (!_repeatConfig) {
        _repeatConfig = [[MFMediaViewPlayerPagRepeatConfig alloc] init];
    }
    return _repeatConfig;
}

@end
