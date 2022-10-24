//
//  MFMediaViewPlayer.h
//  MFMediaView
//
//  Created by Administer on 2022/10/24.
//

#import <Foundation/Foundation.h>

#import "MFMediaViewPlayerPag.h"
#import "MFMediaViewPlayerAudio.h"
#import "MFMediaViewPlayerSvga.h"
#import "MFMediaViewPlayerImage.h"
#import "MFMediaViewPlayerGif.h"
#import "MFMediaViewPlayerVideo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MFMediaViewPlayer : NSObject

@property (nonatomic, strong) MFMediaViewPlayerPag *pagPlayer;
@property (nonatomic, strong) MFMediaViewPlayerAudio *audioPlayer;
@property (nonatomic, strong) MFMediaViewPlayerSvga *svgaPlayer;
@property (nonatomic, strong) MFMediaViewPlayerImage *imagePlayer;
@property (nonatomic, strong) MFMediaViewPlayerGif *gifPlayer;
@property (nonatomic, strong) MFMediaViewPlayerVideo *videoPlayer;

@end

NS_ASSUME_NONNULL_END
