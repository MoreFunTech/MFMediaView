//
// Created by Neal on 2022/8/8.
//

#import "MFMediaViewModel.h"


@implementation MFMediaViewModel { }

- (instancetype)initWithStyle:(MFMediaViewModelStyle)style url:(NSString *)url furUrl:(NSString *)furUrl imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight {
    self = [super init];
    if (self) {
        self.style = style;
        self.url = url;
        self.furUrl = furUrl;
        self.imageWidth = imageWidth;
        self.imageHeight = imageHeight;
    }

    return self;
}

- (instancetype)initWithStyle:(MFMediaViewModelStyle)style url:(NSString *)url {
    return [self initWithStyle:style url:url furUrl:@"" imageWidth:1 imageHeight:1];
}

+ (instancetype)modelWithStyle:(MFMediaViewModelStyle)style url:(NSString *)url {
    return [[self alloc] initWithStyle:style url:url];
}

+ (instancetype)modelWithStyle:(MFMediaViewModelStyle)style url:(NSString *)url furUrl:(NSString *)furUrl imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight {
    return [[self alloc] initWithStyle:style url:url furUrl:furUrl imageWidth:imageWidth imageHeight:imageHeight];
}

@end