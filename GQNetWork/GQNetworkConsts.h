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
    GQRequestMethodPut = 3,
    GQRequestMethodDelete = 4,
} GQRequestMethod;

////////////////////////////////////////////////////////////////////////////////

#pragma mark - shortcuts

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define DATA_ENV [GQDataEnvironment sharedDataEnvironment]

////////////////////////////////////////////////////////////////////////////////
#pragma mark - common functions

#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

////////////////////////////////////////////////////////////////////////////////


#endif /* GQNetworkConsts_h */
