//
//  MFMediaViewPlayerAudio.m
//  MFMediaView
//
//  Created by Administer on 2022/10/24.
//

#import "MFMediaViewPlayerAudio.h"
#import "MFMediaViewAudioView.h"

@implementation MFMediaViewPlayerAudio

- (void)configureAudioView:(MFMediaViewAudioView *)audioView {
    _audioView = audioView;
}


//@property (nonatomic) NSInteger voiceEffect;

- (void)setVoiceEffect:(NSInteger)voiceEffect {
    _voiceEffect = voiceEffect;
    [self.audioView updateVoiceEffect:voiceEffect];
}

- (void)playLocalFile:(NSString *)localFile voiceEffect:(NSInteger)voiceEffect {
    [self.audioView playLocalFile:localFile voiceEffect:voiceEffect];
}

- (void)playNetFile:(NSString *)url voiceEffect:(NSInteger)voiceEffect {
    [self.audioView playNetFile:url voiceEffect:voiceEffect];
}

- (void)play {
    [self.audioView updateAudioPlayStatus:1];
}

- (void)pause {
    [self.audioView updateAudioPlayStatus:2];
}

- (void)stop {
    [self.audioView updateAudioPlayStatus:0];
}

- (void)replay {
    [self.audioView updateAudioPlayStatus:3];
}

@end
