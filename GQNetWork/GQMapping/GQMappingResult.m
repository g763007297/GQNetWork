//
//  GQMappingResult.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQMappingResult.h"
#import "GQObjectDataSource.h"

@interface GQMappingResult()
{
    GQObjectDataSource *_dataSource;
}
@end

@implementation GQMappingResult

- (instancetype)intWithDataSource:(GQObjectDataSource*)dataSource
{
    if (self) {
        _dataSource = dataSource;
    }
    return self;
}

- (NSArray*)array
{
    NSMutableArray *collection = nil;
    id object = [_dataSource valueForKeyPath:_dataSource.keyPath];
    if (object) {
        collection = [[NSMutableArray alloc] init];
        if([object isKindOfClass:[NSArray class]]) {
            [collection addObjectsFromArray:object];
        }
        else {
            [collection addObject:object];
        }
    }
    return collection;
}

- (NSDictionary*)dictionary
{
    return _dataSource.dictionary;
}

- (NSDictionary*)rawDictionary
{
    return _dataSource.rawDictionary;
}

- (id)valueForKeyPath:(NSString *)keyPath
{
    return [_dataSource valueForKeyPath:keyPath];
}

- (void)replaceObjectAtKey:(NSString*)key object:(id)object
{
    [_dataSource replaceObjectAtKeyPath:key object:object];
}

- (void)replaceObjectAtKeyPath:(NSString*)keyPath object:(id)object
{
    [_dataSource replaceObjectAtKeyPath:keyPath object:object];
}

@end
