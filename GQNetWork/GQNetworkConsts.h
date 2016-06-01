//
//  GQNetworkConsts.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#ifndef GQNetworkConsts_h
#define GQNetworkConsts_h

typedef enum {
    GQURLParameterEncoding,             //常规post请求  可有图片
    GQJSONParameterEncoding,            //parameter json化 无图片
    GQURLJSONParameterEncoding          //post请求  但是parameter拼接到url后面  可有图片
} GQParameterEncoding;

typedef enum : NSUInteger{
    GQRequestMethodGet = 0,
    GQRequestMethodPost = 1,           // content type = @"application/x-www-form-urlencoded"
    GQRequestMethodMultipartPost = 2,   // content type = @"multipart/form-data"
} GQRequestMethod;

////////////////////////////////////////////////////////////////////////////////
#pragma mark --  defualt configure

#define GQUSE_MaskView 0    //是否使用加载中视图

#define GQUSE_DUMPY_DATA	0   //是否使用假数据

#define REQUEST_HOST @"123.57.81.80" // 默认host

#define GQHttpReuqestURL @"http://123.57.81.80:3001/"

#define DEFAULT_LOADING_MESSAGE  @"正在加载..."   //正在加载maskview显示的默认文字

////////////////////////////////////////////////////////////////////////////////

#pragma mark - shortcuts

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define DATA_ENV [GQDataEnvironment sharedDataEnvironment]

////////////////////////////////////////////////////////////////////////////////
#pragma mark - common functions

#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

////////////////////////////////////////////////////////////////////////////////
#pragma mark - degrees/radian functions

#define degreesToRadian(x) (M_PI * (x) / 180.0)

#define radianToDegrees(radian) (radian*180.0)/(M_PI)

////////////////////////////////////////////////////////////////////////////////


#endif /* GQNetworkConsts_h */
