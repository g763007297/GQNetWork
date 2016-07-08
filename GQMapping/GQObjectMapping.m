//
//  GQObjectMapping.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQObjectMapping.h"
#import "GQPropertyMapping.h"

@interface GQObjectMapping()
{
    NSMutableDictionary *_propertyMappingsDic;
}
@end

@implementation GQObjectMapping

+ (instancetype)mappingFromClass:(Class)cls
{
    return [[self alloc] initWithClass:cls];
}

- (instancetype)initWithClass:(Class)cls
{
    self = [super init];
    if (self) {
        _objectClass = cls;
        _mappings = [[NSMutableArray alloc] init];
        _propertyMappingsDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addPropertyMappingsFromDictionary:(NSDictionary*)mappingDictionary
{
    GQPropertyMapping *propertyMapping = nil;
    for (NSString *key in mappingDictionary) {
        id object = mappingDictionary[key];
        if ([object isKindOfClass:[NSNumber class]]) {
            propertyMapping = [GQPropertyMapping propertyMapping:mappingDictionary[key] propertyName:key propertyObjectClass:[NSNumber class]];
        }
        else if([object isKindOfClass:[NSValue class]]) {
            propertyMapping = [GQPropertyMapping propertyMapping:mappingDictionary[key] propertyName:key propertyObjectClass:[NSValue class]];
        }
        else if([object isKindOfClass:[NSString class]]) {
            propertyMapping = [GQPropertyMapping propertyMapping:mappingDictionary[key] propertyName:key propertyObjectClass:[NSString class]];
        }
        else {
            NSAssert(TRUE, @"unsupported property type");
        }
        if (propertyMapping) {
            [_mappings addObject:propertyMapping];
            _propertyMappingsDic[propertyMapping.sourceName] = propertyMapping;
        }
    }
}

- (void)addPropertyMapping:(GQObjectMapping*)objectMapping fromKey:(NSString*)from toKey:(NSString*)to
{
    NSAssert(objectMapping, @"nil object mapping");
    NSAssert(from, @"nil from key");
    NSAssert(to, @"nil to key");
    
    GQPropertyMapping *propertyMapping = [GQPropertyMapping propertyMapping:from propertyName:to propertyObjectClass:[objectMapping class]];
    propertyMapping.objectMapping = objectMapping;
    [_mappings addObject:propertyMapping];
    _propertyMappingsDic[propertyMapping.sourceName] = propertyMapping;
}

- (GQPropertyMapping*)propertyMappingForSourceName:(NSString*)sourceName
{
    if (sourceName && [sourceName length]) {
        return _propertyMappingsDic[sourceName];
    }
    return nil;
}

@end
