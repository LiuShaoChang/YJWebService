//
//  YJBatchRequest.h
//  YJWebService
//
//  Created by 刘少昌 on 2018/9/7.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YJRequestProtocols.h"

@interface YJBatchRequest : NSObject
@property (nonatomic, strong) NSArray<YJBaseRequest*> *requestArray;
@property (nonatomic, weak) id<YJBatchRequestCallBackDelegate> callBackDelegate;

- (void)start;
- (void)cancel;

@end
