//
//  SecondRequest.h
//  YJWebService
//
//  Created by 刘少昌 on 2018/9/5.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import "YJBaseRequest.h"

@interface SecondRequest : YJBaseRequest<YJRequestBaseDelegate>

@property (nonatomic, strong, nonnull) NSNumber *stucuid;
@property (nonatomic, strong) NSNumber *gradeid;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong, readonly) NSArray *dataArr;

@end
