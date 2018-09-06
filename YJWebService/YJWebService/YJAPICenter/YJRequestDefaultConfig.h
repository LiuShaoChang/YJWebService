//
//  YJRequestDefaultConfig.h
//  YJWebService
//
//  Created by 刘少昌 on 2018/9/1.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJRequestProtocols.h"
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@interface YJRequestDefaultConfig : NSObject

@property (nonatomic, strong, nonnull) NSString *baseURL;
@property (nonatomic, strong) id<YJRequestValidateDelegate> validateDelegate;

@property (nonatomic, strong, readonly) AFHTTPRequestSerializer *requestSerializer;
@property (nonatomic, assign, readonly) YJResponseSerializerType responseSerializerType;
@property (nonatomic, assign, readonly) NSTimeInterval timeoutInterval;
@property (nonatomic, assign, readonly) BOOL allowCellularAccess;

+ (instancetype)sharedConfig;

@end
