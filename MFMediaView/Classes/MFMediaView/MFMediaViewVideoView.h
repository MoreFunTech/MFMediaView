//
// Created by Neal on 2022/8/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MFMediaViewModel;

@interface MFMediaViewVideoView : UIView

@property (nonatomic, strong) MFMediaViewModel *model;

- (void)clear;

@end