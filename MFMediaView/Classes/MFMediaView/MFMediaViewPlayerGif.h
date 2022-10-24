//
//  MFMediaViewPlayerGif.h
//  MFMediaView
//
//  Created by Administer on 2022/10/24.
//

#import <Foundation/Foundation.h>

@class MFMediaViewGifView;

NS_ASSUME_NONNULL_BEGIN

@interface MFMediaViewPlayerGif : NSObject

@property(nonatomic, weak) MFMediaViewGifView *giftView;

- (void)configureGiftView:(MFMediaViewGifView * _Nullable)giftView;

@end

NS_ASSUME_NONNULL_END
