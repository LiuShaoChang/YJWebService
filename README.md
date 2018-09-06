# YJWebService
This is a network library based on AFNetWorking,it's also my exploration of POP(Protocol Oriented Programming) design pattern at the same time.

## Usage
1. Set common baseUrl and validateDelegate(you don't have to set,but you can do some validate and deal some error in this class based on your Project requirements if you do)
```
[YJRequestDefaultConfig sharedConfig].baseURL = kBaseUrl;
[YJRequestDefaultConfig sharedConfig].validateDelegate = [[YJRequestValidator alloc] init];
```
2. Create subclass of `YJBaseRequest` and confirms to `YJBaseDelegate`
```
@interface DemoRequest : YJBaseRequest<YJRequestBaseDelegate>
@end

@implementation DemoRequest
- (id)requestParams {
    return @{};
}

- (YJAPIRequstType)requestType {
    return YJAPIRequstTypePost;
}

- (NSString * _Nonnull)urlPath {
    return @"/api/parents/example/";
}

- (void)transformDataWithOriginData:(id)originData {
    NSLog(@"%@", originData);
}
@end

```
3. Call request
```
[self.drequest start];
```
4. Cancel request
```
[self.drequest cancel];
```
5. More details please refers to demo.
## features
* Protocol Oriented Programming
* High level of expansion
* Set common BaseUrl
* Cancel request
* Delegate callback and Block callback

## 中文说明
这是一个基于AFNetWorking的二次封装,同时也是我对"POP"面向协议设计模式的一种探索.
## 使用
1. 设置baseURL以及validateDelegate(validateDelegate可以不设置,但是如果你设置的话,你可以根据你们项目的需求在该类中做些校检,以及错误处理)
```
[YJRequestDefaultConfig sharedConfig].baseURL = kBaseUrl;
[YJRequestDefaultConfig sharedConfig].validateDelegate = [[YJRequestValidator alloc] init];
```
2. 创建`YJBaseRequest`子类,并遵循`YJBaseDelegate`
```
@interface DemoRequest : YJBaseRequest<YJRequestBaseDelegate>
@end

@implementation DemoRequest
- (id)requestParams {
    return @{};
}

- (YJAPIRequstType)requestType {
    return YJAPIRequstTypePost;
}

- (NSString * _Nonnull)urlPath {
    return @"/api/parents/example/";
}

- (void)transformDataWithOriginData:(id)originData {
    NSLog(@"%@", originData);
}
@end

```
3. 发起请求
```
[self.drequest start];
```
4. 取消请求
```
[self.drequest cancel];
```
5. 更多详情请参考demo
## 特点
* 面向协议设计模式
* 高拓展
* 设置统一的baseURL
* 取消请求
* 代理回调和Block回调


