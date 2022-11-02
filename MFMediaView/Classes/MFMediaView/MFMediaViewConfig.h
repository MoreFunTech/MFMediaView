//
//  MFMediaViewConfig.h
//  MFMediaView
//
//  Created by Administer on 2022/11/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFMediaViewConfig : NSObject

+ (void)configDebugMode:(BOOL)isDebug;

+ (BOOL)isCurrentDebugMode;

@end

NS_ASSUME_NONNULL_END
