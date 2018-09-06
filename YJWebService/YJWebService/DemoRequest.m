//
//  DemoRequest.m
//  YJWebService
//
//  Created by 刘少昌 on 2018/9/3.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import "DemoRequest.h"

@implementation DemoRequest

- (id)requestParams {
    return @{};
}

- (YJAPIRequstType)requestType {
    return YJAPIRequstTypePost;
}

- (NSString * _Nonnull)urlPath {
    return @"/api/parents/login/";
}

- (void)transformDataWithOriginData:(id)originData {
    NSLog(@"%@", originData);
}




@end
