//
//  YJBaseRequest.h
//  YJWebService
//
//  Created by 刘少昌 on 2018/8/29.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJRequestProtocols.h"

@interface YJBaseRequest : NSObject


@property (nonatomic, weak, readonly) id<YJRequestBaseDelegate> childRequest;
@property (nonatomic, weak) id<YJRequestCallBackDelegate> callBackDelegate;

@property (nonatomic, copy) YJURLSessionTaskProgressBlock progressBlock;
@property (nonatomic, copy) YJRequestCompletionBlock successBlock;
@property (nonatomic, copy) YJRequestCompletionBlock failureBlock;
@property (nonatomic, strong, readonly) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readonly) id responseObject;
@property (nonatomic, strong, readonly, nullable) NSError *requestError;
@property (nonatomic, copy, readonly, nullable) NSString *errorMessage;


- (void)start;
- (void)cancel;


@end
