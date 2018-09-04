//
//  GQRequestParameter.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/31.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQDataCacheManager.h"

@interface GQRequestParameter : NSObject

@property (nonatomic, copy)     NSString *subRequestUrl;//拼接使用的URL

@property (nonatomic, copy)     NSDictionary *parameters;//请求参数

@property (nonatomic, copy)     NSArray *uploadDatas;//上传文件数组  如果只有一个文件并且不需要指定contentype时可以放在parameters里面   使用 GQBuildUploadDataCategory 中两个方法创建

@property (nonatomic, copy)     NSDictionary *headerParameters;//请求头参数

@property (nonatomic, strong)   UIView *indicatorView;//加载框的父视图

@property (nonatomic, copy)     NSString *loadingMessage;//加载消息

@property (nonatomic, copy)     NSString *cancelSubject;//NSNotificationCenter 取消请求的key

@property (nonatomic, copy)     NSString *cacheKey;//缓存key

@property (nonatomic, assign)   GQDataCacheManagerType cacheType;//缓存类型

@property (nonatomic, copy)     NSString *localFilePath;//文件下载的位置

@end
