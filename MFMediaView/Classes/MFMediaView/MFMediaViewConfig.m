//
//  MFMediaViewConfig.m
//  MFMediaView
//
//  Created by Administer on 2022/11/2.
//

#import "MFMediaViewConfig.h"

@interface MFMediaViewConfig ()

@property (nonatomic) BOOL isDebugMode;

@end

@implementation MFMediaViewConfig


+ (void)configDebugMode:(BOOL)isDebug {
    MFMediaViewConfig.shareManager.isDebugMode = isDebug;
}

+ (BOOL)isCurrentDebugMode {
    return MFMediaViewConfig.shareManager.isDebugMode;
}

+ (instancetype)shareManager {
    static id p = nil ;//1.声明一个空的静态的单例对象
    static dispatch_once_t onceToken; //2.声明一个静态的gcd的单次任务
    dispatch_once(&onceToken, ^{ //3.执行gcd单次任务：对对象进行初始化
        if (p == nil) {
            p = [[self alloc] init];
        }
    });
    return p;
}

@end
