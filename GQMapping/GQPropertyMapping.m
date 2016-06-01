//
//  GQPropertyMapping.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQPropertyMapping.h"
#import "GQObjectMapping.h"

@implementation GQPropertyMapping

+ (GQPropertyMapping*)propertyMapping:(NSString*)sourceName propertyName:(NSString*)propertyName
{
    return [GQPropertyMapping propertyMapping:sourceName propertyName:propertyName propertyObjectClass:nil];
}

+ (GQPropertyMapping*)propertyMapping:(NSString*)sourceName propertyName:(NSString*)propertyName propertyObjectClass:(Class)cls
{
    NSAssert(sourceName, @"nil sourceName");
    NSAssert(propertyName, @"nil propertyName");
    NSAssert([sourceName length], @"empty sourceName");
    //    NSAssert([propertyName length], @"empty propertyName with field %@", sourceName);
    
    GQPropertyMapping *propertyMapping = [[GQPropertyMapping alloc] init];
    propertyMapping.sourceName = sourceName;
    propertyMapping.propertyName = propertyName;
    propertyMapping.propertyObjectClass = cls;
    return propertyMapping;
}

- (BOOL)isObjectProperty
{
    return [self.propertyObjectClass isSubclassOfClass:[GQObjectMapping class]];
}


@end
