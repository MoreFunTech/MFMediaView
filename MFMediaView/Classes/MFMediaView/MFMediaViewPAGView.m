//
// Created by Neal on 2022/8/8.
//

#import "MFMediaViewPAGView.h"
#import "MFMediaViewModel.h"
#include <libpag/PAGView.h>

@interface MFMediaViewPAGView () <PAGViewListener>

/**
 * pag文件加载视图
 */
@property(nonatomic, strong) PAGView *pagView;

/**
 * pag文件资源文件
 */
@property(nonatomic, strong) PAGFile *pagFile;

@end

@implementation MFMediaViewPAGView {

}

- (void)configureDefaultView:(MFMediaViewModel *)model {
    if (!_pagView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _pagView = [[PAGView alloc] initWithFrame:self.bounds];
            _pagView.maxFrameRate = model.pagConfig.maxFrameRate;
            [_pagView addListener:self];
            [_pagView setRepeatCount:(int) model.pagConfig.repeatCount];
            switch (model.pagConfig.scaleMode) {
                case MFMediaViewModelPAGConfigStyleScaleModeNone:
                    _pagView.scaleMode = PAGScaleModeNone;
                    break;
                case MFMediaViewModelPAGConfigStyleScaleModeFill:
                    _pagView.scaleMode = PAGScaleModeStretch;
                    break;
                case MFMediaViewModelPAGConfigStyleScaleModeAspectToFit:
                    _pagView.scaleMode = PAGScaleModeLetterBox;
                    break;
                case MFMediaViewModelPAGConfigStyleScaleModeAspectToFill:
                    _pagView.scaleMode = PAGScaleModeZoom;
                    break;
            }
            [self addSubview:_pagView];
        });
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
}

- (void)configureView:(MFMediaViewModel *)model {
    if (!_pagFile && [self isStringNotNull:model.localPath]) {
        _pagFile = [PAGFile Load:model.localPath];
    }
    if (_pagFile) {
        [self.pagView setComposition:self.pagFile];
        [self.pagView play];
        model.imageWidth = self.pagFile.width;
        model.imageHeight = self.pagFile.height;
        model.during = self.pagFile.duration;
        if (self.mediaLoadFinishBlock) {
            self.mediaLoadFinishBlock(model);
        }
    }
}

- (void)clear {
    [_pagView removeListener:self];
}

/**
 * Notifies the end of the animation.
 */
- (void)onAnimationEnd:(PAGView *)pagView {
    if (self.model.pagConfig.onAnimateStopAction) {
        self.model.pagConfig.onAnimateStopAction();
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
