//
//  MFMediaViewPlayer.m
//  MFMediaView
//
//  Created by Administer on 2022/10/24.
//

#import "MFMediaViewPlayer.h"

@implementation MFMediaViewPlayer

- (MFMediaViewPlayerImage *)imagePlayer {
    if (!_imagePlayer) {
        _imagePlayer = [[MFMediaViewPlayerImage alloc] init];
    }
    return _imagePlayer;
}

- (MFMediaViewPlayerVideo *)videoPlayer {
    if (!_videoPlayer) {
        _videoPlayer = [[MFMediaViewPlayerVideo alloc] init];
    }
    return _videoPlayer;
}

- (MFMediaViewPlayerGif *)gifPlayer {
    if (!_gifPlayer) {
        _gifPlayer = [[MFMediaViewPlayerGif alloc] init];
    }
    return _gifPlayer;
}

- (MFMediaViewPlayerAudio *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [[MFMediaViewPlayerAudio alloc] init];
    }
    return _audioPlayer;
}

- (MFMediaViewPlayerSvga *)svgaPlayer {
    if (!_svgaPlayer) {
        _svgaPlayer = [[MFMediaViewPlayerSvga alloc] init];
    }
    return _svgaPlayer;
}

- (MFMediaViewPlayerPag *)pagPlayer {
    if (!_pagPlayer) {
        _pagPlayer = [[MFMediaViewPlayerPag alloc] init];
    }
    return _pagPlayer;
}

@end
