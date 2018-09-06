//
//  YJRequestProtocols.h
//  YJWebService
//
//  Created by 刘少昌 on 2018/8/30.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#ifndef YJRequestProtocols_h
#define YJRequestProtocols_h

#pragma mark - ENUM
// api request type
typedef NS_ENUM(NSUInteger, YJAPIRequstType) {
    YJAPIRequstTypeGet,
    YJAPIRequstTypePost,
    YJAPIRequstTypePut,
    YJAPIRequstTypeDelete,
    YJAPIRequstTypeHead,
    YJAPIRequstTypePatch
};

typedef NS_ENUM(NSInteger, YJRequestSerializerType) {
    YJRequestSerializerTypeHTTP = 0,
    YJRequestSerializerTypeJSON
};

typedef NS_ENUM(NSInteger, YJResponseSerializerType) {
    YJResponseSerializerTypeHTTP,
    YJResponseSerializerTypeJSON,
    YJResponseSerializerTypeXMLParser
};

#pragma mark - BLOCK
@class YJBaseRequest;
typedef void(^YJURLSessionTaskProgressBlock)(NSProgress *progress);
typedef void(^YJRequestCompletionBlock)(__kindof YJBaseRequest *request);

#pragma mark - Delegates
#pragma mark - YJRequestBaseDelegate
//***********************************************************************************
/**
 "YJRequestBaseDelegate" is the base delegate that all YJBaseRequest's child requests should confirms
 */
@protocol YJRequestBaseDelegate <NSObject>

@required

/**
 the urlString should be appended to the "baseUrl"
 */
- (NSString *_Nonnull)urlPath;
- (YJAPIRequstType)requestType;
- (id)requestParams;
- (void)transformDataWithOriginData:(id)originData;

@optional

- (YJRequestSerializerType)requestSerializerType;
- (YJResponseSerializerType)responseSerializerType;
- (NSTimeInterval)timeoutInterval;
- (BOOL)allowCellularAccess;
- (NSArray *)authorizationHeaderFieldWithUsernameAndPassword;
- (NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary;
- (NSString *)resumableDownloadPath;

@end

#pragma mark - YJRequestCallBackDelegate
@protocol YJRequestCallBackDelegate <NSObject>

@optional
- (void)requestWillStart:(YJBaseRequest *)request;
- (void)requestDidStarted:(YJBaseRequest *)request;
- (void)requestIsDownloading:(YJBaseRequest *)request progress:(NSProgress *)progress;
- (void)requestDidSuccess:(YJBaseRequest *)request;
- (void)requestDidFailed:(YJBaseRequest *)request;

@end

#pragma mark - YJRequestValidateDelegate
@protocol YJRequestValidateDelegate <NSObject>

@optional
- (BOOL)validateWithRequest:(YJBaseRequest *)request validateError:(NSError * _Nullable __autoreleasing *)validateError;

@end




#endif /* YJRequestProtocols_h */
