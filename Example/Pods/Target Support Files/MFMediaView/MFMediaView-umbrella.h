#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MFMediaView.h"
#import "MFMediaViewAudioView.h"
#import "MFMediaViewEnum.h"
#import "MFMediaViewFileTypeJudger.h"
#import "MFMediaViewGifView.h"
#import "MFMediaViewHeader.h"
#import "MFMediaViewImageView.h"
#import "MFMediaViewModel.h"
#import "MFMediaViewModelAudioConfig.h"
#import "MFMediaViewModelGifConfig.h"
#import "MFMediaViewModelImageConfig.h"
#import "MFMediaViewModelPAGConfig.h"
#import "MFMediaViewModelSVGAConfig.h"
#import "MFMediaViewPAGView.h"
#import "MFMediaViewPlayer.h"
#import "MFMediaViewPlayerAudio.h"
#import "MFMediaViewPlayerGif.h"
#import "MFMediaViewPlayerImage.h"
#import "MFMediaViewPlayerPag.h"
#import "MFMediaViewPlayerSvga.h"
#import "MFMediaViewPlayerVideo.h"
#import "MFMediaViewSVGAView.h"
#import "MFMediaViewVideoView.h"

FOUNDATION_EXPORT double MFMediaViewVersionNumber;
FOUNDATION_EXPORT const unsigned char MFMediaViewVersionString[];

