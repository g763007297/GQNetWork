//
//  GQMappingManager.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQMappingManager.h"
#import "GQObjectSingleton.h"
#import "GQObjectDataSource.h"
#import "GQMappingOperation.h"

#define ROOT_KEY        @"ROOT_KEY"

@interface GQMappingManager()
{
    NSOperationQueue *_mappingOperationQueue;
}
@end

@implementation GQMappingManager

GQOBJECT_SINGLETON_BOILERPLATE(GQMappingManager, sharedManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupQueue];
    }
    return self;
}


- (void)setupQueue
{
    _mappingOperationQueue = [[NSOperationQueue alloc] init];
    [_mappingOperationQueue setMaxConcurrentOperationCount:1];
}

- (void)mapWithSourceData:(id)sourceData
            objectMapping:(GQObjectMapping*)objectMapping
                  keyPath:(NSString*)keyPath
          completionBlock:(void(^)(GQMappingResult *result, NSError *error))completionBlock
{
    NSAssert([sourceData isKindOfClass:[NSDictionary class]] || [sourceData isKindOfClass:[NSArray class]], @"sourceData is not a dictionary or array!");
    
    if([sourceData isKindOfClass:[NSArray class]]) {
        keyPath = [NSString stringWithFormat:@"%@/%@", ROOT_KEY, keyPath];
        sourceData = @{ROOT_KEY:sourceData};
    }
    GQObjectDataSource *dataSource = [[GQObjectDataSource alloc] initWithSourceDictionary:sourceData keyPath:keyPath];
    GQMappingOperation *mappingOperation = [[GQMappingOperation alloc] initWithObjectDataSource:dataSource
                                                                                    objectMapping:objectMapping
                                                                                          keyPath:keyPath
                                                                                  completionBlock:completionBlock];
    [_mappingOperationQueue addOperation:mappingOperation];
}

@end
