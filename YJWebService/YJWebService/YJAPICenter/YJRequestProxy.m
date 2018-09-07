//
//  YJRequestProxy.m
//  YJWebService
//
//  Created by 刘少昌 on 2018/8/30.
//  Copyright © 2018年 YJYX. All rights reserved.
//

#import "YJRequestProxy.h"
#import "YJBaseRequest.h"
#import <pthread/pthread.h>
#import "YJRequestHelper.h"
#import "YJRequestDefaultConfig.h"
#import "YJBaseRequest+Setter.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)


static NSString * const GET = @"GET";
static NSString * const POST = @"POST";
static NSString * const PUT = @"PUT";
static NSString * const HEAD = @"GET";
static NSString * const DELETE = @"POST";
static NSString * const PATCH = @"PUT";

@interface YJRequestProxy ()
{
    pthread_mutex_t _lock;
    NSMutableDictionary<NSNumber *,YJBaseRequest *> *_requestTable;
}
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) AFJSONResponseSerializer *jsonResponseSerializer;
@property (nonatomic, strong) AFXMLParserResponseSerializer *xmlResponseSerializer;

@end

@implementation YJRequestProxy

#pragma mark - life cycle

+ (instancetype)sharedProxy {
    static YJRequestProxy *proxy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        proxy = [[YJRequestProxy alloc] init];
    });
    return proxy;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        _requestTable = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - public
- (void)loadRequest:(YJBaseRequest *)request {
    NSAssert(request != nil, @"request should not be nil");
    NSError * __autoreleasing error = nil;
    request.requestTask = [self sessionTaskForRequest:request error:&error];
    if (error) {
        return;
    }
    NSAssert(request.requestTask != nil, @"request.requestTask should not be nil");
    [self addRequestToRequestTable:request];
    [request.requestTask resume];
    if ([request.callBackDelegate respondsToSelector:@selector(requestDidStarted:)]) {
        [request.callBackDelegate requestDidStarted:request.childRequest];
    }
    
}

- (void)cancelRequest:(YJBaseRequest *)request {
    NSAssert(request != nil, @"request should not be nil");
    [request.requestTask cancel];
    [self removeRequestFromRequestTable:request];
    
}

- (void)cancelAllRequests {
    Lock();
    NSArray *allKeys = _requestTable.allKeys;
    Unlock();
    for (NSNumber *key in allKeys) {
        YJBaseRequest *request = _requestTable[key];
        [self cancelRequest:request];
    }
}


#pragma mark - private
- (void)addRequestToRequestTable:(YJBaseRequest *)request {
    Lock();
    _requestTable[@(request.requestTask.taskIdentifier)] = request;
    Unlock();
}

- (void)removeRequestFromRequestTable:(YJBaseRequest *)request {
    Lock();
    [_requestTable removeObjectForKey:@(request.requestTask.taskIdentifier)];
    Unlock();
}

- (NSURLSessionTask *)sessionTaskForRequest:(YJBaseRequest *)request error:(NSError *_Nullable __autoreleasing *)error {
    
    YJAPIRequstType requestType = [(id<YJRequestBaseDelegate>)request requestType];
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    NSString *urlString = [self urlStringWithRequest:request];
    id params = [(id<YJRequestBaseDelegate>)request requestParams];
    
    switch (requestType) {
        case YJAPIRequstTypeGet:
            return [self dataTaskWithRequestSerializer:requestSerializer method:GET URLString:urlString parameters:params error:error];
        case YJAPIRequstTypePost:
            return [self dataTaskWithRequestSerializer:requestSerializer method:POST URLString:urlString parameters:params error:error];
        case YJAPIRequstTypePut:
            return [self dataTaskWithRequestSerializer:requestSerializer method:PUT URLString:urlString parameters:params error:error];
        case YJAPIRequstTypeHead:
            return [self dataTaskWithRequestSerializer:requestSerializer method:HEAD URLString:urlString parameters:params error:error];
        case YJAPIRequstTypeDelete:
            return [self dataTaskWithRequestSerializer:requestSerializer method:DELETE URLString:urlString parameters:params error:error];
        case YJAPIRequstTypePatch:
            return [self dataTaskWithRequestSerializer:requestSerializer method:PATCH URLString:urlString parameters:params error:error];
        default:
            break;
    }
    
    
}

- (AFHTTPRequestSerializer *)requestSerializerForRequest:(YJBaseRequest *)request {
    
    AFHTTPRequestSerializer *requestSerializer = nil;
    if ([(id<YJRequestBaseDelegate>)request respondsToSelector:@selector(requestSerializerType)]) {
        YJRequestSerializerType type = [(id<YJRequestBaseDelegate>)request requestSerializerType];
        if (type == YJRequestSerializerTypeHTTP) {
            requestSerializer = [AFHTTPRequestSerializer serializer];
        }else if (type == YJRequestSerializerTypeJSON) {
            requestSerializer = [AFJSONRequestSerializer serializer];
        }
    }else {
        requestSerializer = [YJRequestDefaultConfig sharedConfig].requestSerializer;
    }
    if ([(id<YJRequestBaseDelegate>)request respondsToSelector:@selector(timeoutInterval)]) {
        requestSerializer.timeoutInterval = [(id<YJRequestBaseDelegate>)request timeoutInterval];
    }else {
        requestSerializer.timeoutInterval = [YJRequestDefaultConfig sharedConfig].timeoutInterval;
    }
    if ([(id<YJRequestBaseDelegate>)request respondsToSelector:@selector(allowCellularAccess)]) {
        requestSerializer.allowsCellularAccess = [(id<YJRequestBaseDelegate>)request allowCellularAccess];
    }else {
        requestSerializer.allowsCellularAccess = [YJRequestDefaultConfig sharedConfig].allowCellularAccess;
    }
    if ([(id<YJRequestBaseDelegate>)request respondsToSelector:@selector(authorizationHeaderFieldWithUsernameAndPassword)]) {
        NSArray *array = [(id<YJRequestBaseDelegate>)request authorizationHeaderFieldWithUsernameAndPassword];
        [requestSerializer setAuthorizationHeaderFieldWithUsername:array.firstObject password:array.lastObject];
    }
    if ([(id<YJRequestBaseDelegate>)request respondsToSelector:@selector(requestHeaderFieldValueDictionary)]) {
        NSDictionary *headerFieldDic = [(id<YJRequestBaseDelegate>)request requestHeaderFieldValueDictionary];
        for (NSString *httpHeaderField in headerFieldDic.allKeys) {
            NSString *value = headerFieldDic[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    
    return requestSerializer;
    
}

- (NSString *)urlStringWithRequest:(YJBaseRequest *)request {
    NSString *urlString = nil;
    urlString = [[YJRequestDefaultConfig sharedConfig].baseURL stringByAppendingString:[(id<YJRequestBaseDelegate>)request urlPath]];
    return urlString;
}


- (NSURLSessionDataTask *)dataTaskWithRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                                 method:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:(nullable id)parameters
                                                  error:(NSError * _Nullable __autoreleasing *)error {
    
    NSMutableURLRequest *request = [self requestWithRequestSerializer:requestSerializer method:method URLString:URLString parameters:parameters error:error];
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self handleDataTaskResponse:dataTask urlResponse:response responseObject:responseObject error:error];
    }];
    return dataTask;
    
}

- (void)handleDataTaskResponse:(NSURLSessionDataTask *)dataTask
                   urlResponse:(NSURLResponse *_Nonnull)response
                responseObject:(id _Nullable)responseObject
                         error:(NSError *_Nullable)error {
    
    Lock();
    YJBaseRequest *request = _requestTable[@(dataTask.taskIdentifier)];
    Unlock();
    if (!request) {
        return;
    }
    NSError * __autoreleasing serializerError = nil;
    request.responseObject = responseObject;
    
    if ([request.responseObject isKindOfClass:[NSData class]]) {
        YJResponseSerializerType type = YJResponseSerializerTypeHTTP;
        if ([(id<YJRequestBaseDelegate>)request respondsToSelector:@selector(responseSerializerType)]) {
            type = [(id<YJRequestBaseDelegate>)request responseSerializerType];
        }else {
            type = [YJRequestDefaultConfig sharedConfig].responseSerializerType;
        }
        switch (type) {
            case YJResponseSerializerTypeHTTP:
                break;
            case YJResponseSerializerTypeJSON:
                request.responseObject = [self.jsonResponseSerializer responseObjectForResponse:response data:request.responseObject error:&serializerError];
                break;
            case YJResponseSerializerTypeXMLParser:
                request.responseObject = [self.xmlResponseSerializer responseObjectForResponse:response data:request.responseObject error:&serializerError];
            default:
                break;
        }
    }
    
    BOOL success = YES;
    NSError *requestError = nil;
    NSError * __autoreleasing validateError = nil;
    
    if (error) {
        success = NO;
        requestError = error;
    }else if (serializerError) {
        success = NO;
        requestError = serializerError;
    }else {
        if ([YJRequestDefaultConfig sharedConfig].validateDelegate && [[YJRequestDefaultConfig sharedConfig].validateDelegate respondsToSelector:@selector(validateWithRequest:validateError:)]) {
            success = [[YJRequestDefaultConfig sharedConfig].validateDelegate validateWithRequest:request validateError:&validateError];
            requestError = validateError;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (success) {
            [(id<YJRequestBaseDelegate>)request transformDataWithOriginData:request.responseObject];
            if ([request.callBackDelegate respondsToSelector:@selector(requestDidSuccess:)]) {
                [request.callBackDelegate requestDidSuccess:request];
            }
            if (request.successBlock) {
                request.successBlock(request);
            }
            
        }else {
            request.requestError = requestError;
            request.errorMessage = requestError.localizedDescription;
            if ([request.callBackDelegate respondsToSelector:@selector(requestDidFailed:)]) {
                [request.callBackDelegate requestDidFailed:request];
            }
            if (request.failureBlock) {
                request.failureBlock(request);
            }
        }
        [self removeRequestFromRequestTable:request];
        [self breakRetainCycleBlockWithRequest:request];
    });
    
}

- (void)breakRetainCycleBlockWithRequest:(YJBaseRequest *)request {
    request.successBlock = nil;
    request.failureBlock = nil;
}

- (NSMutableURLRequest *)requestWithRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                               method:(NSString *)method
                                            URLString:(NSString *)URLString
                                           parameters:(nullable id)parameters
                                                error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableURLRequest *request = nil;
    request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
    return request;
}




- (NSURL *)incompleteDownloadTempPathForDownloadPath:(NSString *)downloadPath {
    NSString *md5URLString = [YJRequestHelper md5StringFromString:downloadPath];
    NSString *tmpPath = [[YJRequestHelper yj_incompleteDownloadTempCacheFolder] stringByAppendingPathComponent:md5URLString];
    NSURL *urlPath = [NSURL fileURLWithPath:tmpPath];
    return urlPath;
    
}

#pragma mark - getter
- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _sessionManager;
}

- (AFJSONResponseSerializer *)jsonResponseSerializer {
    if (!_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _jsonResponseSerializer;
}

- (AFXMLParserResponseSerializer *)xmlResponseSerializer {
    if (!_xmlResponseSerializer) {
        _xmlResponseSerializer = [AFXMLParserResponseSerializer serializer];
    }
    return _xmlResponseSerializer;
}

@end
