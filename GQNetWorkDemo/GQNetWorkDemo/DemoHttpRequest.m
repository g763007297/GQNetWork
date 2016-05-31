//
//  DemoHttpRequest.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/31.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "DemoHttpRequest.h"
#import "CONSTS.h"

@implementation DemoHttpRequest

- (NSString*)getRequestUrl
{
    return [GQHttpReuqestURL stringByAppendingString:@"/zh-services/resources/leftIndex"];
}

- (GQRequestMethod)getRequestMethod{
    return GQRequestMethodGet;
}

@end
