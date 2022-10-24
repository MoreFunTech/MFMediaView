//
//  MFMediaViewPlayerVideo.h
//  MFMediaView
//
//  Created by Administer on 2022/10/24.
//

#import <Foundation/Foundation.h>

@class MFMediaViewVideoView;

NS_ASSUME_NONNULL_BEGIN

@interface MFMediaViewPlayerVideo : NSObject

@property(nonatomic, weak) MFMediaViewVideoView *videoView;

- (void)configureVideoView:(MFMediaViewVideoView * _Nullable)videoView;

@end

NS_ASSUME_NONNULL_END
