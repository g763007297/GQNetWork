//
//  GQNetwork.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#ifndef GQNetwork_h
#define GQNetwork_h

typedef enum {
    GQURLParameterEncoding,
    GQJSONParameterEncoding,
    GQPropertyListParameterEncoding,
    GQURLJSONParameterEncoding
} GQParameterEncoding;

typedef enum : NSUInteger{
    GQRequestMethodGet = 0,
    GQRequestMethodPost = 1,           // content type = @"application/x-www-form-urlencoded"
    GQRequestMethodMultipartPost = 2,   // content type = @"multipart/form-data"
} GQRequestMethod;

#endif /* GQNetwork_h */
