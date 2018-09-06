//
//  YJRequestValidator.m
//  YJWebService
//
//  Created by 刘少昌 on 2018/9/4.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import "YJRequestValidator.h"
#import "YJAPIDefines.h"
#import "YJRequestDefaultConfig.h"
#import "YJBaseRequest.h"
#import "YJRequestParser.h"

@implementation YJRequestValidator

- (BOOL)validateWithRequest:(YJBaseRequest *)request validateError:(NSError *__autoreleasing  _Nullable *)validateError {
    
    BOOL success = YES;
    if (validateError) {
        *validateError = [self getServiceErrorFromResponse:request.responseObject];
        if (*validateError) {
            success = NO;
        }
    }
    return success;
    
}


#pragma mark - 错误处理
- (NSError *)getServiceErrorFromResponse:(id)responseObject {
    NSInteger returnCode = [YJRequestParser getReturnCodeFromResponse:responseObject];
    if (returnCode == kCodeSuccess || returnCode == NSNotFound) {
        return nil;
    }
    else {
        if (returnCode == kCodeSessionExpired || returnCode == kCodeNotLoggedIn) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSessionExpired object:nil];
            return [self getSessionExpiredError];
        }else {
            NSString *returnMessage = [YJRequestParser getReturnMessageFromResponse:responseObject];
            if (returnMessage != nil) {
                return [NSError errorWithDomain:[YJRequestDefaultConfig sharedConfig].baseURL code:returnCode userInfo:@{NSLocalizedDescriptionKey:returnMessage}];
            }
            else{
                return [self getParsingError];
            }
        }
    }
}

- (NSError *)getParsingError {
    return [NSError errorWithDomain:[YJRequestDefaultConfig sharedConfig].baseURL code:NSURLErrorCannotParseResponse userInfo:@{NSLocalizedDescriptionKey:@"数据无法解析"}];
}

- (NSError *)getSessionExpiredError {
    return [NSError errorWithDomain:[YJRequestDefaultConfig sharedConfig].baseURL code:kWebApiErrorSessionExpired userInfo:@{NSLocalizedDescriptionKey:@"需要重新登录"}];
}


@end
