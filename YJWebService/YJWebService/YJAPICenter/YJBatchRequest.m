//
//  YJBatchRequest.m
//  YJWebService
//
//  Created by 刘少昌 on 2018/9/7.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import "YJBatchRequest.h"
#import "YJBaseRequest.h"

@interface YJBatchRequest ()<YJRequestCallBackDelegate>

@property (nonatomic, assign) NSInteger count;

@end

@implementation YJBatchRequest


- (void)start {
    _count = 0;
    if (self.callBackDelegate && [self.callBackDelegate respondsToSelector:@selector(batchRequestWillStart:)]) {
        [self.callBackDelegate batchRequestWillStart:self];
    }
    for (YJBaseRequest *request in self.requestArray) {
        request.callBackDelegate = self;
        [request start];
    }
    if (self.callBackDelegate && [self.callBackDelegate respondsToSelector:@selector(batchRequestDidStarted:)]) {
        [self.callBackDelegate batchRequestDidStarted:self];
    }
    
}

- (void)cancel {
    for (YJBaseRequest *request in self.requestArray) {
        [request cancel];
    }
    if (self.callBackDelegate && [self.callBackDelegate respondsToSelector:@selector(batchRequestDidFailed:)]) {
        [self.callBackDelegate batchRequestDidFailed:self];
    }
    _count = 0;
}

#pragma mark - YJRequestCallBackDelegate
- (void)requestDidSuccess:(YJBaseRequest *)request {
    _count++;
    if (_count == _requestArray.count && self.callBackDelegate && [self.callBackDelegate respondsToSelector:@selector(batchRequestDidSuccess:)]) {
        [self.callBackDelegate batchRequestDidSuccess:self];
        _count = 0;
    }
}

- (void)requestDidFailed:(YJBaseRequest *)request {
    [self cancel];
}


@end
