//
//  GQDataEnvironment.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQDataEnvironment.h"
#import "GQDataCacheManager.h"
#import "GQNetworkTrafficManager.h"
#import "GQObjectSingleton.h"
@interface GQDataEnvironment()
- (void)registerMemoryWarningNotification;
@end

@implementation GQDataEnvironment

GQOBJECT_SINGLETON_BOILERPLATE(GQDataEnvironment, sharedDataEnvironment)

#pragma mark - lifecycle methods

- (id)init
{
    self = [super init];
    if ( self) {
        [self registerMemoryWarningNotification];
    }
    return self;
}

-(void)clearNetworkData
{
    [[GQDataCacheManager sharedManager] clearAllCache];
}

#pragma mark - public methods

- (void)clearCacheData
{
     [[GQDataCacheManager sharedManager] clearMemoryCache];
}

- (void)registerMemoryWarningNotification
{
#if TARGET_OS_IPHONE
    // Subscribe to app events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearCacheData)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
#ifdef __IPHONE_4_0
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported){
        // When in background, clean memory in order to have less chance to be killed
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCacheData)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
#endif
#endif
}

@end
