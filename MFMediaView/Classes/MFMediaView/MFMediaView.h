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

/**
 * 操控器
 */
@property (nonatomic, strong) MFMediaViewPlayer *player;

@property (nonatomic, copy) void(^mediaLoadFinishBlock)(MFMediaViewModel *model);

@property (nonatomic) id customModel;

@property (nonatomic, weak) id<MFMediaViewFileTypeJudgerProtocol>mediaTypeEncoderDelegate;

- (void)startPlayAnimate;

- (void)restartPlayAnimate;

- (void)stopPlayAnimate;

- (void)destroyView;

@end
