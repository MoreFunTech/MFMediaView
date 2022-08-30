//
//  MFMediaViewModelSVGAConfig.m
//  MFMediaView
//
//  Created by Neal on 2022/8/8.
//

#import "MFMediaViewModelSVGAConfig.h"

@implementation MFMediaViewModelSVGAConfig



+ (instancetype)defaultConfigure {
    MFMediaViewModelSVGAConfig *svgaConfigure = [[MFMediaViewModelSVGAConfig alloc] init];
    svgaConfigure.contentMode = UIViewContentModeScaleAspectFit;
    svgaConfigure.repeatCount = 0;
    svgaConfigure.clearsAfterStop = NO;
    return svgaConfigure;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.contentMode=%d", self.contentMode];
    [description appendFormat:@", self.repeatCount=%lu", self.repeatCount];
    [description appendFormat:@", self.clearsAfterStop=%d", self.clearsAfterStop];
    [description appendFormat:@", self.svgaPlayerDidFinishedAnimation=%p", self.svgaPlayerDidFinishedAnimation];
    [description appendString:@">"];
    return description;
}


@end
