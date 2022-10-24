//
//  MFMediaViewPlayerImage.h
//  MFMediaView
//
//  Created by Administer on 2022/10/24.
//

#import <Foundation/Foundation.h>

@class MFMediaViewImageView;

NS_ASSUME_NONNULL_BEGIN

@interface MFMediaViewPlayerImage : NSObject

@property(nonatomic, weak) MFMediaViewImageView *imageView;

- (void)configureImageView:(MFMediaViewImageView * _Nullable)imageView;

@end

NS_ASSUME_NONNULL_END
