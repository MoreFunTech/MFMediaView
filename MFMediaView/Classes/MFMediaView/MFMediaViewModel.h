//
// Created by Neal on 2022/8/8.
//

#import <Foundation/Foundation.h>


#import "MFMediaViewModelPAGConfig.h"
#import "MFMediaViewModelSVGAConfig.h"
#import "MFMediaViewModelImageConfig.h"

typedef NS_ENUM(NSInteger, MFMediaViewModelStyle) {
    /**
     * 空类型
     */
    MFMediaViewModelStyleNone = 0,
    /**
     * 图片类型
     */
    MFMediaViewModelStyleImage = 1,
    /**
     * 视屏类型
     */
    MFMediaViewModelStyleVideo = 2,
    /**
     * 动图类型
     */
    MFMediaViewModelStyleGif = 3,
    /**
     * 语音类型
     */
    MFMediaViewModelStyleAudio = 4,
    /**
     * SVGA动图类型
     */
    MFMediaViewModelStyleSvga = 5,
    /**
     * PAG动图类型
     */
    MFMediaViewModelStylePag = 6,
};

@interface MFMediaViewModel : NSObject

/**
 * 媒体类型
 * 1 图片
 * 2
 */
@property(nonatomic, assign) MFMediaViewModelStyle style;

/**
 * 本地文件地址
 */
@property(nonatomic, copy) NSString *localPath;

/**
 * 网络文件地址
 */
@property(nonatomic, copy) NSString *url;

/**
 * 网络文件地址 主要用于video类型时的视频文件地址
 */
@property(nonatomic, copy) NSString *furUrl;

/**
 * 图片宽度
 */
@property(nonatomic, assign) CGFloat imageWidth;

/**
 * 图片高度
 */
@property(nonatomic, assign) CGFloat imageHeight;

/**
 * 单遍时间 静态图一直为1
 */
@property(nonatomic, assign) CGFloat during;

@property (nonatomic, strong) MFMediaViewModelPAGConfig *pagConfig;
@property (nonatomic, strong) MFMediaViewModelSVGAConfig *svgaConfig;
@property (nonatomic, strong) MFMediaViewModelImageConfig *imageConfig;

- (NSString *)description;

/**
 * 构造方法
 * @param style 媒体类型
 * @param url 媒体网络地址
 * @param furUrl 媒体网络地址
 * @return 媒体模型
 */
+ (instancetype)modelWithStyle:(MFMediaViewModelStyle)style url:(NSString *)url furUrl:(NSString *)furUrl;

/**
 * 构造方法
 * @param style 媒体类型
 * @param url 媒体网络地址
 * @return 媒体模型
 */
+ (instancetype)modelWithStyle:(MFMediaViewModelStyle)style url:(NSString *)url;

/**
 * 构造方法
 * @param style 媒体类型
 * @param localPath 本地文件地址
 * @return 媒体模型
 */
+ (instancetype)modelWithStyle:(MFMediaViewModelStyle)style localPath:(NSString *)localPath;

/**
 * 构造方法
 * @param style 媒体类型
 * @param url 媒体网络地址
 * @param furUrl 媒体网络地址
 * @param imageWidth 图片宽度
 * @param imageHeight 图片高度
 * @return 媒体模型
 */
+ (instancetype)modelWithStyle:(MFMediaViewModelStyle)style
                           url:(NSString *)url
                        furUrl:(NSString *)furUrl
                    imageWidth:(CGFloat)imageWidth
                   imageHeight:(CGFloat)imageHeight;

/**
 * 构造方法
 * @param style 媒体类型
 * @param localPath 媒体本地文件地址
 * @param url 媒体网络地址
 * @param furUrl 媒体网络地址
 * @param imageWidth 图片宽度
 * @param imageHeight 图片高度
 * @return 媒体模型
 */
+ (instancetype)modelWithStyle:(MFMediaViewModelStyle)style
                     localPath:(NSString *)localPath
                           url:(NSString *)url
                        furUrl:(NSString *)furUrl
                    imageWidth:(CGFloat)imageWidth
                   imageHeight:(CGFloat)imageHeight;


@end
