//
// Created by Neal on 2022/8/8.
//

#import "MFMediaViewModelPAGConfig.h"
#import <libpag/PAGView.h>

@interface MFMediaViewModelPAGConfigReplaceLayerModel ()

@end

@implementation MFMediaViewModelPAGConfigTransformLayerModel {}

- (instancetype)initWithTransform:(CGAffineTransform)transform
                       layerIndex:(int)layerIndex
                        layerName:(NSString *)layerName
                     isSpecialBMP:(BOOL)isSpecialBMP {
    self = [super init];
    if (self) {
        self.matrix = transform;
        self.layerIndex = layerIndex;
        self.layerName = layerName;
        self.isSpecialBMP = isSpecialBMP;
    }
    return self;
}

+ (instancetype)modelWithTransform:(CGAffineTransform)transform
                         layerName:(NSString *)layerName {
    return [[self alloc] initWithTransform:transform
                                layerIndex:-1
                                 layerName:layerName
                              isSpecialBMP:NO];
}

+ (instancetype)modelWithTransform:(CGAffineTransform)transform
                        layerIndex:(int)layerIndex
                         layerName:(NSString *)layerName {
    return [[self alloc] initWithTransform:transform
                                layerIndex:layerIndex
                                 layerName:layerName
                              isSpecialBMP:NO];
}

+ (instancetype)modelWithTransform:(CGAffineTransform)transform
                        layerIndex:(int)layerIndex
                         layerName:(NSString *)layerName
                      isSpecialBMP:(BOOL)isSpecialBMP {
    return [[self alloc] initWithTransform:transform
                                layerIndex:layerIndex
                                 layerName:layerName
                              isSpecialBMP:isSpecialBMP];
}

@end

@implementation MFMediaViewModelPAGConfigReplaceLayerModel {}

- (void)setImage:(UIImage *)image {
    if (!image) {
        
        //        CGRect rect = CGRectMake(0.0f, 0.0f, 100, 100);
        //        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
        //        CGContextRef context = UIGraphicsGetCurrentContext();
        //        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        //        CGContextFillRect(context, rect);
        //        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //        UIGraphicsEndImageContext();
        CGRect rect = CGRectMake(0.0f, 0.0f, 100, 100);
        
        UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
        format.opaque = NO;
        
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:rect.size format:format];
        UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            [UIColor.clearColor setFill];
            UIRectFill(rect);
        }];
        _image = image;
    } else {
        CGImageRef cgImag = image.CGImage;
        _image = [UIImage imageWithCGImage:cgImag];
    }
}

- (instancetype)initWithStyle:(MFMediaViewModelPAGConfigReplaceLayerModelStyle)style
                         text:(NSString *)text
                        image:(UIImage *)image
                    layerName:(NSString *)layerName
                   layerIndex:(int)layerIndex {
    self = [super init];
    if (self) {
        self.style = style;
        self.text = text;
        self.image = image;
        self.layerName = layerName;
        self.layerIndex = layerIndex;
    }
    return self;
}

- (instancetype)initWithStyle:(MFMediaViewModelPAGConfigReplaceLayerModelStyle)style
                         text:(NSString *)text
                        image:(UIImage *)image
                    layerName:(NSString *)layerName
                   layerIndex:(int)layerIndex
                 isSpecialBMP:(BOOL)isSpecialBMP {
    self = [super init];
    if (self) {
        self.style = style;
        self.text = text;
        self.image = image;
        self.layerName = layerName;
        self.layerIndex = layerIndex;
        self.isSpecialBMP = isSpecialBMP;
    }
    return self;
}



+ (instancetype)modelWithText:(NSString *)text
                    layerName:(NSString *)layerName {
    return [[self alloc] initWithStyle:(MFMediaViewModelPAGConfigReplaceLayerModelStyleText) text:text image:nil layerName:layerName layerIndex:-1];
}

+ (instancetype)modelWithText:(NSString *)text
                    layerName:(NSString *)layerName
                   layerIndex:(int)layerIndex {
    return [[self alloc] initWithStyle:(MFMediaViewModelPAGConfigReplaceLayerModelStyleText) text:text image:nil layerName:layerName layerIndex:layerIndex];
}

+ (instancetype)modelWithImage:(UIImage *)image
                     layerName:(NSString *)layerName {
    return [[self alloc] initWithStyle:(MFMediaViewModelPAGConfigReplaceLayerModelStyleImage) text:@"" image:image layerName:layerName layerIndex:-1];
}

+ (instancetype)modelWithImage:(UIImage *)image
                     layerName:(NSString *)layerName
                    layerIndex:(int)layerIndex {
    return [[self alloc] initWithStyle:(MFMediaViewModelPAGConfigReplaceLayerModelStyleImage) text:@"" image:image layerName:layerName layerIndex:layerIndex];
}

+ (instancetype)modelWithImage:(UIImage *)image
                     layerName:(NSString *)layerName
                    layerIndex:(int)layerIndex
                  isSpecialBMP:(BOOL)isSpecialBMP {
    return [[self alloc] initWithStyle:(MFMediaViewModelPAGConfigReplaceLayerModelStyleImage) text:@"" image:image layerName:layerName layerIndex:layerIndex isSpecialBMP:isSpecialBMP];
}

@end


@interface MFMediaViewModelPAGConfig ()

@property (nonatomic, assign) float aniamteDuring;

@end


@implementation MFMediaViewModelPAGConfig { }


+ (instancetype)defaultConfigure {
    MFMediaViewModelPAGConfig *configure = [[MFMediaViewModelPAGConfig alloc] init];
    //    @property (nonatomic, assign) NSUInteger repeatCount;
    //    @property (nonatomic, assign) MFMediaViewModelPAGConfigStyleScaleMode scaleMode;
    /**
     * 最大渲染的帧率，默认60帧
     * 若该帧数低于文件帧数，会丢失部分画面，
     * 若该帧数高于文件帧数，无影响
     */
    //    @property (nonatomic, assign) NSUInteger maxFrameRate;
    
    configure.repeatCount = 0;
    configure.scaleMode = MFMediaViewModelPAGConfigStyleScaleModeAspectToFit;
    configure.maxFrameRate = 60;
    configure.isAutoPlay = YES;
    
    return configure;
}


- (void)configModelWithFile:(PAGFile *)file {
    self.aniamteDuring = file.duration;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.repeatCount=%lu", self.repeatCount];
    [description appendFormat:@", self.scaleMode=%ld", (long)self.scaleMode];
    [description appendFormat:@", self.maxFrameRate=%lu", self.maxFrameRate];
    [description appendString:@">"];
    return description;
}

- (NSMutableArray<MFMediaViewModelPAGConfigReplaceLayerModel *> *)replaceLayerList {
    if (!_replaceLayerList) {
        _replaceLayerList = [NSMutableArray array];
    }
    return _replaceLayerList;
}

- (NSMutableArray<MFMediaViewModelPAGConfigTransformLayerModel *> *)transformLayerList {
    if (!_transformLayerList) {
        _transformLayerList = [NSMutableArray array];
    }
    return _transformLayerList;
}

@end
