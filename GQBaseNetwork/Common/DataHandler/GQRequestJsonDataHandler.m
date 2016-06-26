//
//  GQRequestJsonDataHandler.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQRequestJsonDataHandler.h"

@implementation GQRequestJsonDataHandler

/*!
 * default implementation:using NSJSONSerialization to generate a NSMutableDictionary
 */
- (id)parseJsonString:(NSString *)resultString error:(NSError **)error
{
    id result = nil;
    resultString = [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSData *jsonData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
    result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:error];
    return result;
}

@end
