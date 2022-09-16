//
// Created by Neal on 2022/8/8.
//

#import "MFMediaViewModel.h"


@implementation MFMediaViewModel {
}

- (instancetype)initWithStyle:(MFMediaViewModelStyle)style
                    localPath:(NSString *)localPath
                          url:(NSString *)url
                       furUrl:(NSString *)furUrl
                   imageWidth:(CGFloat)imageWidth
                  imageHeight:(CGFloat)imageHeight {
    self = [super init];
    if (self) {
        self.style = style;
        self.localPath = localPath;
        self.url = url;
        self.furUrl = furUrl;
        self.imageWidth = imageWidth;
        self.imageHeight = imageHeight;
    }

    return self;
}

+ (instancetype)modelWithStyle:(MFMediaViewModelStyle)style url:(NSString *)url furUrl:(NSString *)furUrl {
    return [[self alloc] initWithStyle:style
                             localPath:@""
                                   url:url
                                furUrl:furUrl
                            imageWidth:1
                           imageHeight:1];
}


+ (instancetype)modelWithStyle:(MFMediaViewModelStyle)style url:(NSString *)url {
    return [[self alloc] initWithStyle:style
                             localPath:@""
                                   url:url
                                furUrl:@""
                            imageWidth:1
                           imageHeight:1];
}


+ (instancetype)modelWithStyle:(MFMediaViewModelStyle)style localPath:(NSString *)localPath {
    return [[self alloc] initWithStyle:style
                             localPath:localPath
                                   url:@""
                                furUrl:@""
                            imageWidth:1
                           imageHeight:1];
}

+ (instancetype)modelWithStyle:(MFMediaViewModelStyle)style url:(NSString *)url furUrl:(NSString *)furUrl imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight {
    return [[self alloc] initWithStyle:style
                             localPath:@""
                                   url:url
                                furUrl:furUrl
                            imageWidth:imageWidth
                           imageHeight:imageHeight];
}


+ (instancetype)modelWithStyle:(MFMediaViewModelStyle)style
                     localPath:(NSString *)localPath
                           url:(NSString *)url
                        furUrl:(NSString *)furUrl
                    imageWidth:(CGFloat)imageWidth
                   imageHeight:(CGFloat)imageHeight {
    return [[self alloc] initWithStyle:style
                             localPath:localPath
                                   url:url
                                furUrl:furUrl
                            imageWidth:imageWidth
                           imageHeight:imageHeight];
}


- (MFMediaViewModelPAGConfig *)pagConfig {
    if (!_pagConfig) {
        _pagConfig = [MFMediaViewModelPAGConfig defaultConfigure];
    }
    return _pagConfig;
}

- (MFMediaViewModelSVGAConfig *)svgaConfig {
    if (!_svgaConfig) {
        _svgaConfig = [MFMediaViewModelSVGAConfig defaultConfigure];
    }
    return _svgaConfig;
}

- (MFMediaViewModelImageConfig *)imageConfig {
    if (!_imageConfig) {
        _imageConfig = [MFMediaViewModelImageConfig defaultConfigure];
    }
    return _imageConfig;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.style=%d", self.style];
    [description appendFormat:@", self.localPath=%@", self.localPath];
    [description appendFormat:@", self.url=%@", self.url];
    [description appendFormat:@", self.furUrl=%@", self.furUrl];
    [description appendFormat:@", self.imageWidth=%lf", self.imageWidth];
    [description appendFormat:@", self.imageHeight=%lf", self.imageHeight];
    [description appendFormat:@", self.during=%lf", self.during];
    [description appendFormat:@", self.pagConfig=%@", self.pagConfig];
    [description appendFormat:@", self.svgaConfig=%@", self.svgaConfig];
    [description appendString:@">"];
    return description;
}


@end
