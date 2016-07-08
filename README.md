[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/angelcs1990/GQImageViewer/master/LICENSE)&nbsp;
[![](https://img.shields.io/badge/platform-iOS-brightgreen.svg)](http://cocoapods.org/?q=GQImageViewer)&nbsp;
[![support](https://img.shields.io/badge/support-iOS6.0%2B-blue.svg)](https://www.apple.com/nl/ios/)&nbsp;

# GQNetWork

继承形式的网络请求框架，一步到位，自带关系映射(Mapping)，支持流量统计，支持https请求，请求数据缓存机制,支持链式调用,支持model版本控制, 支持block，delegate返回请求数据。

# Simple Use

##CocoaPods

1.在 Podfile 中添加 pod 'GQNetWork'。

2.执行 pod install 或 pod update。

3.添加一个类继承GQDataRequest，详见demo。

*注:如果只是需要单独的mapping类的话可以在podfile里面单独添加 pod 'GQNetWork/Mapping'

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
（2）如果我要取rows里面内容的话使用map是一件很简单的事情，配置ProductModel,如果你的model属性名和后台返回的字段是一样的,   那就不需要配置:

```objc

//像这里的话因为后台返回的字段有id  description 字段, 所以我们定义属性名时就修改了一下，所以需要自己写一下映射关系。
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
 
## 链式调用 全程点语法支持
 
 ```objc
 [DemoHttpRequest1 prepareRequset]
 .requestUrlChain(@"product/list")
 .mappingChain(map)
 .keyPathChain(@"result/rows")
 .onFinishedBlockChain(^(GQBaseDataRequest * request, GQMappingResult * result){
     GQDPRINT(@"%@",result.rawDictionary);
     GQDPRINT(@"%@",result.array);
 })
 .onFailedBlockChain(^(GQBaseDataRequest * request, NSError * error){
    
 })
 .parametersChain(@{})
 .startRequestChain();
 
 ```
## Model版本控制
在开发过程中，对于model中的property修改名称有时候是一件很普遍的事情，但是修改名称之后对于以前版本的兼容有时候就会出现无法映射的现象，所有我们要对model进行版本控制，GQBaseModelObject支持设置修改过的属性名，可以支持不同版本的升级。

###E.g
app1.0版本的一个model中的属性名叫a,升级到1.1之后这个属性名修改为b，这时候我们做版本维护还是很容易的，只要将旧值映射到新的里面就行了；

但是如果升级到1.2之后又修改为c，升级到1.3版本又修改为d的时候，这个中间做版本控制的话就会存在很多种问题，从1.0->1.3,1.0->1.2,1.1->1.3还有好多种情况；

这时候一个合适的版本控制方案就必须要出来了，这时候我们可以通过在继承GQBaseModelObject的model中继承实现一个方法就可以很完美的解决这个问题。

 ```objc
- (NSArray *)versionChangeProperties；

上面那个例子中我们就可以这样做:

1.3版本就实现：

- (NSArray *)versionChangeProperties{
	return @[@"a->b->c->d"];
}

1.2版本就实现：

- (NSArray *)versionChangeProperties{
	return @[@"a->b->c"];
}

1.1版本就实现：

- (NSArray *)versionChangeProperties{
	return @[@"a->b"];
}

 ```
###Tips
1.如果存在多个property名的修改，那就只需要在数组中添加多条就行了。
2.如果中间某个版本删了字段，那就在这个版本中把property变化的干掉.
 
###Final
 到这里我们就完美的实现了每个版本升级对model的version控制，无论多少个版本更改都可以完美适配。
 
#waning

在iOS9以上的系统需要添加plist字段，否则无法发起请求:
  
  <key>NSAppTransportSecurity</key>
  
	<dict>
	
		<key>NSAllowsArbitraryLoads</key>
		
		<true/>
		
	</dict>
		

##Support

欢迎指出bug或者需要改善的地方，欢迎提出issues，或者联系qq：763007297， 我会及时的做出回应。
