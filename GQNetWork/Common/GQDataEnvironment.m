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
#import "CONSTS.h"
@interface GQDataEnvironment()
- (void)restore;
- (void)registerMemoryWarningNotification;
@end

@implementation GQDataEnvironment

GQOBJECT_SINGLETON_BOILERPLATE(GQDataEnvironment, sharedDataEnvironment)

#pragma mark - lifecycle methods

- (id)init
{
    self = [super init];
    if ( self) {
        [self restore];
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
    //clear cache data if needed
}

#pragma mark - private methods

- (void)restore
{
    _urlRequestHost = REQUEST_DOMAIN;
}

@end
