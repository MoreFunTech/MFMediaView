//
//  MFMediaViewPlayerSvga.h
//  MFMediaView
//
//  Created by Administer on 2022/10/24.
//

#import <Foundation/Foundation.h>

@class MFMediaViewSVGAView;

NS_ASSUME_NONNULL_BEGIN

@interface MFMediaViewPlayerSvga : NSObject

@property(nonatomic, weak) MFMediaViewSVGAView *svgaView;

- (void)configureSvgaView:(MFMediaViewSVGAView * _Nullable)svgaView;

@end

NS_ASSUME_NONNULL_END
