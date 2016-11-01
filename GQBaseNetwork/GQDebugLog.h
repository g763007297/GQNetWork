//
//  GQConsoleLog.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/11/1.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQDebugLog : NSObject

+ (void)printMessage:(NSString *)message;

+ (void)errorMessage:(NSString *)message;

+ (void)warningMessage:(NSString *)message;

+ (void)infoMessage:(NSString *)message;

+ (void)setUpConsoleLog;

+ (void)disableConsoleLog;

+ (void)enableConsoleLog;

@end
