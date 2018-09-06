//
//  YJRequestProxy.h
//  YJWebService
//
//  Created by 刘少昌 on 2018/8/30.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import <Foundation/Foundation.h>
// the point of this class is that to handle network request centrally so that you can change some important method when you want to replace 'AFNetworking' with other network library

@class YJBaseRequest;
@interface YJRequestProxy : NSObject

+ (instancetype)sharedProxy;
// add request to request list and start it
- (void)loadRequest:(YJBaseRequest *)request;
// cancel request that was previously added and remove it from request list
- (void)cancelRequest:(YJBaseRequest *)request;
// cancel all requests
- (void)cancelAllRequests;

@end
