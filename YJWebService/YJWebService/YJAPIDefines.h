//
//  YJAPIDefines.h
//  YJWebService
//
//  Created by 刘少昌 on 2018/8/29.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#ifndef YJAPIDefines_h
#define YJAPIDefines_h

#if DEBUG
static NSString *const kBaseUrl = @"https://qa.zgyjyx.net";
static NSString *const kCdnUrl = @"http://oivj4vcuo.bkt.clouddn.com/";
#else
static NSString *const kBaseUrl = @"https://www.zgyjyx.com";
static NSString *const kCdnUrl = @"http://cdn-web-img.zgyjyx.com/"
#endif
//*****************************************************
static NSString *const kNotificationSessionExpired = @"example";
static NSInteger const kWebApiErrorSessionExpired = 9099;
static NSInteger const kCodeSessionExpired = 99;
static NSInteger const kCodeNotLoggedIn = 302;
static NSInteger const kCodeSuccess = 0;

#endif /* YJAPIDefines_h */
