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

/**
 *  Given a scalar or struct value, wraps it in NSValue
 *  Based on EXPObjectify: https://github.com/specta/expecta
 */
static inline id _GQBoxValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
        UIEdgeInsets actual = (UIEdgeInsets)va_arg(v, UIEdgeInsets);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    }
    va_end(v);
    return obj;
}

#define GQBoxValue(value) _GQBoxValue(@encode(__typeof__((value))), (value))

NSComparator cmptr = ^(id obj1, id obj2){
    if ([obj1 integerValue] > [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    
    if ([obj1 integerValue] < [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
};

typedef void(^GQEnumerateSuper)(Class c , BOOL *stop);

static NSString * const versionAttributeMapDictionaryKey = @"versionAttributeMapDictionaryKey";

static NSString * const versionPropertykey = @"versionPropertykey";

static NSDictionary * oldPropertyVersionAndVlues = nil;

static NSInteger version = 0;

@interface GQBaseModelObject()

- (void)setAttributes:(NSDictionary*)dataDic;

@end

@implementation GQBaseModelObject

+ (NSDictionary *)attributeMapDictionary{
    return [[[[self class] alloc] init] propertiesAttributeMapDictionary];
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
        id valueObj = [self getValue:attributeName];
        if (valueObj) {
            [attrsDesc appendFormat:@" [%@=%@] ",attributeName,valueObj];
        }else {
            [attrsDesc appendFormat:@" [%@=nil] ",attributeName];
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
            id valueObj = [self getValue:attributeName];
            if (valueObj) {
                [object setValue:valueObj forKey:attributeName];
            }
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
        NSArray *currentChangePropertys = [self versionChangeProperties];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            oldPropertyVersionAndVlues = [decoder decodeObjectForKey:versionAttributeMapDictionaryKey];
            version = [decoder decodeIntegerForKey:versionPropertykey];
        });
        
        NSMutableArray *lastOldPropertys = [[NSMutableArray alloc] initWithArray:oldPropertyVersionAndVlues[[NSString stringWithFormat:@"%zd",version]]];
        
        if (currentChangePropertys&&[currentChangePropertys count]&&![lastOldPropertys isEqualToArray:currentChangePropertys]) {
            
            for (NSString *currentProperty in currentChangePropertys) {
                NSArray *lastCurrentPropertys = [currentProperty componentsSeparatedByString:@"->"];
                // oldChangePropertys hadn't this version changePropertys, we should use last changePropertys
                if (!lastOldPropertys) {
                    lastOldPropertys = oldPropertyVersionAndVlues[[[[oldPropertyVersionAndVlues allKeys] sortedArrayUsingComparator:cmptr] firstObject]];
                }
                
                //whether use current changePropertys
                BOOL curruntPropertysHasNotOldProperty = NO;
                
                //if never save changePropertys or,wo use current changePropertys
                if (!oldPropertyVersionAndVlues||![lastOldPropertys count]||!lastOldPropertys) {
                    curruntPropertysHasNotOldProperty = YES;
                }else{
                    int index = 0;
                    //Start from the tail ，Traverse the success of a delete one
                    for (int i = (int)[lastOldPropertys count]-1; i >= 0; i--) {
                        NSString *oldProperty = lastOldPropertys[i];
                        if ([currentProperty rangeOfString:oldProperty].location == 0&&[currentProperty rangeOfString:oldProperty].length == [oldProperty length]) {
                            NSString *lastOldProperty = [[oldProperty componentsSeparatedByString:@"->"] lastObject];
                            [changeOldPropertys addObject:lastOldProperty];
                            [changeNewPropertys addObject:[lastCurrentPropertys lastObject]];
                            [lastOldPropertys removeObject:oldProperty];
                            index--;
                            continue;
                        }else{
                            index++;
                        }
                    }
                    if (index != 0&&index == [lastOldPropertys count]) {
                        curruntPropertysHasNotOldProperty = YES;
                    }
                }
                if (curruntPropertysHasNotOldProperty) {
                    [changeOldPropertys addObject:[lastCurrentPropertys firstObject]];
                    [changeNewPropertys addObject:[lastCurrentPropertys lastObject]];
                }
            }
        }
        NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
        id attributeName;
        while ((attributeName = [keyEnum nextObject])) {
            SEL sel = [self getSetterSelWithAttibuteName:attributeName];
            if ([self respondsToSelector:sel]) {
                if ([changeNewPropertys containsObject:attributeName]) {
                    attributeName = changeOldPropertys[[changeNewPropertys indexOfObject:attributeName]];
                }
                id obj = [decoder decodeObjectForKey:attributeName];
                if (obj) {
                    [self setValue:obj forKey:attributeName];
                }
//                [self performSelectorOnMainThread:sel withObject:obj waitUntilDone:[NSThread isMainThread]];
            }
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSArray *versionChangePropertys = [self versionChangeProperties];
    if (versionChangePropertys) {
        NSMutableDictionary *newPropertyVersionAndVlues = [[NSMutableDictionary alloc] initWithDictionary:oldPropertyVersionAndVlues?oldPropertyVersionAndVlues:@{}];
        NSArray *propertys = oldPropertyVersionAndVlues[[NSString stringWithFormat:@"%zd",version]];
        //if encode dictionary not include this version change propertys, we should save new change propertys;
        if (!propertys) {
            [newPropertyVersionAndVlues setObject:versionChangePropertys forKey:[NSString stringWithFormat:@"%zd",version]];
            [encoder encodeObject:newPropertyVersionAndVlues forKey:versionAttributeMapDictionaryKey];
            [encoder encodeInteger:version forKey:versionPropertykey];
        }else{
            //if encode dictionary include this version change propertyes, we should increment our class version, and encode this version change propertys
            if (![propertys isEqualToArray:versionChangePropertys]) {
                [newPropertyVersionAndVlues setObject:versionChangePropertys forKey:[NSString stringWithFormat:@"%zd",(version+1)]];
                [encoder encodeObject:newPropertyVersionAndVlues forKey:versionAttributeMapDictionaryKey];
                [encoder encodeInteger:(version+1) forKey:versionPropertykey];
            }
        }
    }
    NSDictionary *attrMapDic = [[self class] attributeMapDictionary];
    if (attrMapDic == nil) {
        return;
    }
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        id valueObj = [self getValue:attributeName];
        if (valueObj) {
            [encoder encodeObject:valueObj forKey:attributeName];
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
            if([[dataDic objectForKey:dataDicKey] isKindOfClass:[NSNull class]]){
                value = nil;
            }else{
                value = [dataDic objectForKey:dataDicKey];
            }
            [self setValue:value forKey:dataDicKey];
        }
    }
}

/*!
 * get property names of object
 */
- (NSArray*)propertyNames
{
    NSMutableArray *propertyNames = [[NSMutableArray alloc] init];
    [[self class] enumerateCustomClass:^(__unsafe_unretained Class c, BOOL *stop) {
        unsigned int propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList(c, &propertyCount);
        for (unsigned int i = 0; i < propertyCount; ++i) {
            objc_property_t property = properties[i];
            const char * name = property_getName(property);
            [propertyNames addObject:[NSString stringWithUTF8String:name]];
        }
        free(properties);
    }];
    return propertyNames;
}

+ (void)enumerateCustomClass:(GQEnumerateSuper)block{
    if (block == nil) {
        return;
    }
    BOOL stop = NO;
    
    Class c = self;
    
    while (c &&!stop) {
        block(c, &stop);
        
        c = class_getSuperclass(c);
        
        if (![c isSubclassOfClass:[GQBaseModelObject class]]) break;
    }
}

- (NSArray *)versionChangeProperties
{
    return nil;
}

/*!
 *	\returns a dictionary Key-Value pair by property and corresponding value.
 */
- (NSDictionary*)propertiesAndValuesDictionary
{
    NSMutableDictionary *propertiesValuesDic = [NSMutableDictionary dictionary];
    NSArray *properties = [self propertyNames];
    for (NSString *property in properties) {
        id object = [self getValue:property]?[self getValue:property]:@"";
        propertiesValuesDic[property] = object;
    }
    return propertiesValuesDic;
}

- (id)getValue:(NSString *)property{
    SEL getSel = NSSelectorFromString(property);
    id valueObj = nil;
    if ([self respondsToSelector:getSel]) {
        valueObj =[self valueForKey:property];
    }
    return GQBoxValue(valueObj);
}

// default AttributeMapDictionary
- (NSDictionary*)propertiesAttributeMapDictionary
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
