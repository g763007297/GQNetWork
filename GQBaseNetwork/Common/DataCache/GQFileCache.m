//
//  GQFileCache.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQFileCache.h"
#import "GQDebug.h"

@interface GQFileCache()
{
    NSMutableArray      *_memoryCacheKeys;      // keys for objects only cached in memory
    NSMutableArray      *_keys;                 // keys for keys not managed by queue
    NSMutableDictionary *_memoryCachedObjects;  // objects only cached in memory
    NSOperationQueue    *_cacheInQueue;         // manager cache operation
}
@end

@implementation GQFileCache

#pragma mark - private methods

- (NSString*)getCacheDaoFilePath
{
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, TRUE)[0];
    return [cacheDir stringByAppendingPathComponent:@"dao"];
}

- (NSString*)getFilePathWithKey:(NSString*)key
{
    NSString *cacheDao = [self getCacheDaoFilePath];
    return [cacheDao stringByAppendingPathComponent:key];
}

- (id)getObjectWithKey:(NSString*)key
{
    NSString *filePath = [self getFilePathWithKey:key];
    id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return object;
}

- (BOOL)isValidKey:(NSString*)key
{
    if (!key || [key length] == 0 || (NSNull*)key == [NSNull null]) {
        return NO;
    }
    return YES;
}

- (void)storeToDisk:(NSDictionary *)dic
{
    @autoreleasepool {
        NSString *key = [dic objectForKey:@"key"];
        NSObject *data = [dic objectForKey:@"data"];
        [self saveObjectWithKey:_keys key:GQ_UD_KEY_DATA_CACHE_KEYS];
        [self saveObjectWithKey:data key:key];
    }
}

- (void)addObjectWithKey:(id)object key:(NSString *)key
{
    NSDictionary *saveDataDic = [NSDictionary dictionaryWithObjectsAndKeys:key, @"key", object, @"data", nil];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(storeToDisk:) object:saveDataDic];
    [_cacheInQueue addOperation:operation];
}

- (void)saveObjectWithKey:(id)object key:(NSString*)key
{
    BOOL result = FALSE;
    NSString *directory = [self getCacheDaoFilePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:NULL]) {
        result = [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:TRUE attributes:NULL error:NULL];
        if (result) {
            GQDINFO(@"create directory successfully!");
        }
    }
    NSString *filePath = [self getFilePathWithKey:key];
    result = [NSKeyedArchiver archiveRootObject:object toFile:filePath];
    if (result) {
        GQDINFO(@"save successfully!");
    }
}

- (void)removeFileWithKey:(NSString*)key
{
    NSString *filePath = [self getFilePathWithKey:key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [fileManager removeItemAtPath:filePath error:&error];
//        NSString *errorMessage = [NSString stringWithFormat:@"delete file %@ failed", filePath];
//        NSAssert(nil == error,  errorMessage);
    }
}

#pragma mark - lifecycle methods
- (id)init
{
    self = [super init];
    if (self) {
        [self restore];
    }
    return self;
}

#pragma mark - public methods
- (void)restore
{
    _cacheInQueue = [[NSOperationQueue alloc] init];
    [_cacheInQueue setMaxConcurrentOperationCount:1];
    NSArray *keysArray = [self getObjectWithKey:GQ_UD_KEY_DATA_CACHE_KEYS];
    if (keysArray) {
        _keys = [[NSMutableArray alloc] initWithArray:keysArray];
    }
    else{
        _keys = [[NSMutableArray alloc] init];
    }
    _memoryCacheKeys = [[NSMutableArray alloc] init];
    _memoryCachedObjects = [[NSMutableDictionary alloc] init];
}

- (void)doSave
{
    [self saveObjectWithKey:_keys key:GQ_UD_KEY_DATA_CACHE_KEYS];
}

- (void)clearAllCache
{
    [self clearMemoryCache];
    [self clearAllDiskCache];
}

- (void)clearMemoryCache
{
    [_memoryCacheKeys removeAllObjects];
    [_memoryCachedObjects removeAllObjects];
}

- (void)clearAllDiskCache
{
    NSArray *allKeys = [NSArray arrayWithArray:_keys];
    [_keys removeAllObjects];
    [self removeFileWithKey:GQ_UD_KEY_DATA_CACHE_KEYS];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *key in allKeys) {
            [self removeFileWithKey:key];
        }
    });
}

- (void)addObject:(NSObject*)obj forKey:(NSString*)key
{
    if (![self isValidKey:key]) {
        return;
    }
    if (!obj || (NSNull*)obj == [NSNull null]) {
        return;
    }
    if (![_keys containsObject:key]) {
        [_keys addObject:key];
    }
    if (![_memoryCacheKeys containsObject:key]) {
        [_memoryCacheKeys addObject:key];
    }
    [_memoryCachedObjects setObject:obj forKey:key];
    [self addObjectWithKey:obj key:key];
}

- (void)addObjectToMemory:(NSObject*)obj forKey:(NSString*)key
{
    if (![self isValidKey:key]) {
        return;
    }
    if (!obj || (NSNull*)obj == [NSNull null]) {
        return;
    }
    if ([_memoryCacheKeys containsObject:key]) {
        [_memoryCacheKeys removeObject:key];
        [_memoryCachedObjects removeObjectForKey:key];
    }
    [_memoryCacheKeys addObject:key];
    _memoryCachedObjects[key] = obj;
}

- (id)getCachedObjectByKey:(NSString*)key
{
    if (![self isValidKey:key]) {
        return nil;
    }
    if ([self hasObjectInMemoryByKey:key]) {
        return _memoryCachedObjects[key];
    }
    else {
        NSObject *obj = [self getObjectWithKey:key];
        if (obj) {
            _memoryCachedObjects[key] = obj;
        }
        return obj;
    }
}

- (BOOL)hasObjectInMemoryByKey:(NSString*)key
{
    if ([_memoryCacheKeys containsObject:key]) {
        return TRUE;
    }
    return FALSE;
}

- (BOOL)hasObjectInCacheByKey:(NSString*)key
{
    if ([self hasObjectInMemoryByKey:key]) {
        return YES;
    }
    if ([_keys containsObject:key]) {
        return YES;
    }
    return NO;
}

- (void)removeObjectInCacheByKey:(NSString*)key
{
    if (![self isValidKey:key]) {
        return;
    }
    [_keys removeObject:key];
    [_memoryCachedObjects removeObjectForKey:key];
    [self removeObjectInCacheByKey:key];
    [self doSave];
}


@end
