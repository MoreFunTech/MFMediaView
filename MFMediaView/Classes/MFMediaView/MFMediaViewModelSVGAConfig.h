//
//  MFMediaViewModelSVGAConfig.h
//  MFMediaView
//
//  Created by Neal on 2022/8/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFMediaViewModelSVGAConfig : NSObject

/**
 * 文件拉伸方式 默认 UIViewContentModeScaleAspectFit
 */
@property (nonatomic, assign) UIViewContentMode contentMode;
/**
 * 动画重复次数 默认0， 无限循环
 */
@property (nonatomic, assign) NSUInteger repeatCount;
/**
 * 播放停止后清空文件 默认NO
 */
@property (nonatomic, assign) BOOL clearsAfterStop;

@property (nonatomic, copy) void(^svgaPlayerDidFinishedAnimation)(void);

+ (instancetype)defaultConfigure;

@end

NS_ASSUME_NONNULL_END
