//
//  GQBaseModelObject.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseModelObject.h"
#import <objc/runtime.h>
#import "GQDebug.h"

NSComparator cmptr = ^(id obj1, id obj2){
    if ([obj1 integerValue] > [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    if ([obj1 integerValue] < [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
};

static NSArray * changePropertyKeys = nil;

static NSString * const versionAttributeMapDictionaryKey = @"versionAttributeMapDictionaryKey";

@interface GQBaseModelObject()

- (void)setAttributes:(NSDictionary*)dataDic;

@end

@implementation GQBaseModelObject

+ (NSDictionary *)attributeMapDictionary{
    return [[[[self class] alloc] init] propertiesAndValuesAttributeMapDictionary];
}

- (NSString *)customDescription
{
    return nil;
}

- (NSData*)getArchivedData
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (NSString *)description
{
    NSMutableString *attrsDesc = [NSMutableString stringWithCapacity:100];
    NSDictionary *attrMapDic = [[self class] attributeMapDictionary];
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL getSel = NSSelectorFromString(attributeName);
        if ([self respondsToSelector:getSel]) {
            NSMethodSignature *signature = nil;
            signature = [self methodSignatureForSelector:getSel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:getSel];
            NSObject *__unsafe_unretained valueObj = nil;
            [invocation invoke];
            [invocation getReturnValue:&valueObj];
            if (valueObj) {
                [attrsDesc appendFormat:@" [%@=%@] ",attributeName,valueObj];
                //[valueObj release];
            }else {
                [attrsDesc appendFormat:@" [%@=nil] ",attributeName];
            }
        }
    }
    NSString *customDesc = [self customDescription];
    NSString *desc;
    if (customDesc && [customDesc length] > 0 ) {
        desc = [NSString stringWithFormat:@"%@:{%@,%@}", [self class], attrsDesc, customDesc];
    }
    else {
        desc = [NSString stringWithFormat:@"%@:{%@}", [self class], attrsDesc];
    }
    return desc;
}



-(id)initWithDataDic:(NSDictionary*)data
{
    if (self = [super init]) {
        [self setAttributes:data];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id object = [[self class] allocWithZone:zone];
    NSDictionary *attrMapDic = [[self class] attributeMapDictionary];
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL getSel = NSSelectorFromString(attributeName);
        SEL sel = [object getSetterSelWithAttibuteName:attributeName];
        if ([self respondsToSelector:sel] &&
            [self respondsToSelector:getSel]) {
            
            NSMethodSignature *signature = nil;
            signature = [self methodSignatureForSelector:getSel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:getSel];
            NSObject * __unsafe_unretained valueObj = nil;
            [invocation invoke];
            [invocation getReturnValue:&valueObj];
            
            [object performSelectorOnMainThread:sel
                                     withObject:valueObj
                                  waitUntilDone:TRUE];
        }
    }
    return object;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if( self = [super init] ){
        NSDictionary *attrMapDic = [[self class] attributeMapDictionary];
        if (attrMapDic == nil) {
            return self;
        }
        NSMutableArray *changeOldPropertys = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *changeNewPropertys = [[NSMutableArray alloc] initWithCapacity:0];
        if (changePropertyKeys&&[changePropertyKeys count]) {
            NSDictionary *oldPropertyVersionAndVlues = [decoder decodeObjectForKey:versionAttributeMapDictionaryKey];
            NSInteger version = [decoder versionForClassName:NSStringFromClass([self class])];
            
            if (!oldPropertyVersionAndVlues[[NSString stringWithFormat:@"%ld",version]]) {
                for (NSString *currentProperty in changePropertyKeys) {
                    NSArray *lastCurrentPropertys = [currentProperty componentsSeparatedByString:@"->"];
                    
                    NSArray *lastOldPropertys = oldPropertyVersionAndVlues[[[[oldPropertyVersionAndVlues allKeys] sortedArrayUsingComparator:cmptr] firstObject]];
                    
                    for (NSString *oldProperty in lastOldPropertys) {
                        if ([currentProperty rangeOfString:oldProperty].location == 0&&[currentProperty rangeOfString:oldProperty].length == [oldProperty length]) {
                            NSString *lastOldProperty = [[oldProperty componentsSeparatedByString:@"->"] lastObject];
                            [changeOldPropertys addObject:lastOldProperty];
                            [changeNewPropertys addObject:lastCurrentPropertys];
                            continue;
                        }
                    }
                }
            }
        }
        NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
        id attributeName;
        while ((attributeName = [keyEnum nextObject])) {
            SEL sel = [self getSetterSelWithAttibuteName:attributeName];
            if ([self respondsToSelector:sel]) {
                id obj = [decoder decodeObjectForKey:[changeNewPropertys containsObject:attributeName]?changeOldPropertys[[changeNewPropertys indexOfObject:attributeName]]:attributeName];
                [self performSelectorOnMainThread:sel withObject:obj waitUntilDone:[NSThread isMainThread]];
            }
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSDictionary *attrMapDic = [[self class] attributeMapDictionary];
    if (attrMapDic == nil) {
        return;
    }
    
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    
    while ((attributeName = [keyEnum nextObject])) {
        
        SEL getSel = NSSelectorFromString(attributeName);
        
        if ([self respondsToSelector:getSel]) {
            
            NSMethodSignature *signature = nil;
            signature = [self methodSignatureForSelector:getSel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:getSel];
            NSObject * __unsafe_unretained valueObj = nil;
            [invocation invoke];
            [invocation getReturnValue:&valueObj];
            
            if (valueObj) {
                [encoder encodeObject:valueObj forKey:attributeName];
            }
        }
    }
}

#pragma mark - private methods
-(SEL)getSetterSelWithAttibuteName:(NSString*)attributeName
{
    NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
    NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
    return NSSelectorFromString(setterSelStr);
}

-(void)setAttributes:(NSDictionary*)dataDic
{
    NSDictionary *attrMapDic = [[self class] attributeMapDictionary];
    if (attrMapDic == nil) {
        return;
    }
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL sel = [self getSetterSelWithAttibuteName:attributeName];
        if ([self respondsToSelector:sel]) {
            NSString *dataDicKey = attrMapDic[attributeName];
            NSString *value = nil;
            if ([[dataDic objectForKey:dataDicKey] isKindOfClass:[NSNumber class]]) {
                value = [[dataDic objectForKey:dataDicKey] stringValue];
            }
            else if([[dataDic objectForKey:dataDicKey] isKindOfClass:[NSNull class]]){
                value = nil;
            }
            else{
                value = [dataDic objectForKey:dataDicKey];
            }
            [self performSelectorOnMainThread:sel
                                   withObject:value
                                waitUntilDone:[NSThread isMainThread]];
        }
    }
}

/*!
 * get property names of object
 */
- (NSArray*)propertyNames
{
    NSMutableArray *propertyNames = [[NSMutableArray alloc] init];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return propertyNames;
}

+ (void)setVersionChangeProperties:(NSArray *)ChangeProperties
{
    changePropertyKeys = ChangeProperties;
}

/*
 NSDictionary *attributeMapDictionary = [GQBaseModelObject attributeMapDictionary];
 NSInteger version = [GQBaseModelObject version];
 
 NSDictionary *currentAttributeMapDictionary = [self getVersionAttributeMapDictionary];
 if (![currentAttributeMapDictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)version]]) {
 NSMutableDictionary *versionAttributeMapDictionary = [[NSMutableDictionary alloc] initWithObjects:@[attributeMapDictionary] forKeys:@[[NSString stringWithFormat:@"%ld",(long)version]]];
 [versionAttributeMapDictionary addEntriesFromDictionary:currentAttributeMapDictionary];
 [self setVersionAttributeMapDictionary:versionAttributeMapDictionary];
 [encoder encodeObject:versionAttributeMapDictionary forKey:versionAttributeMapDictionaryKey];
 }
 */

/*!
 *	\returns a dictionary Key-Value pair by property and corresponding value.
 */
- (NSDictionary*)propertiesAndValuesDictionary
{
    NSMutableDictionary *propertiesValuesDic = [NSMutableDictionary dictionary];
    NSArray *properties = [self propertyNames];
    for (NSString *property in properties) {
        SEL getSel = NSSelectorFromString(property);
        if ([self respondsToSelector:getSel]) {
            NSMethodSignature *signature = nil;
            signature = [self methodSignatureForSelector:getSel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:getSel];
            NSObject * __unsafe_unretained valueObj = nil;
            [invocation invoke];
            [invocation getReturnValue:&valueObj];
            //assign to @"" string
            if (!valueObj) {
                valueObj = @"";
            }
            propertiesValuesDic[property] = valueObj;
        }
    }
    return propertiesValuesDic;
}

/*!
 *	\returns a dictionary Key-Value pair by property and corresponding value.
 */
- (NSDictionary*)propertiesAndValuesAttributeMapDictionary
{
    NSMutableDictionary *attributeMapDictionary = [NSMutableDictionary dictionary];
    NSArray *properties = [self propertyNames];
    for (NSString *property in properties) {
        SEL getSel = NSSelectorFromString(property);
        if ([self respondsToSelector:getSel]) {
            attributeMapDictionary[property] = property;
        }
    }
    return attributeMapDictionary;
}

@end
