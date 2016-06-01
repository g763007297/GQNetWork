//
//  GQObjectMapping.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQMapping.h"

@class GQPropertyMapping;

@interface GQObjectMapping : GQMapping

@property (nonatomic, strong) NSMutableArray *mappings;

@property (nonatomic, weak, readonly) Class objectClass;

+ (instancetype)mappingFromClass:(Class)cls;

- (instancetype)initWithClass:(Class)cls;

- (GQPropertyMapping*)propertyMappingForSourceName:(NSString*)sourceName;

/*!
 * add property mapping from dictionary.
 * @param mappingDictionary Key-Value pair by data key name and property name.
 */
- (void)addPropertyMappingsFromDictionary:(NSDictionary*)mappingDictionary;

/*!
 * add sub property to object mapping
 * @param objectMapping The object mapping to be added
 * @param from The key of data
 * @param to property name of mapping class
 */
- (void)addPropertyMapping:(GQObjectMapping*)objectMapping fromKey:(NSString*)from toKey:(NSString*)to;

@end
