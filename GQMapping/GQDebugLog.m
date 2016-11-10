//
//  GQConsoleLog.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/11/1.
//  Copyright © 2016年 gaoqi. All rights reserved.
//
#define GQDEBUG
#define GQLOGLEVEL_INFO     10
#define GQLOGLEVEL_WARNING  3
#define GQLOGLEVEL_ERROR    1

#ifndef GQMAXLOGLEVEL

#ifdef DEBUG
    #define GQMAXLOGLEVEL GQLOGLEVEL_INFO
#else
    #define GQMAXLOGLEVEL GQLOGLEVEL_ERROR
#endif

#endif

// The general purpose logger. This ignores logging levels.
#ifdef GQDEBUG
    #define GQDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define GQDPRINT(xx, ...)  ((void)0)
#endif

// Prints the current method's name.
#define GQDPRINTMETHODNAME() GQDPRINT(@"%s", __PRETTY_FUNCTION__)

// Log-level based logging macros.
#if GQLOGLEVEL_ERROR <= GQMAXLOGLEVEL
    #define GQDERROR(xx, ...)  GQDPRINT(xx, ##__VA_ARGS__)
#else
    #define GQDERROR(xx, ...)  ((void)0)
#endif

#if GQLOGLEVEL_WARNING <= GQMAXLOGLEVEL
    #define GQDWARNING(xx, ...)  GQDPRINT(xx, ##__VA_ARGS__)
#else
    #define GQDWARNING(xx, ...)  ((void)0)
#endif

#if GQLOGLEVEL_INFO <= GQMAXLOGLEVEL
    #define GQDINFO(xx, ...)  GQDPRINT(xx, ##__VA_ARGS__)
#else
    #define GQDINFO(xx, ...)  ((void)0)
#endif

#ifdef GQDEBUG
    #define GQDCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
        GQDPRINT(xx, ##__VA_ARGS__); \
        } \
    } ((void)0)
#else
    #define GQDCONDITIONLOG(condition, xx, ...) ((void)0)
#endif

#define GQConsoleLogKey @"GQConsoleLogKey"

#import "GQDebugLog.h"

static BOOL debugLogMessage;

@implementation GQDebugLog

+ (void)printMessage:(NSString *)message
{
    if (debugLogMessage) {
        GQDPRINT(@"%@",message);
    }
}

+ (void)errorMessage:(NSString *)message
{
    if (debugLogMessage) {
        GQDERROR(@"%@",message);
    }
}

+ (void)warningMessage:(NSString *)message
{
    if (debugLogMessage) {
        GQDWARNING(@"%@",message);
    }
}

+ (void)infoMessage:(NSString *)message
{
    if (debugLogMessage) {
        GQDINFO(@"%@",message);
    }
}

+ (void)setUpConsoleLog
{
    debugLogMessage = [[NSUserDefaults standardUserDefaults] boolForKey:GQConsoleLogKey];
}

+ (void)disableConsoleLog
{
    debugLogMessage = NO;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:GQConsoleLogKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)enableConsoleLog
{
    debugLogMessage = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GQConsoleLogKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
