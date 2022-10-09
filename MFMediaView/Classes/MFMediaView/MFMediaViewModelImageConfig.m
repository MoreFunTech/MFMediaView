//
//  MFMediaViewModelImageConfig.m
//  MFMediaView
//
//  Created by Administer on 2022/9/16.
//

#import "MFMediaViewModelImageConfig.h"
#import <SDWebImage/SDWebImage.h>

@implementation MFMediaViewModelImageConfig

+ (instancetype)defaultConfigure {
    MFMediaViewModelImageConfig *configure = [[MFMediaViewModelImageConfig alloc] init];
    configure.contentMode = UIViewContentModeScaleAspectFill;
//    configure.placeHolderImage = [UIImage imageNamed:@""];
    configure.localImage = nil;
    configure.tintColor = nil;
    configure.renderMode = UIImageRenderingModeAlwaysOriginal;
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
        [imageView sd_setImageWithURL:[NSURL URLWithString:netImageUrl] placeholderImage:self.placeHolderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [weakSelf netImageSetAction:weakImageView image:image error:error cacheType:cacheType imageURL:imageURL];
        }];
    } else {
        imageView.image = self.placeHolderImage;
        imageView.tintColor = self.tintColor;
    }
}

- (void)netImageSetAction:(UIImageView *)imageView image:(UIImage * _Nullable)image error:(NSError * _Nullable)error cacheType:(SDImageCacheType)cacheType imageURL:(NSURL * _Nullable)imageURL{
    if (image) {
        imageView.image = [image imageWithRenderingMode:self.renderMode];
        imageView.tintColor = self.tintColor;
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
