//
//  MFMediaViewEnum.h
//  MFMediaView
//
//  Created by Administer on 2022/10/9.
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

@protocol MFMediaViewModelAudioProtocol <NSObject>



@end
