//
//  GQMappingUtilities.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQMappingUtilities.h"
#import "GQMappingConsts.h"
#import <objc/runtime.h>
#import "GQPropertyMapping.h"
#import "GQBaseModelObject.h"
#import "GQObjectMapping.h"
#import "GQDebug.h"

BOOL canConvertToNumber(NSString *string) {
    BOOL can = FALSE;
    if (string && [string length]) {
        can = TRUE;
        NSInteger len = string.length;
        for (NSInteger i = 0; i < len; i++) {
            if (!([string characterAtIndex:i] >= '0' && [string characterAtIndex:i] <= '9')) {
                can = FALSE;
                break;
            }
        }
    }
    return can;
}

NSString* propertyStringFromType(GQORMPropertyType type)
{
    NSString *string = @"None";
    switch (type) {
        case GQORMPropertyTypeInt:
            string = @"int";
            break;
        case GQORMPropertyTypeNSInteger:
            string = @"NSInteger";
            break;
        case GQORMPropertyTypeFloat:
            string = @"float";
            break;
        case GQORMPropertyTypeDouble:
            string = @"double";
            break;
        case GQORMPropertyTypeCGFloat:
            string = @"CGFloat";
            break;
        case GQORMPropertyTypeNSValue:
            string = @"NSValue";
            break;
        case GQORMPropertyTypeNSString:
            string = @"NSString";
            break;
        case GQORMPropertyTypeNSNumber:
            string = @"NSNumber";
            break;
        case GQORMPropertyTypeNSArray:
            string = @"NSArray";
            break;
        case GQORMPropertyTypeNSDictionary:
            string = @"NSDictionary";
            break;
        default:
            break;
    }
    return string;
}

GQORMPropertyType propertyTypeFromValue(id value)
{
    GQORMPropertyType propertyType = GQORMPropertyTypeNone;
    if ([value isKindOfClass:[NSNumber class]]) {
        propertyType = GQORMPropertyTypeNSNumber;
    }
    else if([value isKindOfClass:[NSString class]]) {
        propertyType = GQORMPropertyTypeNSString;
    }
    else if([value isKindOfClass:[NSValue class]]) {
        propertyType = GQORMPropertyTypeNSValue;
    }
    else if([value isKindOfClass:[NSDictionary class]]) {
        propertyType = GQORMPropertyTypeNSDictionary;
    }
    else if([value isKindOfClass:[NSArray class]]) {
        propertyType = GQORMPropertyTypeNSArray;
    }
    else if([value isKindOfClass:[NSArray class]]) {
        propertyType = GQORMPropertyTypeNSArray;
    }
    else if([value isKindOfClass:[GQBaseModelObject class]]) {
        propertyType = GQORMPropertyTypeCustomClass;
    }
    return propertyType;
}

GQORMPropertyType propertyTypeFromType(Class cls, const char *properptyAttributes)
{
    GQORMPropertyType propertyType = GQORMPropertyTypeNone;
    NSString *attributes = [NSString stringWithUTF8String:properptyAttributes];
    
    if (NSNotFound != [attributes rangeOfString:@"T@"].location) {
        NSString *type = [[attributes componentsSeparatedByString:@","] firstObject];
        if ([@"T@\"NSNumber\"" isEqualToString:type]) {
            propertyType = GQORMPropertyTypeNSNumber;
        }
        else if ([@"T@\"NSValue\"" isEqualToString:type]) {
            propertyType = GQORMPropertyTypeNSValue;
        }
        else if ([@"T@\"NSArray\"" isEqualToString:type]) {
            propertyType = GQORMPropertyTypeNSArray;
        }
        else if ([@"T@\"NSString\"" isEqualToString:type]) {
            propertyType = GQORMPropertyTypeNSString;
        }
        else if ([@"T@\"NSDictionary\"" isEqualToString:type]) {
            propertyType = GQORMPropertyTypeNSDictionary;
        }
        else {
            NSString *customType = [NSString stringWithFormat:@"T@\"%@\"", NSStringFromClass(cls)];
            if ([customType isEqualToString:type]) {
                propertyType = GQORMPropertyTypeCustomClass;
            }
        }
    }
    else if(NSNotFound != [attributes rangeOfString:@"Ti"].location) {
        propertyType = GQORMPropertyTypeInt;
    }
    else if(NSNotFound != [attributes rangeOfString:@"Tq"].location) {
        propertyType = GQORMPropertyTypeNSInteger;
    }
    else if(NSNotFound != [attributes rangeOfString:@"Tf"].location) {
        propertyType = GQORMPropertyTypeFloat;
    }
    else if(NSNotFound != [attributes rangeOfString:@"Td"].location) {
        propertyType = GQORMPropertyTypeCGFloat;
    }
    return propertyType;
}

/*!
 * 检测*valueObject的类型与objClass的属性的类型是否匹配，不匹配的话讲抛出异常
 */
BOOL CheckTypeMatching(id *valueObject, Class objClass, GQPropertyMapping *propertyMapping)
{
    BOOL matched = FALSE;
    NSString *reason = nil;
    NSString *propertyName = propertyMapping.propertyName;
    objc_property_t property = class_getProperty(objClass, [propertyName cStringUsingEncoding:NSUTF8StringEncoding]);
    if (!property) {
        reason = [NSString stringWithFormat:@"%@ is not a property of class %@. Please check your declaration or spelling", propertyName, NSStringFromClass(objClass)];
    }
    else {
        const char *propertyAttributeString = property_getAttributes(property);
        
        GQORMPropertyType valueAccutallyType = propertyTypeFromValue(*valueObject);
        GQORMPropertyType declarePropertyType = propertyTypeFromType(propertyMapping.objectMapping.objectClass, propertyAttributeString);
        
        BOOL declarePropertyTypeCanConvertToNumber = declarePropertyType == GQORMPropertyTypeNSNumber ||
        declarePropertyType == GQORMPropertyTypeInt ||
        declarePropertyType == GQORMPropertyTypeNSInteger ||
        declarePropertyType == GQORMPropertyTypeFloat ||
        declarePropertyType == GQORMPropertyTypeCGFloat ||
        declarePropertyType == GQORMPropertyTypeDouble;
        
        BOOL sameType = valueAccutallyType == declarePropertyType;
        if (sameType || ((GQORMPropertyTypeNSNumber == valueAccutallyType) && declarePropertyTypeCanConvertToNumber)) {
            matched = TRUE;
        }
        else {
            //属性声明的事NSString, 但是实际数据是NSNumber, 将NSNumber转化为NSString
            if (GQORMPropertyTypeNSNumber == valueAccutallyType && GQORMPropertyTypeNSString == declarePropertyType) {
                *valueObject = [*valueObject stringValue];
                matched = TRUE;
            }
            else if(GQORMPropertyTypeNSString == valueAccutallyType &&  declarePropertyTypeCanConvertToNumber) {
                if (canConvertToNumber(*valueObject)) {
                    *valueObject = @([*valueObject integerValue]);
                }
                else {
                    reason = [NSString stringWithFormat:@"The value of field %@ is: %@, it can't be converted to number.", propertyMapping.sourceName, *valueObject];
                }
                matched = TRUE;
            }
            else {
                if (GQORMPropertyTypeCustomClass == declarePropertyType) {
                    reason = [NSString stringWithFormat:@"The actual type of field %@ is %@, but the type of property %@ in %@ is declared as %@, not matched.  Please see %@ declaration", propertyMapping.sourceName, NSStringFromClass([*valueObject class]), propertyName, NSStringFromClass(objClass), NSStringFromClass(propertyMapping.objectMapping.objectClass), NSStringFromClass(objClass)];
                }
                else {
                    reason = [NSString stringWithFormat:@"The actual type of field %@ is %@, but the type of property %@ in %@ is declared as %@, not matched. Please see %@ declaration", propertyMapping.sourceName, NSStringFromClass([*valueObject class]), propertyName, NSStringFromClass(objClass), propertyStringFromType(declarePropertyType), NSStringFromClass(objClass)];
                }
            }
        }
    }
    if (reason && [reason length]) {
        @throw [NSException exceptionWithName:@"Type Mismatch" reason:reason userInfo:nil];
    }
    return matched;
}
