//
//  YJRequestDefaultConfig.m
//  YJWebService
//
//  Created by 刘少昌 on 2018/9/1.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import "YJRequestDefaultConfig.h"

@implementation YJRequestDefaultConfig

+ (instancetype)sharedConfig {
    static YJRequestDefaultConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[YJRequestDefaultConfig alloc] init];
    });
    return config;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _requestSerializer = [AFHTTPRequestSerializer serializer];
        _responseSerializerType = YJResponseSerializerTypeJSON;
        _timeoutInterval = 30;
        _allowCellularAccess = YES;
    }
    return self;
}


@end
