[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/angelcs1990/GQImageViewer/master/LICENSE)&nbsp;
[![](https://img.shields.io/badge/platform-iOS-brightgreen.svg)](http://cocoapods.org/?q=GQImageViewer)&nbsp;
[![support](https://img.shields.io/badge/support-iOS6.0%2B-blue.svg)](https://www.apple.com/nl/ios/)&nbsp;

# GQNetWork

继承形式的网络请求框架，一步到位，支持流量统计，支持https请求，请求数据缓存机制,支持链式调用,支持model版本控制, 支持block，delegate返回请求数据。

##设计图

1.GQNetwork网络请求部分架构图

![GQNetwork网络请求部分架构图](https://github.com/g763007297/GQNetWork/blob/master/Image/GQNetwork网络请求部分架构图.png)

2.GQNetwork数据缓存与解析及其他小模块设计图

![GQNetwork数据缓存与解析及其他小模块设计图](https://github.com/g763007297/GQNetWork/blob/master/Image/GQNetwork数据缓存与解析及其他小模块设计图.png)

# Simple Use

## CocoaPods

1.在 Podfile 中添加 pod 'GQNetWork'。

2.执行 pod install 或 pod update。

3.添加一个类继承GQDataRequest，详见demo。

*注:如果只是需要单独的mapping类的话可以在podfile里面单独添加 pod 'GQMapping'

## Basic Usage

1.将GQNetWork文件夹加入到工程中。(详见demo)

2.添加一个类继承GQDataRequest，在继承类里面的.m文件中覆盖以下基本方法就可以在需要使用的页面中发起请求:

``` objc

  //请求的url
  - (NSString*)getRequestUrl;
	
  //host
  - (NSString *)getBaseUrl;
  
  //请求方法
  - (GQRequestMethod)getRequestMethod;
  
``` 

3.在需要发起请求的页面 引入继承类,添加使用block的请求方法（如需要使用delegate或者其他方法 详见GQBaseDataRequest头文件）:

```objc
 [DemoHttpRequest requestWithOnRequestFinished:^(GQBaseDataRequest *request, GQRequestResult *result) {
        NSLog(@"%@",result.rawResponse);
    } onRequestFailed:^(GQBaseDataRequest *request, NSError *error) {
        NSLog(@"%@",error);
    }];
```

## HTTPS支持

使用类继承GQBaseDataRequest并覆写下面方法

```objc
- (NSData *)getCertificateData
{
	return [NSData dataWithContentsOfFile:证书文件];
}
```

## 自定义数据解析 原始数据->OC对象
1.使用类继承GQBaseDataRequest并覆写下面方法:

```objc
- (GQRequestDataHandler *)generateRequestHandler;
```
2.使用一个自定义类继承于GQRequestDataHandler类,覆写下面方法，在该方法里面实现自己的解析流程:

```objc
- (id)parseDataString:(NSString *)resultString error:(NSError **)error;
```
## 数据缓存

1.通过提供的方法分别传值到cacheKey(缓存key)和cacheType(缓存类型)就可以实现简单的UserDefault或者文件缓存，也可以缓存在内存中。
2.在使用缓存数据中可以通过类继承GQBaseDataRequest并覆写下面方法判断是否使用缓存数据:

```objc
- (BOOL)onReceivedCacheData:(NSObject*)cacheData
```

## 假数据的使用
1.使用类继承GQBaseDataRequest并覆写下面方法返回是否使用假数据，默认为不使用:

```objc
- (BOOL)useDumpyData;
```
2.如果上面方法返回yes使用假数据的话则覆写下面方法返回假数据，默认为json字符串:

```objc
- (NSString*)dumpyResponseString;
```

## 网络状态判断以及网络状态改变通知

1.本框架自带网络状态判断和网络改变通知。
(1)使用下面的方法获取网络状态:

```objc
GQNetworkStatus status = [GQNetworkTrafficManager sharedManager].networkStatus;
```

网络状态分为以下三种:

```objc
typedef NS_ENUM(NSInteger, GQNetworkStatus) {
    GQNotReachable = 0,//无网络链接
    GQReachableViaWiFi=2,//使用wifi链接
    GQReachableViaWWAN=1//使用移动蜂窝网链接
};
```

(2)需要用到网络状态改变的通知时则加上以下代码则可以及时获取到网络状态的改变:

```objc
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange:) name:kGQNetWorkChangedNotification object:nil];

- (void)networkChange:(id)data {
    GQNetworkStatus status = [GQNetworkTrafficManager sharedManager].networkStatus;
}
```

## 加载提示框

1.本框架自带加载提示框，如需使用加载提示框则通过提供的方法将需要显示提示框的父view传到indicatorView。

# Hard Use

前面配置和Simple Use一样，还有高级用法:

 
## 链式调用 全程点语法支持
 
 ```objc
 [DemoHttpRequest1 prepareRequset]
 .requestUrlChain(@"product/list")
 .onFinishedBlockChain(^(GQBaseDataRequest * request, GQMappingResult * result){
     GQDPRINT(@"%@",result.rawResponse);
 })
 .onFailedBlockChain(^(GQBaseDataRequest * request, NSError * error){
    
 })
 .parametersChain(@{})
 .startRequestChain();
 
 ```
  
#warning

在iOS9以上的系统需要添加plist字段，否则无法发起请求:
  
  <key>NSAppTransportSecurity</key>
  
	<dict>
	
		<key>NSAllowsArbitraryLoads</key>
		
		<true/>
		
	</dict>
		

##Support

欢迎指出bug或者需要改善的地方，欢迎提出issues、加Q群交流iOS经验：578841619 ， 我会及时的做出回应，觉得好用的话不妨给个star吧，你的每个star是我持续维护的强大动力。
