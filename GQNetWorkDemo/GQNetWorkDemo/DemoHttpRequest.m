//
//  DemoHttpRequest.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/31.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "DemoHttpRequest.h"
#import "DemoNetworkConsts.h"
#import "GQBaseRequestDataHandler.h"

@implementation DemoHttpRequest

- (NSString*)getRequestUrl
{
    return @"product/list";
}

- (NSString *)getBaseUrl
{
    return GQHttpReuqestURL;
}

- (GQRequestMethod)getRequestMethod
{
    return GQRequestMethodPost;
}

- (BOOL)useDumpyData
{
    return YES;
}

- (NSString *)dumpyResponseString{
    return @"\{\"message\": \"执行成功\",\"result\": {\"rows\": [{\"course\": \"0\",\"createTime\": \"1451355631000\",\"description\": \"三文鱼\",\"enumId\": 4,\"id\": 39,\"likes\": 19,\"name\": \"法香三文鱼\",\"picUrl\": \"/nisefile/files/image/2015-12-29/5681edef0cf2a9072bd6be4a.jpg\",\"price\": NULL}],\"total\": 1},\"success\": 1}";
}

@end

@implementation DemoHttpRequest1

- (NSString*)getRequestUrl
{
    return @"";
}

- (NSString *)getBaseUrl
{
    return GQHttpReuqestURL;
}

- (GQRequestMethod)getRequestMethod
{
    return GQRequestMethodPost;
}

- (BOOL)useDumpyData
{
    return YES;
}

- (NSString *)dumpyResponseString {
    return @"\{\"message\": \"执行成功\",\"result\": {\"rows\": [{\"course\": \"0\",\"createTime\": \"1451355631000\",\"description\": \"三文鱼\",\"enumId\": 4,\"id\": 39,\"likes\": 19,\"name\": \"法香三文鱼\",\"picUrl\": \"/nisefile/files/image/2015-12-29/5681edef0cf2a9072bd6be4a.jpg\",\"price\": NULL}],\"total\": 1},\"success\": 1}";
}

@end

@implementation TestRequestHandlerHttpRequest

- (NSString *)getRequestUrl
{
    return @"";
}

- (NSString *)getBaseUrl
{
    return @"";
}

- (GQBaseRequestDataHandler *)generateRequestHandler
{
    return nil;
}

- (GQRequestMethod)getRequestMethod
{
    return GQRequestMethodMultipartPost;
}

//- (BOOL)useDumpyData
//{
//    return YES;
//}
//
//- (NSString *)dumpyResponseString{
//    return @"\{\"message\": \"执行成功\",\"result\": {\"rows\": [{\"course\": \"0\",\"createTime\": \"1451355631000\",\"description\": \"三文鱼\",\"enumId\": 4,\"id\": 39,\"likes\": 19,\"name\": \"法香三文鱼\",\"picUrl\": \"/nisefile/files/image/2015-12-29/5681edef0cf2a9072bd6be4a.jpg\",\"price\": NULL}],\"total\": 1},\"success\": 1}";
//}

//- (void)dealloc {
//    static int I = 0;
//    NSLog(@"%zd",I);
//    I++;
//}

@end
