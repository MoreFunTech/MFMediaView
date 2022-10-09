//
//  MFMediaViewModelGifConfig.h
//  MFMediaView
//
//  Created by Administer on 2022/10/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFMediaViewModelGifConfig : NSObject

/**
 * 展示方式
 */
@property (nonatomic) UIViewContentMode contentMode;

/**
 * 占位图片
 */
@property (nonatomic, strong, nullable) UIImage *placeHolderImage;

/**
 * 图片
 */
@property (nonatomic, strong, nullable) UIImage *localImage;

/**
 * 图片渲染颜色
 */
@property (nonatomic, strong, nullable) UIColor *tintColor;

/**
 * 图片渲染方式
 */
@property (nonatomic) UIImageRenderingMode renderMode;

/**
 * 动画重复次数 默认0， 无限循环
 */
@property (nonatomic, assign) NSUInteger repeatCount;


/**
 * 设置网络图片方案 (默认SD)
 */
@property (nonatomic, copy) void(^setNetImageBlock)(NSString *netImageUrl, UIImageView *imageView);

+ (instancetype)defaultConfigure;

@property (nonatomic, copy) void(^onAnimationStartAction)(void);
@property (nonatomic, copy) void(^onAnimationEndAction)(void);

@property (nonatomic, copy) void(^onFileLoadingAction)(CGFloat progress);
@property (nonatomic, copy) void(^onFileLoadSuccessAction)(void);
@property (nonatomic, copy) void(^onFileLoadFailureAction)(NSError *error);

@end

NS_ASSUME_NONNULL_END
