//
//  GQDEBUG.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
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


#define GQAssert(condition, ...)                                       \
do {                                                                      \
    if (!(condition)) {                                                     \
        [[NSAssertionHandler currentHandler]                                  \
            handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
                file:[NSString stringWithUTF8String:__FILE__]  \
                lineNumber:__LINE__                                  \
                description:__VA_ARGS__];                             \
    }                                                                       \
} while(0)