//
//  YJBaseRequest.m
//  YJWebService
//
//  Created by 刘少昌 on 2018/8/29.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import "YJBaseRequest.h"
#import "YJRequestProxy.h"

@interface YJBaseRequest ()

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite) id responseObject;
@property (nonatomic, strong, readwrite, nullable) NSError *requestError;
@property (nonatomic, copy, readwrite, nullable) NSString *errorMessage;

@end

@implementation YJBaseRequest

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(YJRequestBaseDelegate)]) {
            _childRequest = (id<YJRequestBaseDelegate>)self;
        }else {
            NSAssert(NO, @"Request object doesn't conforms to YJRequestBaseDelegate protocol");
        }
        
    }
    return self;
}

- (void)start {
    if ([self.callBackDelegate respondsToSelector:@selector(requestWillStart:)]) {
        [self.callBackDelegate requestWillStart:self.childRequest];
    }
    [[YJRequestProxy sharedProxy] loadRequest:self.childRequest];
    
}

- (void)cancel {
    
    [[YJRequestProxy sharedProxy] cancelRequest:self.childRequest];
    if ([self.callBackDelegate respondsToSelector:@selector(requestDidFailed:)]) {
        [self.callBackDelegate requestDidFailed:self.childRequest];
    }
}

@end
