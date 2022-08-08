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

@end
