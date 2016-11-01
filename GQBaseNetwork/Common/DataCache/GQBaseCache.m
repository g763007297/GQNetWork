//
//  GQBaseCache.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseCache.h"
#import "GQNetworkConsts.h"

@implementation GQBaseCache

- (BOOL)hasObjectInCacheByKey:(NSString*)key
{
    SHOULDOVERRIDE(@"GQBaseCache", NSStringFromClass([self class]));
    return TRUE;
}

- (BOOL)hasObjectInMemoryByKey:(NSString*)key
{
    SHOULDOVERRIDE(@"GQBaseCache", NSStringFromClass([self class]));
    return TRUE;
}

- (id)getCachedObjectByKey:(NSString*)key
{
    SHOULDOVERRIDE(@"GQBaseCache", NSStringFromClass([self class]));
    return nil;
}

- (void)restore
{
    SHOULDOVERRIDE(@"GQBaseCache", NSStringFromClass([self class]));
}

- (void)clearAllCache
{
}

- (void)clearAllDiskCache
{
}

- (void)clearMemoryCache
{
    SHOULDOVERRIDE(@"GQBaseCache", NSStringFromClass([self class]));
}

- (void)addObject:(NSObject*)obj forKey:(NSString*)key
{
    SHOULDOVERRIDE(@"GQBaseCache", NSStringFromClass([self class]));
}

- (void)addObjectToMemory:(NSObject*)obj forKey:(NSString*)key
{
    SHOULDOVERRIDE(@"GQBaseCache", NSStringFromClass([self class]));
}

- (void)removeObjectInCacheByKey:(NSString*)key
{
    SHOULDOVERRIDE(@"GQBaseCache", NSStringFromClass([self class]));
}

- (void)doSave
{
    SHOULDOVERRIDE(@"GQBaseCache", NSStringFromClass([self class]));
}


@end
