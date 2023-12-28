//
// Created by Neal on 2022/8/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MFMediaViewModel;
@class MFMediaViewPlayerPag;
@class PAGFile;
@class PAGComposition;

@interface MFMediaViewPAGView : UIView

@property (nonatomic, strong) MFMediaViewModel *model;

@property (nonatomic) id customModel;

@property (nonatomic, copy) void(^mediaLoadFinishBlock)(MFMediaViewModel *model);
@property (nonatomic, copy) void(^pagFileDidLoadSuccess)(PAGFile *file);
@property (nonatomic, copy) void(^pagCompositionDidLoadSuccess)(PAGComposition *file);

- (void)updatePagWithRepeatCount:(NSUInteger)repeatCount repeatStyle:(NSInteger)repeatStyle repeatStartTime:(float)repeatStartTime repeatEndTime:(float)repeatEndTime;
- (void)updatePagWithScaleMode:(NSInteger)scaleMode;
- (void)updatePagWithMaxFrameRate:(NSUInteger)maxFrameRate;

- (void)seekToProgress:(CGFloat)progress;

- (void)startPlayAnimate;

- (void)restartPlayAnimate;

- (void)stopPlayAnimate;

- (void)resetSubviews;

- (void)clear;

@end
