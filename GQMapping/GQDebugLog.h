//
//  GQConsoleLog.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/11/1.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQDebugLog : NSObject

/**
 打印详细信息

 param message 提示信息
 */
+ (void)printMessage:(NSString *)message;

/**
 打印错误信息
 
 param message 提示信息
 */
+ (void)errorMessage:(NSString *)message;

/**
 打印警告信息
 
 param message 提示信息
 */
+ (void)warningMessage:(NSString *)message;

/**
 打印警告信息
 
 param message 提示信息
 */
+ (void)infoMessage:(NSString *)message;

/**
 初始化
 */
+ (void)setUpConsoleLog;

/**
 禁止打印log信息
 */
+ (void)disableConsoleLog;

/**
 打印log信息
 */
+ (void)enableConsoleLog;

@end
