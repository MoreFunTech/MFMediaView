//
// Created by Neal on 2022/8/8.
//

#import "MFMediaViewGifView.h"
#import <SDWebImage/SDWebImage.h>
#import "MFMediaViewModel.h"

@interface MFMediaViewGifView ()

@property (nonatomic, strong) SDAnimatedImageView *imageView;

@end


@implementation MFMediaViewGifView {

}

- (void)configureDefaultView {
    
    if (!_imageView) {
        _imageView = [[SDAnimatedImageView alloc] initWithFrame:self.bounds];
    }

}

- (void)resetSubviews {
    
    if (!_imageView) {
        _imageView = [[SDAnimatedImageView alloc] initWithFrame:self.bounds];
    }
    
    self.imageView.frame = self.bounds;
}

- (void)configureDefaultView:(MFMediaViewModel *)model {
    if (!_imageView) {
        _imageView = [[SDAnimatedImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = model.imageConfig.contentMode;
        [self addSubview:_imageView];
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
    
    self.imageView.contentMode = model.imageConfig.contentMode;
    if (model.imageConfig.setNetImageBlock && [self isStringNotNull:model.url]) {
        model.imageConfig.setNetImageBlock(model.url, self.imageView);
    } else if (model.imageConfig.localImage) {
        self.imageView.image = [model.imageConfig.localImage imageWithRenderingMode:model.imageConfig.renderMode];
        self.imageView.tintColor = model.imageConfig.tintColor;
    } else if ([self isStringNotNull:model.localPath]) {
        NSError *error;
        NSData *imageData = [NSData dataWithContentsOfFile:model.localPath options:NSDataReadingMappedIfSafe error:&error];
        if (!error && imageData) {
            UIImage *image = [UIImage imageWithData:imageData scale:UIScreen.mainScreen.scale];
            self.imageView.image = [image imageWithRenderingMode:model.imageConfig.renderMode];
            self.imageView.tintColor = model.imageConfig.tintColor;
        } else {
            self.imageView.image = model.imageConfig.placeHolderImage;
        }
    } else {
        self.imageView.image = model.imageConfig.placeHolderImage;
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
