//
// Created by Neal on 2022/8/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MFMediaViewModel;

@interface MFMediaViewAudioView : UIView

@property (nonatomic, strong) MFMediaViewModel *model;

@property (nonatomic) id customModel;

@property (nonatomic, copy) void(^mediaLoadFinishBlock)(MFMediaViewModel *model);

- (void)resetSubviews;

- (void)clear;

@end
