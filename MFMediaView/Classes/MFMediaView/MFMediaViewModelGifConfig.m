//
//  MFMediaViewModelGifConfig.m
//  MFMediaView
//
//  Created by Administer on 2022/10/9.
//

#import "MFMediaViewModelGifConfig.h"
#import <SDWebImage/SDWebImage.h>

@implementation MFMediaViewModelGifConfig


+ (instancetype)defaultConfigure {
    MFMediaViewModelGifConfig *configure = [[MFMediaViewModelGifConfig alloc] init];
    configure.contentMode = UIViewContentModeScaleAspectFill;
//    configure.placeHolderImage = [UIImage imageNamed:@""];
    configure.localImage = nil;
    configure.repeatCount = 0;
    configure.isAutoPlay = YES;
    __weak typeof(configure) weakConfigure = configure;
    configure.setNetImageBlock = ^(NSString * _Nonnull netImageUrl, UIImageView * _Nonnull imageView) {
        [weakConfigure netImageAction:netImageUrl imageView:imageView];
    };
    
    return configure;
}

- (void)netImageAction:(NSString *)netImageUrl imageView:(UIImageView *)imageView {
    if (![self isStringNotNull:netImageUrl]) {
        imageView.image = self.placeHolderImage;
        return;
    }

    NSURL *url = [NSURL URLWithString:netImageUrl];
    if (url) {
        __weak typeof(self) weakSelf = self;
        __weak typeof(imageView) weakImageView = imageView;
        [imageView sd_setImageWithURL:[NSURL URLWithString:netImageUrl] placeholderImage:self.placeHolderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            if (expectedSize > 0) {
                CGFloat progress = @(receivedSize).floatValue / @(expectedSize).floatValue;
                if (self.onFileLoadingAction) {
                    self.onFileLoadingAction(progress);
                }
            }
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [weakSelf netImageSetAction:weakImageView image:image error:error cacheType:cacheType imageURL:imageURL];
            if (error) {
                if (weakSelf.onFileLoadFailureAction) {
                    weakSelf.onFileLoadFailureAction(error);
                }
            }
        }];
    } else {
        imageView.image = self.placeHolderImage;
        imageView.tintColor = self.tintColor;
    }
}

- (void)netImageSetAction:(UIImageView *)imageView image:(UIImage * _Nullable)image error:(NSError * _Nullable)error cacheType:(SDImageCacheType)cacheType imageURL:(NSURL * _Nullable)imageURL{
    if (image) {
        imageView.image = image;
        imageView.tintColor = self.tintColor;
        if (self.onFileLoadSuccessAction) {
            self.onFileLoadSuccessAction();
        }
    } else {
        imageView.image = self.placeHolderImage;
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

@end
