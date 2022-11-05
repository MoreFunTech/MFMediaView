//
// Created by Neal on 2022/8/8.
//

#import "MFMediaViewGifView.h"
#import <SDWebImage/SDWebImage.h>
#import "MFMediaViewModel.h"


@interface SDAnimatedImageView (MFMediaGiftView)

- (void)setCurrentFrameIndex:(NSUInteger)currentFrameIndex;

@end

@interface MFMediaViewAnimateView: SDAnimatedImageView

@property (nonatomic, copy) void(^onAnimationStartAction)(void);
@property (nonatomic, copy) void(^onAnimationEndAction)(void);

@end

@implementation MFMediaViewAnimateView

//currentFrameIndex

//@property (nonatomic, assign, readwrite) NSUInteger currentFrameIndex;

- (void)setCurrentFrameIndex:(NSUInteger)currentFrameIndex {
    [super setCurrentFrameIndex:currentFrameIndex];
    if (currentFrameIndex == 1) {
        if (self.onAnimationStartAction) {
            self.onAnimationStartAction();
        }
    }
    if (currentFrameIndex == self.player.totalFrameCount - 1) {
        if (self.onAnimationEndAction) {
            self.onAnimationEndAction();
        }
    }
}

@end
 
@interface MFMediaViewGifView ()

@property (nonatomic, strong) MFMediaViewAnimateView *imageView;

@end


@implementation MFMediaViewGifView {

}

- (void)startPlayAnimate {
    [self.imageView startAnimating];
}

- (void)restartPlayAnimate {
    [self.imageView startAnimating];
}



- (void)stopPlayAnimate {
    [self.imageView stopAnimating];
}

- (void)configureDefaultView {
    
    if (!_imageView) {
        _imageView = [[MFMediaViewAnimateView alloc] initWithFrame:self.bounds];
        [self addImageViewObserve];
    }

}

- (void)resetSubviews {
    
    if (!_imageView) {
        _imageView = [[MFMediaViewAnimateView alloc] initWithFrame:self.bounds];
        [self addImageViewObserve];
    }
    
    self.imageView.frame = self.bounds;
}

- (void)addImageViewObserve {
    
    __weak typeof(self) weakSelf = self;
    self.imageView.onAnimationEndAction = ^{
        if (weakSelf.model.gifConfig.onAnimationEndAction) {
            weakSelf.model.gifConfig.onAnimationEndAction();
        }
    };
    
    self.imageView.onAnimationStartAction = ^{
        if (weakSelf.model.gifConfig.onAnimationStartAction) {
            weakSelf.model.gifConfig.onAnimationStartAction();
        }
    };
}

- (void)configureDefaultView:(MFMediaViewModel *)model {
    if (!_imageView) {
        _imageView = [[MFMediaViewAnimateView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = model.gifConfig.contentMode;
        [self addSubview:_imageView];
        [self addImageViewObserve];
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
    
    self.imageView.autoPlayAnimatedImage = model.gifConfig.isAutoPlay;
    if (model.gifConfig.repeatCount > 0) {
        self.imageView.shouldCustomLoopCount = YES;
        self.imageView.animationRepeatCount = model.gifConfig.repeatCount;
    } else {
        self.imageView.shouldCustomLoopCount = NO;
    }
    
    
    self.imageView.contentMode = model.gifConfig.contentMode;
    if (model.gifConfig.setNetImageBlock && [self isStringNotNull:model.url]) {
        model.gifConfig.setNetImageBlock(model.url, self.imageView);
    } else if (model.gifConfig.localImage) {
        self.imageView.image = [model.gifConfig.localImage imageWithRenderingMode:model.gifConfig.renderMode];
        self.imageView.tintColor = model.gifConfig.tintColor;
    } else if ([self isStringNotNull:model.localPath]) {
        NSError *error;
        NSData *imageData = [NSData dataWithContentsOfFile:model.localPath options:NSDataReadingMappedIfSafe error:&error];
        if (!error && imageData) {
            UIImage *image = [UIImage imageWithData:imageData scale:UIScreen.mainScreen.scale];
            self.imageView.image = [image imageWithRenderingMode:model.gifConfig.renderMode];
            self.imageView.tintColor = model.gifConfig.tintColor;
        } else {
            self.imageView.image = model.gifConfig.placeHolderImage;
        }
    } else {
        self.imageView.image = model.gifConfig.placeHolderImage;
    }
    
    
    
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

- (void)clear {
    self.imageView.image = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}


@end
