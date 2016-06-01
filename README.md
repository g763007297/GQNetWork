[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/angelcs1990/GQImageViewer/master/LICENSE)&nbsp;
[![](https://img.shields.io/badge/platform-iOS-brightgreen.svg)](http://cocoapods.org/?q=GQImageViewer)&nbsp;
[![support](https://img.shields.io/badge/support-iOS5.0%2B-blue.svg)](https://www.apple.com/nl/ios/)&nbsp;

# GQNetWork

继承形式的网络请求框架，一步到位，自带关系映射(Mapping)，支持流量统计，请求数据缓存机制

# Simple Use

##CocoaPods

1.在 Podfile 中添加 pod 'GQNetWork'。

2.执行 pod install 或 pod update。

3.添加一个类继承GQDataRequest，详见demo。

## Configure File

GQCommonMacros中有配置文件

1.  配置默认请求地址:GQHttpReuqestURL   

2.  默认请求host:REQUEST_HOST  

3. 是否使用maskview: GQUSE_MaskView

4. 是否使用假数据:GQUSE_DUMPY_DATA

5. 加载默认提示文字:DEFAULT_LOADING_MESSAGE

## Basic Usage

1.将GQNetWork文件夹加入到工程中。(详见demo)

2.添加一个类继承GQDataRequest，在继承类里面的.m文件中覆盖以下基本方法就可以在需要使用的页面中发起请求:

``` objc

  //请求的url
  - (NSString*)getRequestUrl;
  //请求方法
  - (GQRequestMethod)getRequestMethod;
  //使用假数据
  - (BOOL)useDumpyData;
  
``` 

3.在需要发起请求的页面 引入继承类,添加使用block的请求方法（如需要使用delegate或者其他方法 详见GQBaseDataRequest头文件）:

```objc
[DemoHttpRequest requestWithOnRequestFinished:^(GQBaseDataRequest *request, GQMappingResult *result) {
        NSLog(@"%@",result.rawDictionary);
    } onRequestFailed:^(GQBaseDataRequest *request, NSError *error) {
        NSLog(@"%@",error);
    }];
```

# Hard Use

前面配置和Simple Use一样，还有高级用法:


## 关系映射  举个🌰

（1）如果后台传给我的数据是这样的:

```objc

{
    message = "执行成功";
    result =     {
        rows =         (
                        {
                course = 0;
                createTime = 1451355631000;
                description = "三文鱼";
                enumId = 4;
                id = 39;
                likes = 19;
                name = "法香三文鱼";
                picUrl = "/nisefile/files/image/2015-12-29/5681edef0cf2a9072bd6be4a.jpg";
                price = 99;
            }
        );
        total = 1;
    };
    success = 1;
}
```
（2）如果我要取rows里面内容的话使用map是一件很简单的事情，配置ProductModel:

```objc
+ (NSDictionary *)attributeMapDictionary{
    return @{@"course":@"course",
             @"createTime":@"createTime",
             @"pDescription":@"description",
             @"enumId":@"enumId",
             @"pId":@"id",
             @"likes":@"likes",
             @"name":@"name",
             @"picUrl":@"picUrl",
             @"price":@"price"};
}

```
(3)在发起请求之间配置ProductModel的map:

```objc

GQObjectMapping *map = [[GQObjectMapping alloc]initWithClass:[ProductModel class]];

[map addPropertyMappingsFromDictionary:[ProductModel attributeMapDictionary]];
    
```
（4）将配置好的map传到请求体中再发起请求，不对这样返回的数组为(null)

	```objc
	GQRequestParameter *parameter = [[GQRequestParameter alloc] init];
	
	parameter.mapping = map;
	
	[DemoHttpRequest requestWithRequestParameter:parameter
                                      onRequestStart:nil
                                   onRequestFinished:^(GQBaseDataRequest *request, GQMappingResult *result)
        {
                                       NSLog(@"%@",result.array);//打印出来的就是映射后的数组
        }
                                   onRequestCanceled:nil
                                     onRequestFailed:nil
                                   onProgressChanged:nil];
	```
（5）再改改，是不是发现rows是在字典的里面第2层，这里我们要设置keyPath，因为是使用kvc进行关系映射的，所以改一下后的代码就是下面这样了：

	```objc
    GQRequestParameter *parameter = [[GQRequestParameter alloc] init];
    
    GQObjectMapping *map = [[GQObjectMapping alloc]initWithClass:[ProductModel class]];//进行map的初始化，必须穿我们要映射的class
    
    [map addPropertyMappingsFromDictionary:[ProductModel attributeMapDictionary]];//往我们的map中加映射规则
    
    parameter.keyPath = @"result/rows";//需要map的层级
    
    parameter.mapping = map;
    
    [DemoHttpRequest requestWithRequestParameter:parameter
                                  onRequestStart:nil
                               onRequestFinished:^(GQBaseDataRequest *request, GQMappingResult *result){
                                   NSLog(@"%@",result.rawDictionary);
                                   NSLog(@"%@",result.array);
                               }
                               onRequestCanceled:nil
                                 onRequestFailed:nil
                               onProgressChanged:nil];
	```
（6）这样我们打印的数组就是下面这样了，到此我们圆满的完成了这个请求并拿到了想要的数据：

```objc
(
    "ProductModel:{ [course=0]  [pDescription=nil]  [enumId=4]  [picUrl=/nisefile/files/image/2015-12-29/5681edef0cf2a9072bd6be4a.jpg]  [price=99]  [pId=nil]  [likes=19]  [createTime=1451355631000]  [name=法香三文鱼] }"
  
)
```

#waning

在iOS9以上的系统需要添加plist字段，否则无法发起请求:
  
  <key>NSAppTransportSecurity</key>
  
	<dict>
	
		<key>NSAllowsArbitraryLoads</key>
		
		<true/>
		
	</dict>
		
	欢迎指出错误的方法或者需要改善的地方。联系qq：763007297
