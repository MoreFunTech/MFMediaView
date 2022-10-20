//
//  MFMediaViewFileTypeJudger.m
//  MFMediaView
//
//  Created by Administer on 2022/10/9.
//

#import "MFMediaViewFileTypeJudger.h"

@interface MFMediaViewFileTypeJudger ()

@property (nonatomic, weak) id<MFMediaViewFileTypeJudgerProtocol>mediaTypeEncoderDelegate;

@end

@implementation MFMediaViewFileTypeJudger

+ (void)configureJudgerDelegate:(id<MFMediaViewFileTypeJudgerProtocol>)delegate {
    MFMediaViewFileTypeJudger.share.mediaTypeEncoderDelegate = delegate;
}

+ (id<MFMediaViewFileTypeJudgerProtocol>)mediaTypeEncoder {
    return MFMediaViewFileTypeJudger.share.mediaTypeEncoderDelegate;
}

+ (int)getTypeCodeWithFilePath:(NSString *)filePath {
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (!data) {
//        NSString *newFilePath = [NSString stringWithFormat:@"file://%@", filePath];
        data = [NSData dataWithContentsOfFile:filePath];
    }
    if (!data) {
        return -1;
    }
    if (data.length < 2) {
        return -1;
    }
    int char1 = 0, char2 = 0;
    [data getBytes:&char1 range:NSMakeRange(0, 1)];
    [data getBytes:&char2 range:NSMakeRange(1, 1)];
    NSString *numCode = [NSString stringWithFormat:@"%d%d", char1, char2];
    return [numCode intValue];
    
}


+ (instancetype)share {
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
