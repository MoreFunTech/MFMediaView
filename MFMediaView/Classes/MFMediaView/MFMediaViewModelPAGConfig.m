//
// Created by Neal on 2022/8/8.
//

#import "MFMediaViewModelPAGConfig.h"


@implementation MFMediaViewModelPAGConfig {

}
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

    return configure;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.repeatCount=%lu", self.repeatCount];
    [description appendFormat:@", self.scaleMode=%ld", (long)self.scaleMode];
    [description appendFormat:@", self.maxFrameRate=%lu", self.maxFrameRate];
    [description appendString:@">"];
    return description;
}


@end
