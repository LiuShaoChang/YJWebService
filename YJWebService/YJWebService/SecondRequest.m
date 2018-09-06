//
//  SecondRequest.m
//  YJWebService
//
//  Created by 刘少昌 on 2018/9/5.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import "SecondRequest.h"
#import "YJRequestParser.h"

@implementation SecondRequest


- (id)requestParams {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"get",@"action",_stucuid,@"user_id", nil];
    if (_gradeid) {
        [param setObject:_gradeid forKey:@"grade_id"];
    }
    if (_page) {
        [param setObject:@(_page) forKey:@"page"];
    }
    return param;
}

- (YJAPIRequstType)requestType {
    return YJAPIRequstTypeGet;
}

- (NSString * _Nonnull)urlPath {
    return @"/api/parents/children/statistic/";
}

- (void)transformDataWithOriginData:(id)originData {
    _dataArr = [YJRequestParser getArrayFromResponse:originData key:@"data"];
}

- (void)dealloc {
    NSLog(@"SecondRequest dealloced------");
}

@end
