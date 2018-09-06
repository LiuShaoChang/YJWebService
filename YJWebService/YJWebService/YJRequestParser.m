//
//  YJRequestParser.m
//  YJWebService
//
//  Created by 刘少昌 on 2018/9/5.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import "YJRequestParser.h"

@implementation YJRequestParser

+ (NSInteger)getReturnCodeFromResponse:(id)responseObject {
    NSNumber *returnCode = [self getObjectFromResponse:responseObject key:@"retcode"];
    if (returnCode != nil && ([returnCode isKindOfClass:[NSNumber class]] || [returnCode isKindOfClass:[NSString class]])) {
        NSInteger code = [returnCode integerValue];
        return code;
    }
    return NSNotFound;
}

+ (NSString *)getReturnMessageFromResponse:(id)responseObject {
    NSString *message = [self getObjectFromResponse:responseObject key:@"msg"];
    if (message != nil) {
        return message;
    }
    else{
        return [self getObjectFromResponse:responseObject key:@"reason"];
    }
}

+ (NSDictionary *)getDictionaryFromResponse:(id)responseObject {
    if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)responseObject;
    }
    return nil;
}

+ (NSDictionary *)getDictionaryFromResponse:(id)responseObject key:(NSString *)key {
    NSDictionary *dictionary = [self getDictionaryFromResponse:responseObject];
    if (dictionary != nil){
        return [dictionary objectForKey:key];
    }
    return nil;
}

+ (NSArray *)getArrayFromResponse:(id)responseObject {
    if (responseObject != nil && [responseObject isKindOfClass:[NSArray class]]) {
        return (NSArray *)responseObject;
    }
    return nil;
}

+ (NSArray *)getArrayFromResponse:(id)responseObject key:(NSString *)key {
    NSDictionary *dictionary = [self getDictionaryFromResponse:responseObject];
    if (dictionary != nil){
        NSArray *array = [dictionary objectForKey:key];
        if (array != nil && [array isKindOfClass:[NSArray class]]) {
            return array;
        }
    }
    return nil;
}

+ (id)getObjectFromResponse:(id)responseObject key:(NSString *)key {
    NSDictionary *dictionary = [self getDictionaryFromResponse:responseObject];
    if (dictionary != nil){
        return [dictionary objectForKey:key];
    }
    return nil;
}

@end
