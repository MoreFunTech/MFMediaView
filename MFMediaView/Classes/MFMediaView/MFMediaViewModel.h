//
// Created by Neal on 2022/8/8.
//

#import <Foundation/Foundation.h>


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
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *furUrl;
@property(nonatomic, assign) CGFloat imageWidth;
@property(nonatomic, assign) CGFloat imageHeight;

- (instancetype)initWithStyle:(MFMediaViewModelStyle)style url:(NSString *)url furUrl:(NSString *)furUrl imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight;

+ (instancetype)modelWithStyle:(MFMediaViewModelStyle)style url:(NSString *)url furUrl:(NSString *)furUrl imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight;

+ (instancetype)modelWithStyle:(MFMediaViewModelStyle)style url:(NSString *)url;

@end