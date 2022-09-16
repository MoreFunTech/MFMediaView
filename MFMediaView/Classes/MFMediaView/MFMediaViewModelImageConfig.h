//
//  MFMediaViewModelImageConfig.h
//  MFMediaView
//
//  Created by Administer on 2022/9/16.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface MFMediaViewModelImageConfig : NSObject

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
 * 设置网络图片方案 (默认SD)
 */
@property (nonatomic, copy) void(^setNetImageBlock)(NSString *netImageUrl, UIImageView *imageView);

+ (instancetype)defaultConfigure;

@end

NS_ASSUME_NONNULL_END
