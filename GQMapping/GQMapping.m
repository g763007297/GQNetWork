//
//  GQMapping.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQMapping.h"
#import "GQDebugLog.h"

@implementation GQMapping

- (void)dealloc
{
    [GQDebugLog infoMessage:[NSString stringWithFormat:@"%@ dealloc", NSStringFromClass([self class])]];
}

@end
