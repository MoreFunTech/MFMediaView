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

#import <libpag/PAGView.h>

@interface MFMediaView ()

@property(nonatomic, strong) MFMediaViewImageView *imageView;
@property(nonatomic, strong) MFMediaViewVideoView *videoView;
@property(nonatomic, strong) MFMediaViewGifView *gifView;
@property(nonatomic, strong) MFMediaViewAudioView *audioView;
@property(nonatomic, strong) MFMediaViewSVGAView *svgaView;
@property(nonatomic, strong) MFMediaViewPAGView *pagView;

@end

@implementation MFMediaView


- (void)startPlayAnimate {
    
    if (self.gifView) {
        [self.gifView startPlayAnimate];
    }
    
    if (self.svgaView) {
        [self.svgaView startPlayAnimate];
    }
    
    if (self.pagView) {
        [self.pagView startPlayAnimate];
    }
    
}

- (void)stopPlayAnimate {
    if (self.gifView) {
        [self.gifView stopPlayAnimate];
    }
    
    if (self.svgaView) {
        [self.svgaView stopPlayAnimate];
    }
    
    if (self.pagView) {
        [self.pagView stopPlayAnimate];
    }
    
}

- (void)restartPlayAnimate {
    if (self.gifView) {
        [self.gifView restartPlayAnimate];
    }
    
    if (self.svgaView) {
        [self.svgaView restartPlayAnimate];
    }
    
    if (self.pagView) {
        [self.pagView restartPlayAnimate];
    }
}

- (void)setModel:(MFMediaViewModel *)model {
    _model = model;
    
    
    if ([self isStringNotNull:model.localPath]) {
        if (self.mediaTypeEncoderDelegate &&
            [self.mediaTypeEncoderDelegate respondsToSelector:@selector(encodeMediaTypeByTypeCode:)]) {
            int typeCode = [MFMediaViewFileTypeJudger getTypeCodeWithFilePath:model.localPath];
            MFMediaViewModelStyle style = [self.mediaTypeEncoderDelegate encodeMediaTypeByTypeCode:typeCode];
            model.style = style;
        } else if (MFMediaViewFileTypeJudger.mediaTypeEncoder &&
                   [MFMediaViewFileTypeJudger.mediaTypeEncoder respondsToSelector:@selector(encodeMediaTypeByTypeCode:)]) {
            int typeCode = [MFMediaViewFileTypeJudger getTypeCodeWithFilePath:model.localPath];
            MFMediaViewModelStyle style = [MFMediaViewFileTypeJudger.mediaTypeEncoder encodeMediaTypeByTypeCode:typeCode];
            model.style = style;
        }
        
    }
    
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.imageView) {
            self.imageView = [[MFMediaViewImageView alloc] initWithFrame:self.bounds];
            [self addSubview:self.imageView];
        }
        self.imageView.frame = self.bounds;
        self.imageView.mediaLoadFinishBlock = self.mediaLoadFinishBlock;
        self.imageView.customModel = self.customModel;
        self.imageView.model = model;
    //    _player.imagePlayer.imageView = self.imageView;
    });
    
}

- (void)configureVideoViewWithModel:(MFMediaViewModel *)model {
    [self clearViewWithout:model];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.videoView) {
            self.videoView = [[MFMediaViewVideoView alloc] initWithFrame:self.bounds];
            [self addSubview:self.videoView];
        }
        self.videoView.frame = self.bounds;
        self.videoView.mediaLoadFinishBlock = self.mediaLoadFinishBlock;
        self.videoView.customModel = self.customModel;
        self.videoView.model = model;
    //    _player.videoPlayer.videoView = self.videoView;
    });
    
}

- (void)configureGifViewWithModel:(MFMediaViewModel *)model {
    [self clearViewWithout:model];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.gifView) {
            self.gifView = [[MFMediaViewGifView alloc] initWithFrame:self.bounds];
            [self addSubview:self.gifView];
        }
        self.gifView.frame = self.bounds;
        self.gifView.mediaLoadFinishBlock = self.mediaLoadFinishBlock;
        self.gifView.customModel = self.customModel;
        self.gifView.model = model;
    //    _player.giftPlayer.giftView = self.gifView;
    });
    
}

- (void)configureAudioViewWithModel:(MFMediaViewModel *)model {
    [self clearViewWithout:model];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.audioView) {
            self.audioView = [[MFMediaViewAudioView alloc] initWithFrame:self.bounds];
            [self addSubview:self.audioView];
        }
        self.audioView.frame = self.bounds;
        self.audioView.mediaLoadFinishBlock = self.mediaLoadFinishBlock;
        self.audioView.customModel = self.customModel;
        self.audioView.model = model;
        [self.player.audioPlayer configureAudioView:self.audioView];
    });
    
//    _player.audioPlayer.audioView = self.audioView;
}

- (void)configureSVGAViewWithModel:(MFMediaViewModel *)model {
    [self clearViewWithout:model];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.svgaView) {
            self.svgaView = [[MFMediaViewSVGAView alloc] initWithFrame:self.bounds];
            [self addSubview:self.svgaView];
        }
        self.svgaView.frame = self.bounds;
        self.svgaView.mediaLoadFinishBlock = self.mediaLoadFinishBlock;
        self.svgaView.customModel = self.customModel;
        self.svgaView.model = model;
    //    _player.svgaPlayer.svgaView = self.svgaView;
    });
    
}

- (void)configurePAGViewWithModel:(MFMediaViewModel *)model {
    [self clearViewWithout:model];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.pagView) {
            self.pagView = [[MFMediaViewPAGView alloc] initWithFrame:self.bounds];
            [self addSubview:self.pagView];
        }
        
        __weak typeof(self) weakSelf = self;
        self.pagView.frame = self.bounds;
        self.pagView.mediaLoadFinishBlock = self.mediaLoadFinishBlock;
        self.pagView.customModel = self.customModel;
        self.pagView.model = model;
        self.pagView.pagFileDidLoadSuccess = ^(PAGFile *file) {
            [weakSelf configurePAGViewDidLoadPAGFileSuccess:file];
        };
        self.pagView.pagCompositionDidLoadSuccess = ^(PAGComposition *composition) {
            [weakSelf configurePAGViewDidLoadCompositionSuccess:composition];
        };
        
        [self.player.pagPlayer configurePagView:self.pagView];
        [self.player.pagPlayer configurePagConfig:model.pagConfig];
    });

    
}

- (void)configurePAGViewDidLoadPAGFileSuccess:(PAGFile *)file {
    if (self.model.pagConfig.onPagFileLoadSuccess) {
        self.model.pagConfig.onPagFileLoadSuccess();
    }
}

- (void)configurePAGViewDidLoadCompositionSuccess:(PAGComposition *)composition {
    if (self.model.pagConfig.onPagFileLoadSuccess) {
        self.model.pagConfig.onPagFileLoadSuccess();
    }
}



- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self resetSubviews];
}

- (void)setCustomModel:(id)customModel {
    _customModel = customModel;
    if (self.imageView) {
        self.imageView.customModel = _customModel;
    }
    if (self.videoView) {
        self.videoView.customModel = _customModel;
    }
    if (self.gifView) {
        self.gifView.customModel = _customModel;
    }
    if (self.audioView) {
        self.audioView.customModel = _customModel;
    }
    if (self.pagView) {
        self.pagView.customModel = _customModel;
    }
    if (self.svgaView) {
        self.svgaView.customModel = _customModel;
    }
}

- (void)resetSubviews {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect newFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        if (self.imageView) {
            self.imageView.frame = newFrame;
            [self.imageView resetSubviews];
        }
        if (self.videoView) {
            self.videoView.frame = newFrame;
            [self.videoView resetSubviews];
        }
        if (self.gifView) {
            self.gifView.frame = newFrame;
            [self.gifView resetSubviews];
        }
        if (self.audioView) {
            self.audioView.frame = newFrame;
            [self.audioView resetSubviews];
        }
        if (self.pagView) {
            self.pagView.frame = newFrame;
            [self.pagView resetSubviews];
        }
        if (self.svgaView) {
            self.svgaView.frame = newFrame;
            [self.svgaView resetSubviews];
        }
    });
    
}

- (void)destroyView {
//    MFMediaViewModel *viewModel = [MFMediaViewModel modelWithStyle:MFMediaViewModelStyleNone localPath:@""];
    [self clearViewWithout:nil];
}

- (void)clearViewWithout:(MFMediaViewModel *)model {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.imageView && model.style != MFMediaViewModelStyleImage) {
            [self.imageView clear];
            self.imageView.customModel = nil;
            self.imageView.model = nil;
            self.imageView.mediaLoadFinishBlock = nil;
            [self.imageView removeFromSuperview];
            self.imageView = nil;
            //        _player.imagePlayer.imageView = nil;
        }
        if (self.videoView && model.style != MFMediaViewModelStyleVideo) {
            [self.videoView clear];
            self.videoView.customModel = nil;
            self.videoView.model = nil;
            self.videoView.mediaLoadFinishBlock = nil;
            [self.videoView removeFromSuperview];
            self.videoView = nil;
            //        _player.videoPlayer.videoView = nil;
        }
        if (self.gifView && model.style != MFMediaViewModelStyleGif) {
            [self.gifView clear];
            self.gifView.customModel = nil;
            self.gifView.model = nil;
            self.gifView.mediaLoadFinishBlock = nil;
            [self.gifView removeFromSuperview];
            self.gifView = nil;
            //        _player.giftPlayer.giftView = nil;
        }
        if (self.audioView && model.style != MFMediaViewModelStyleAudio) {
            [self.audioView clear];
            self.audioView.customModel = nil;
            self.audioView.model = nil;
            self.audioView.mediaLoadFinishBlock = nil;
            [self.audioView removeFromSuperview];
            self.audioView = nil;
    //                _player.audioPlayer.audioView = nil;
        }
        if (self.svgaView && model.style != MFMediaViewModelStyleSvga) {
            [self.svgaView clear];
            self.svgaView.customModel = nil;
            self.svgaView.model = nil;
            self.svgaView.mediaLoadFinishBlock = nil;
            [self.svgaView removeFromSuperview];
            self.svgaView = nil;
            [self.player.svgaPlayer configureSvgaView:nil];
    //        _player.svgaPlayer.svgaView = nil;
        }
        if (self.pagView && model.style != MFMediaViewModelStylePag) {
            [self.pagView clear];
            self.pagView.customModel = nil;
            self.pagView.model = nil;
            self.pagView.mediaLoadFinishBlock = nil;
            [self.pagView removeFromSuperview];
            self.pagView = nil;
            [self.player.pagPlayer configurePagView:nil];
        }
    });
}

- (MFMediaViewPlayer *)player {
    if (!_player) {
        _player = [[MFMediaViewPlayer alloc] init];
    }
    return _player;
}


- (BOOL)isStringNotNull:(NSString *)string {
    if ([string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    if (string.length <= 0) {
        return NO;
    }
    return YES;
}

@end
