//
//  MFMediaView.h
//  MFMediaView
//
//  Created by Administer on 2022/8/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFMediaViewModel.h"

@interface MFMediaView : UIView

/**
 * 通用媒体模型
 */
@property (nonatomic, strong) MFMediaViewModel *model;

@property (nonatomic, copy) void(^mediaLoadFinishBlock)(MFMediaViewModel *model);

- (void)destroyView;

@end
