//
//  MFMediaViewPlayerPag.m
//  MFMediaView
//
//  Created by Administer on 2022/10/24.
//

#import "MFMediaViewPlayerPag.h"
#import <libpag/PAGView.h>
#import "MFMediaViewPAGView.h"

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

- (MFMediaViewPlayerPagRepeatConfig *)repeatConfig {
    if (!_repeatConfig) {
        _repeatConfig = [[MFMediaViewPlayerPagRepeatConfig alloc] init];
    }
    return _repeatConfig;
}

@end
