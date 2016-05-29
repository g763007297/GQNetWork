//
//  GQRequestDataHandler.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQRequestDataHandler.h"

@implementation GQRequestDataHandler

- (id)parseJsonString:(NSString *)resultString error:(NSError **)error
{
    NSString *reason = [NSString stringWithFormat:@"This is a abstract method. You should subclass of ITTRequestDataHandler and override it!"];
    @throw [NSException exceptionWithName:@"Logic Error" reason:reason userInfo:nil];
    return nil;
}

@end
