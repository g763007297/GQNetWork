//
//  GQRequestParameter.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/31.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQDataCacheManager.h"

@class GQObjectMapping;

@interface GQRequestParameter : NSObject

@property (nonatomic, copy)     NSString *subRequestUrl;//拼接使用的URL

@property (nonatomic, copy)     NSString *keyPath;//mapping所需要的层级

@property (nonatomic, strong)   GQObjectMapping *mapping;//model映射

@property (nonatomic, copy)     NSDictionary *parameters;//请求参数

@property (nonatomic, copy)     NSDictionary *headerParameters;//请求头参数

@property (nonatomic, strong)   UIView *indicatorView;//加载框的父视图

@property (nonatomic, copy)     NSString *loadingMessage;//加载消息

@property (nonatomic, copy)     NSString *cancelSubject;//NSNotificationCenter 取消请求的key

@property (nonatomic, copy)     NSString *cacheKey;//缓存key

@property (nonatomic, assign)   GQDataCacheManagerType cacheType;//缓存类型

@property (nonatomic, copy)     NSString *localFilePath;//文件下载的位置

@end
