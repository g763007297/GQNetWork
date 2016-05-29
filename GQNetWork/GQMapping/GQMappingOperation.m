//
//  GQMappingOperation.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQMappingOperation.h"
#import "GQObjectDataSource.h"
#import "GQObjectMapping.h"
#import "GQPropertyMapping.h"
#import "GQMappingResult.h"
#import "GQMappingUtilities.h"
#import "GQMappingConsts.h"

@interface GQMappingOperation()
{
    BOOL                _errorOccured;
    NSError             *_error;
    NSString            *_keyPath;
    GQObjectDataSource *_dataSource;
    GQObjectMapping    *_objectMapping;
    
    void(^_complectionBlock)(GQMappingResult *result, NSError *error);
}

@end

@implementation GQMappingOperation

- (void)dealloc
{
    _error = nil;
    _keyPath = nil;
    _dataSource = nil;
    _objectMapping = nil;
    _complectionBlock = nil;
}

- (instancetype)initWithObjectDataSource:(GQObjectDataSource*)dataSource
                           objectMapping:(GQObjectMapping*)objectMapping
                                 keyPath:(NSString*)keyPath
                         completionBlock:(void(^)(GQMappingResult *result, NSError *error))completionBlock
{
    self = [super init];
    if (self) {
        _errorOccured = FALSE;
        _objectMapping = objectMapping;
        _dataSource = dataSource;
        _keyPath = keyPath;
        _complectionBlock = completionBlock;
    }
    return self;
}

- (void)main
{
    GQMappingResult *mappingResult = nil;
    if (_objectMapping) {
        NSDate *beginDate = [NSDate date];
        id source = [_dataSource valueForKeyPath:_keyPath];
        //        NSAssert(!([source isKindOfClass:[NSArray class]] && [source[0] isKindOfClass:[NSNull class]]),  @"can not get value at key %@", _keyPath);
        //        NSAssert(source != nil, @"can not get value at key %@", _keyPath);
        //        NSAssert(![source isKindOfClass:[NSNull class]], @"can not get value at key %@", _keyPath);
        //
        id mappedObject = [self map:source mapping:_objectMapping];
        if (_errorOccured || _error) {
            _complectionBlock(mappingResult, _error);
        }
        else {
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:beginDate];
            [_dataSource replaceObjectAtKeyPath:_keyPath object:mappedObject];
            mappingResult = [[GQMappingResult alloc] intWithDataSource:_dataSource];
            //            GQDINFO(@"total time of parse process is %lf seconds", interval);
            _complectionBlock(mappingResult, _error);
        }
    }
    else {
        mappingResult = [[GQMappingResult alloc] intWithDataSource:_dataSource];
        _complectionBlock(mappingResult, _error);
    }
}

- (id)map:(id)source mapping:(GQObjectMapping*)objectMapping
{
    if ([source isKindOfClass:[NSArray class]]) {
        return [self mappedObjectFromArray:source withMapping:objectMapping];
    }
    else if ([source isKindOfClass:[NSDictionary class]]) {
        return [self mappedObjectFromDictionary:source withMapping:objectMapping];
    }
    else {
        NSAssert(TRUE, @"invalid source data");
        return nil;
    }
}

- (id)mappedObjectFromArray:(id)source withMapping:(GQObjectMapping*)objectMapping
{
    if (_errorOccured) {
        return nil;
    }
    @try {
        NSAssert([source isKindOfClass:[NSArray class]], @"source is not array type");
        NSMutableArray *destinationObjects = [[NSMutableArray alloc] init];
        for (id sourceObjectValue in source) {
            if ([sourceObjectValue isKindOfClass:[NSDictionary class]]) {
                id destinationObjectValue = [self mappedObjectFromDictionary:sourceObjectValue withMapping:objectMapping];
                if (destinationObjectValue) {
                    [destinationObjects addObject:destinationObjectValue];
                }
            }
            else if([sourceObjectValue isKindOfClass:[NSArray class]]) {
                id destinationObjectValue = [self mappedObjectFromArray:sourceObjectValue withMapping:objectMapping];
                if (destinationObjectValue) {
                    if ([destinationObjectValue isKindOfClass:[NSArray class]]) {
                        [destinationObjects addObjectsFromArray:destinationObjectValue];
                    }
                    else {
                        [destinationObjects addObject:destinationObjectValue];
                    }
                }
            }
            else {
                [destinationObjects addObject:sourceObjectValue];
            }
        }
        return destinationObjects;
    }
    @catch (NSException *exception) {
        _errorOccured = TRUE;
        _error = [NSError errorWithDomain:exception.name code:GQMappingErrorTypeMismatch userInfo:@{@"reason":exception.reason}];
        return nil;
    }
    @finally {
    }
}

- (id)mappedObjectFromDictionary:(id)source withMapping:(GQObjectMapping*)objectMapping
{
    if (_errorOccured) {
        return nil;
    }
    @try {
        NSAssert([source isKindOfClass:[NSDictionary class]], @"source is not dictionary type");
        id destinationObject = [objectMapping.objectClass new];
        for (NSString *sourceName in source) {
            GQPropertyMapping *propertyMapping = [objectMapping propertyMappingForSourceName:sourceName];
            if (propertyMapping) {
                if ([propertyMapping isObjectProperty]) {
                    id propertyObjectValue = [self map:[source valueForKey:sourceName] mapping:propertyMapping.objectMapping];
                    CheckTypeMatching(&propertyObjectValue, objectMapping.objectClass, propertyMapping);
                    [destinationObject setValue:propertyObjectValue forKey:propertyMapping.propertyName];
                }
                else {
                    id sourceObjectValue = [source valueForKey:sourceName];
                    CheckTypeMatching(&sourceObjectValue, objectMapping.objectClass, propertyMapping);
                    [destinationObject setValue:sourceObjectValue forKey:propertyMapping.propertyName];
                }
            }
        }
        return destinationObject;
    }
    @catch (NSException *exception) {
        _errorOccured = TRUE;
        _error = [NSError errorWithDomain:exception.name code:GQMappingErrorTypeMismatch userInfo:@{@"reason":exception.reason}];
        return nil;
    }
    @finally {
    }
    
}


@end
