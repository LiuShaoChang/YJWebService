//
//  YJRequestHelper.h
//  YJWebService
//
//  Created by 刘少昌 on 2018/8/31.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJRequestHelper : NSObject

+ (NSString *)md5StringFromString:(NSString *)string;
+ (NSString *)yj_incompleteDownloadTempCacheFolder;

@end
