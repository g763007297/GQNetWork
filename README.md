[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/angelcs1990/GQImageViewer/master/LICENSE)&nbsp;
[![](https://img.shields.io/badge/platform-iOS-brightgreen.svg)](http://cocoapods.org/?q=GQImageViewer)&nbsp;
[![support](https://img.shields.io/badge/support-iOS5.0%2B-blue.svg)](https://www.apple.com/nl/ios/)&nbsp;

# GQNetWork

继承形式的网络请求库，支持关系映射，支持NSURLSession

### Simple Use

##CocoaPods

1.在 Podfile 中添加 pod 'GQNetWork'。

2.执行 pod install 或 pod update。

3.添加一个类继承GQDataRequest，详见demo

## Configure File

GQCommonMacros中有配置文件

1.  配置默认请求地址:GQHttpReuqestURL   

2.  默认请求host:REQUEST_HOST  

3. 是否使用maskview: GQUSE_MaskView

4. 是否使用假数据:GQUSE_DUMPY_DATA

5.加载默认提示文字:DEFAULT_LOADING_MESSAGE

## Basic usage

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

### Hard Use



在iOS9以上的系统需要添加plist字段，否则无法发起请求:
  
  <key>NSAppTransportSecurity</key>
  
	<dict>
	
		<key>NSAllowsArbitraryLoads</key>
		
		<true/>
		
	</dict>
		
	欢迎指出错误的方法或者需要改善的地方。联系qq：763007297
