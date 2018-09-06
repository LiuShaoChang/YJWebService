//
//  YJRequestParser.h
//  YJWebService
//
//  Created by 刘少昌 on 2018/9/5.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJRequestParser : NSObject

+ (NSInteger)getReturnCodeFromResponse:(id)responseObject;
+ (NSString *)getReturnMessageFromResponse:(id)responseObject;
+ (NSDictionary *)getDictionaryFromResponse:(id)responseObject;
+ (NSDictionary *)getDictionaryFromResponse:(id)responseObject key:(NSString *)key;
+ (NSArray *)getArrayFromResponse:(id)responseObject;
+ (NSArray *)getArrayFromResponse:(id)responseObject key:(NSString *)key;
+ (id)getObjectFromResponse:(id)responseObject key:(NSString *)key;

@end
