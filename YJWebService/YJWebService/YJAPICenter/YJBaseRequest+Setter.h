//
//  YJBaseRequest+Setter.h
//  YJWebService
//
//  Created by 刘少昌 on 2018/9/5.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import "YJBaseRequest.h"

@interface YJBaseRequest ()

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite) id responseObject;
@property (nonatomic, strong, readwrite, nullable) NSError *requestError;
@property (nonatomic, copy, readwrite, nullable) NSString *errorMessage;

@end
