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
    GQJSONParameterEncoding             //parameter json化 无图片
} GQParameterEncoding;

typedef enum : NSUInteger{
    GQRequestMethodGet = 1,
    GQRequestMethodPost,           // content type = @"application/x-www-form-urlencoded"
    GQRequestMethodMultipartPost,   // content type = @"multipart/form-data"
    GQRequestMethodPut,
    GQRequestMethodDelete
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
