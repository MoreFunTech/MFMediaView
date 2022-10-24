//
//  MFMediaViewPlayerAudio.h
//  MFMediaView
//
//  Created by Administer on 2022/10/24.
//

#import <Foundation/Foundation.h>

@class MFMediaViewAudioView;

NS_ASSUME_NONNULL_BEGIN

@interface MFMediaViewPlayerAudio : NSObject

@property(nonatomic, weak) MFMediaViewAudioView *audioView;

- (void)configureAudioView:(MFMediaViewAudioView * _Nullable)audioView;

@end

NS_ASSUME_NONNULL_END
