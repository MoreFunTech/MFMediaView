//
//  MFMediaView.h
//  MFMediaView
//
//  Created by Administer on 2022/8/8.
//

#import <Foundation/Foundation.h>

#import "MFMediaViewHeader.h"

@interface MFMediaView : UIView

/**
 * 通用媒体模型
 */
@property (nonatomic, strong) MFMediaViewModel *model;

@property (nonatomic, copy) void(^mediaLoadFinishBlock)(MFMediaViewModel *model);

@property (nonatomic, weak) id<MFMediaViewFileTypeJudgerProtocol>mediaTypeEncoderDelegate;

- (void)startPlayAnimate;

- (void)stopPlayAnimate;

- (void)destroyView;

@end
