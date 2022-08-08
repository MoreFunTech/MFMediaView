//
//  MFMediaView.m
//  MFMediaView
//
//  Created by Administer on 2022/8/8.
//

#import "MFMediaView.h"

#import "MFMediaViewImageView.h"
#import "MFMediaViewVideoView.h"
#import "MFMediaViewGifView.h"
#import "MFMediaViewAudioView.h"
#import "MFMediaViewSVGAView.h"
#import "MFMediaViewPAGView.h"

@interface MFMediaView ()

@property(nonatomic, strong) MFMediaViewImageView *imageView;
@property(nonatomic, strong) MFMediaViewVideoView *videoView;
@property(nonatomic, strong) MFMediaViewGifView *gifView;
@property(nonatomic, strong) MFMediaViewAudioView *audioView;
@property(nonatomic, strong) MFMediaViewSVGAView *svgaView;
@property(nonatomic, strong) MFMediaViewPAGView *pagView;

@end

@implementation MFMediaView

- (void)setModel:(MFMediaViewModel *)model {
    _model = model;

    switch (model.style) {

        case MFMediaViewModelStyleNone:
            [self configureNoneViewWithModel:model];
            break;
        case MFMediaViewModelStyleImage:
            [self configureImageViewWithModel:model];
            break;
        case MFMediaViewModelStyleVideo:
            [self configureVideoViewWithModel:model];
            break;
        case MFMediaViewModelStyleGif:
            [self configureGifViewWithModel:model];
            break;
        case MFMediaViewModelStyleAudio:
            [self configureAudioViewWithModel:model];
            break;
        case MFMediaViewModelStyleSvga:
            [self configureSVGAViewWithModel:model];
            break;
        case MFMediaViewModelStylePag:
            [self configurePAGViewWithModel:model];
            break;
    }
}

- (void)configureNoneViewWithModel:(MFMediaViewModel *)model {
    [self clearViewWithout:model];

}

- (void)configureImageViewWithModel:(MFMediaViewModel *)model {
    [self clearViewWithout:model];
    if (!_imageView) {
        _imageView = [[MFMediaViewImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }
    _imageView.model = model;
}

- (void)configureVideoViewWithModel:(MFMediaViewModel *)model {
    [self clearViewWithout:model];
    if (!_videoView) {
        _videoView = [[MFMediaViewVideoView alloc] initWithFrame:self.bounds];
        [self addSubview:_videoView];
    }
    _videoView.model = model;
}

- (void)configureGifViewWithModel:(MFMediaViewModel *)model {
    [self clearViewWithout:model];
    if (!_gifView) {
        _gifView = [[MFMediaViewGifView alloc] initWithFrame:self.bounds];
        [self addSubview:_gifView];
    }
    _gifView.model = model;
}

- (void)configureAudioViewWithModel:(MFMediaViewModel *)model {
    [self clearViewWithout:model];
    if (!_audioView) {
        _audioView = [[MFMediaViewAudioView alloc] initWithFrame:self.bounds];
        [self addSubview:_audioView];
    }
    _audioView.model = model;
}

- (void)configureSVGAViewWithModel:(MFMediaViewModel *)model {
    [self clearViewWithout:model];
    if (!_svgaView) {
        _svgaView = [[MFMediaViewSVGAView alloc] initWithFrame:self.bounds];
        [self addSubview:_svgaView];
    }
    _svgaView.model = model;
}

- (void)configurePAGViewWithModel:(MFMediaViewModel *)model {
    [self clearViewWithout:model];
    if (!_pagView) {
        _pagView = [[MFMediaViewPAGView alloc] initWithFrame:self.bounds];
        [self addSubview:_pagView];
    }
    _pagView.model = model;
}

- (void)clearViewWithout:(MFMediaViewModel *)model {
    if (_imageView && model.style != MFMediaViewModelStyleImage) {
        [_imageView clear];
        _imageView.model = nil;
        [_imageView removeFromSuperview];
        _imageView = nil;
    }
    if (_videoView && model.style != MFMediaViewModelStyleVideo) {
        [_videoView clear];
        _videoView.model = nil;
        [_videoView removeFromSuperview];
        _videoView = nil;
    }
    if (_gifView && model.style != MFMediaViewModelStyleGif) {
        [_gifView clear];
        _gifView.model = nil;
        [_gifView removeFromSuperview];
        _gifView = nil;
    }
    if (_audioView && model.style != MFMediaViewModelStyleAudio) {
        [_audioView clear];
        _audioView.model = nil;
        [_audioView removeFromSuperview];
        _audioView = nil;
    }
    if (_svgaView && model.style != MFMediaViewModelStyleSvga) {
        [_svgaView clear];
        _svgaView.model = nil;
        [_svgaView removeFromSuperview];
        _svgaView = nil;
    }
    if (_pagView && model.style != MFMediaViewModelStylePag) {
        [_pagView clear];
        _pagView.model = nil;
        [_pagView removeFromSuperview];
        _pagView = nil;
    }
}

@end
