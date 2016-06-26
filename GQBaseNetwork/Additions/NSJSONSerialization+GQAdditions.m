//
//  NSJSONSerialization+GQAdditions.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "NSJSONSerialization+GQAdditions.h"
#import "GQBaseModelObject.h"

@implementation NSJSONSerialization (GQAdditions)

/*!
 *	Convert an array of object to a string of json format
 *	\param array An array of object, object contains custom object and system primary object. Such as NSString NSDictionary NSArray
 *   etc. The super calss of custom object must be GQBaseModelObject
 *	\returns A string of json format
 */
+ (NSString*)jsonStringFromArray:(NSArray*)array
{
    NSAssert(nil != array, @"nil array!");
    NSAssert([array isKindOfClass:[NSArray class]], @"arrary is not an NSArray instance!");
    NSAssert(0 != [array count], @"empty array!");
    NSMutableString *jsonString = [NSMutableString string];
    [self serializeArray:array jsonString:jsonString];
    if ([jsonString length]) {
        [jsonString deleteCharactersInRange:NSMakeRange([jsonString length] - 1, 1)];
    }
    return jsonString;
}

/*!
 *	Convert a dictionary to a string of json format
 *	\param dictionary A dictionary the key of dictionary must be NSString type,
 *  value of dictionary can be custom object and system primary object. Such as NSString NSDictionary NSArray etc.
 *  The super class of custom object must be GQBaseModelObject
 *	\returns A string of json format
 */
+ (NSString*)jsonStringFromDictionary:(NSDictionary*)dictionary
{
    NSAssert(nil != dictionary, @"nil dictionary!");
    NSAssert([dictionary isKindOfClass:[NSDictionary class]], @"dictionary is not a NSDictionary instance!");
    NSAssert(0 != [[dictionary allKeys] count], @"empty dictionary!");
    NSMutableString *jsonString = [NSMutableString string];
    [self serializeDictionary:dictionary jsonString:jsonString];
    if ([jsonString length]) {
        [jsonString deleteCharactersInRange:NSMakeRange([jsonString length] - 1, 1)];
    }
    return jsonString;
}

+ (void)serializeArray:(NSArray*)array jsonString:(NSMutableString*)string
{
    [string appendString:@"["];
    for (id object in array) {
        if (object) {
            if ([object isKindOfClass:[GQBaseModelObject class]]) {
                NSDictionary *propertiesValuesDic = [object propertiesAndValuesDictionary];
                [self serializeDictionary:propertiesValuesDic jsonString:string];
            }
            else if ([object isKindOfClass:[NSDictionary class]]){
                [self serializeDictionary:object jsonString:string];
            }
            else if([object isKindOfClass:[NSArray class]]) {
                [self serializeArray:object jsonString:string];
            }
            else {
                [string appendFormat:@"\"%@\",", object];
            }
        }
    }
    [string deleteCharactersInRange:NSMakeRange([string length] - 1, 1)];
    [string appendString:@"]"];
    [string appendString:@","];
}

+ (void)serializeDictionary:(NSDictionary*)dictionary jsonString:(NSMutableString*)string
{
    [string appendString:@"{"];
    NSArray *allKeys = [dictionary allKeys];
    for (NSString *key in allKeys) {
        id value = dictionary[key];
        if (value) {
            if ([value isKindOfClass:[GQBaseModelObject class]]) {
                [string appendFormat:@"\"%@\":", key];
                [self serializeDictionary:[value propertiesAndValuesDictionary] jsonString:string];
            }
            else if ([value isKindOfClass:[NSArray class]]) {
                [string appendFormat:@"\"%@\":", key];
                [self serializeArray:value jsonString:string];
            }
            else if ([value isKindOfClass:[NSDictionary class]]) {
                [string appendFormat:@"\"%@\":", key];
                [self serializeDictionary:value jsonString:string];
            }
            else {
                [string appendFormat:@"\"%@\":\"%@\",", key, [value description]];
            }
        }
    }
    [string deleteCharactersInRange:NSMakeRange([string length] - 1, 1)];
    [string appendString:@"}"];
    [string appendString:@","];
}


@end
