//
//  MFMediaViewFileTypeJudger.h
//  MFMediaView
//
//  Created by Administer on 2022/10/9.
//

#import <Foundation/Foundation.h>
#import "MFMediaViewHeader.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MFMediaViewFileTypeJudgerProtocol <NSObject>

+ (MFMediaViewModelStyle)encodeMediaTypeByTypeCode:(int)typeCode;

@end

@interface MFMediaViewFileTypeJudger : NSObject

+ (void)configureJudgerDelegate:(id<MFMediaViewFileTypeJudgerProtocol>)delegate;

+ (int)getTypeCodeWithFilePath:(NSString *)filePath;

+ (id<MFMediaViewFileTypeJudgerProtocol>)mediaTypeEncoder;

@end

NS_ASSUME_NONNULL_END
