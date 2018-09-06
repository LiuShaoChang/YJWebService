//
//  YJRequestHelper.m
//  YJWebService
//
//  Created by 刘少昌 on 2018/8/31.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import "YJRequestHelper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation YJRequestHelper

+ (NSString *)md5StringFromString:(NSString *)string {
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    
    return outputString;
}

+ (NSString *)yj_incompleteDownloadTempCacheFolder {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    static NSString *cacheFolder;
    
    if (!cacheFolder) {
        NSString *cacheDir = NSTemporaryDirectory();
        cacheFolder = [cacheDir stringByAppendingPathComponent:@"yj_incomplete"];
    }
    
    NSError *error = nil;
    BOOL success = [fileManager createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error];
    if(!success) {
        cacheFolder = nil;
    }
    return cacheFolder;
    
}




@end
