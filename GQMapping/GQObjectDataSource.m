//
//  GQObjectDataSource.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQObjectDataSource.h"

@interface GQObjectDataSource()
{
    NSString            *_keyPath;
    NSData              *_originalData;
    NSMutableDictionary *_resultDictionary;
    NSMutableDictionary *_rawDictionary;
}
@end

@implementation GQObjectDataSource

- (void)dealloc
{
    _keyPath = nil;
    _resultDictionary = nil;
    _rawDictionary = nil;
}

- (instancetype)initWithSourceDictionary:(NSDictionary*)dictionary originalData:(NSData *)originalData keyPath:(NSString*)keyPath
{
    self = [super init];
    if (self) {
        _keyPath = keyPath;
        _originalData = originalData;
        if (dictionary) {            
            _resultDictionary = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
            _rawDictionary = [[NSMutableDictionary alloc] initWithDictionary:dictionary copyItems:TRUE];
        }
    }
    return self;
}

- (id)valueForKey:(NSString *)key
{
    if (key && [key length]) {
        return [_resultDictionary valueForKey:key];
    }
    return nil;
}

- (id)valueForKeyPath:(NSString *)keyPath
{
    id object = nil;
    if (keyPath && [keyPath length]) {
        NSArray *components = [keyPath componentsSeparatedByString:@"/"];
        if (components && [components count]) {
            object = _resultDictionary;
            for (NSString *key in components) {
                object = [object valueForKey:key];
                if (!object) {
                    break;
                }
            }
        }
    }
    return object;
}

- (void)replaceObject:(NSString *)key object:(id)object
{
    NSAssert(object, @"nil object");
    _resultDictionary[key] = object;
}

- (void)replaceObjectAtKeyPath:(NSString *)keyPath object:(id)object
{
    if (object) {
        NSArray *components = [keyPath componentsSeparatedByString:@"/"];
        id replacedObject = nil;
        id parentObject = nil;
        if (components && [components count]) {
            NSString *key = nil;
            replacedObject = _resultDictionary;
            NSInteger i = 0;
            for (key in components) {
                parentObject = replacedObject;
                replacedObject = [replacedObject valueForKey:key];
                if (i == [components count] - 1) {
                    [parentObject setValue:object forKey:key];
                }
                i++;
            }
        }
    }
}

- (NSDictionary*)dictionary
{
    return _resultDictionary;
}

- (NSString*)keyPath
{
    return _keyPath;
}


@end
