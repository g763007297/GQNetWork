//
//  DemoHttpRequest.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/31.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "DemoHttpRequest.h"
#import "DemoNetworkConsts.h"
#import "GQRequestDataHandleHeader.h"

@implementation DemoHttpRequest

- (NSString*)getRequestUrl
{
    return @"";
}

- (NSString *)getBaseUrl{
    return GQHttpReuqestURL;
}

-(GQParameterEncoding)getParameterEncoding
{
    return GQURLJSONParameterEncoding;
}

- (GQRequestMethod)getRequestMethod
{
    return GQRequestMethodPost;
}

@end

@implementation TestRequestHandlerHttpRequest

- (NSString *)getRequestUrl{
    return @"";
}

- (NSString *)getBaseUrl{
    return @"";
}

- (GQRequestDataHandler *)generateRequestHandler{
    return nil;
}

@end
