//
// Created by Neal on 2022/8/8.
//

#import "MFMediaViewSVGAView.h"
#import "MFMediaViewModel.h"
#include <SVGAPlayer/SVGA.h>


@interface MFMediaViewSVGAView ()

@property(nonatomic, strong) SVGAPlayer *svgaPlayer;
@property(nonatomic, strong) SVGAParser *svgaParser;

@end

@implementation MFMediaViewSVGAView {

}


- (void)configureDefaultView:(MFMediaViewModel *)model {
    if (!_svgaPlayer) {
        _svgaPlayer = [[SVGAPlayer alloc] initWithFrame:self.bounds];
        _svgaPlayer.contentMode = model.svgaConfig.contentMode;
        _svgaPlayer.loops = (int) model.svgaConfig.repeatCount;
        _svgaPlayer.clearsAfterStop = model.svgaConfig.clearsAfterStop;
        [self addSubview:_svgaPlayer];
    }
    [self configureView:model];
}

- (void)setModel:(MFMediaViewModel *)model {
    _model = model;
    if (!model) {
        [self configureView:model];
    } else {
        [self configureDefaultView:model];
    }
}

- (void)configureView:(MFMediaViewModel *)model {
    if (!_svgaParser) {
        _svgaParser = [[SVGAParser alloc] init];
    }
    NSURL *url;
    if ([self isStringNotNull:model.localPath]) {
        url = [NSURL fileURLWithPath:model.localPath];
    }
    if ([self isStringNotNull:model.url]) {
        url = [NSURL fileURLWithPath:model.url];
    }
    if (!url) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.svgaParser parseWithURL:url completionBlock:^(SVGAVideoEntity *videoItem) {
        if (videoItem) {
            weakSelf.svgaPlayer.videoItem = videoItem;
            [weakSelf.svgaPlayer startAnimation];
        }
    }                failureBlock:^(NSError *error) {

    }];
}

- (void)clear {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
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
