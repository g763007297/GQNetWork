//
//  GQNetworkHeader.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/10/10.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#ifndef GQNetworkHeader_h
#define GQNetworkHeader_h

#import "GQDataRequest.h"

#import "GQRequestResult.h"
//使用Block网络请求方法
#import "GQBaseDataRequest+GQBlockCategory.h"
//使用delegate网络请求方法
#import "GQBaseDataRequest+GQDelegateCategory.h"
//上传文件或图片创建字典
#import "GQBaseDataRequest+GQBuildUploadDataCategory.h"

//网络状态判断与流量统计
#import "GQNetworkTrafficManager.h"

//数据解析需要继承
#import "GQBaseRequestDataHandler.h"

#endif /* GQNetworkHeader_h */
