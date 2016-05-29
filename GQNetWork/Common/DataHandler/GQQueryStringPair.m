//
//  GQQueryStringPair.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQQueryStringPair.h"
#import "NSString+GQAdditions.h"

@implementation GQQueryStringPair

@synthesize field = _field;
@synthesize value = _value;

- (id)initWithField:(id)field value:(id)value
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.field = field;
    self.value = value;
    return self;
}

- (NSString *)urlEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding
{
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return [[self.field description] encodeUrl];
    }
    else {
        return [NSString stringWithFormat:@"%@=%@", [[self.field description] encodeUrl], [[self.value description] encodeUrl]];
    }
}

@end

#pragma mark -
NSString * GQAFQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding)
{
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (GQQueryStringPair *pair in GQAFQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair urlEncodedStringValueWithEncoding:stringEncoding]];
    }
    return [mutablePairs componentsJoinedByString:@"&"];
}

NSArray * GQAFQueryStringPairsFromDictionary(NSDictionary *dictionary)
{
    return GQAFQueryStringPairsFromKeyAndValue(nil, dictionary);
}

NSArray * GQAFQueryStringPairsFromKeyAndValue(NSString *key, id value)
{
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    if (value) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictionary = value;
            // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(caseInsensitiveCompare:)];
            for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
                id nestedValue = [dictionary objectForKey:nestedKey];
                if (nestedValue) {
                    [mutableQueryStringComponents addObjectsFromArray:GQAFQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
                }
            }
        }
        else if ([value isKindOfClass:[NSArray class]]) {
            NSArray *array = value;
            for (id nestedValue in array) {
                [mutableQueryStringComponents addObjectsFromArray:GQAFQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
            }
        }
        else if ([value isKindOfClass:[NSSet class]]) {
            NSSet *set = value;
            for (id obj in set) {
                [mutableQueryStringComponents addObjectsFromArray:GQAFQueryStringPairsFromKeyAndValue(key, obj)];
            }
        }
        else {
            GQQueryStringPair *pair = [[GQQueryStringPair alloc] initWithField:key value:value];
            [mutableQueryStringComponents addObject:pair];
        }
    }
    return mutableQueryStringComponents;
}
