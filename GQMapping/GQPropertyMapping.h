//
//  GQPropertyMapping.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQMapping.h"

@class GQObjectMapping;

@interface GQPropertyMapping : GQMapping

@property (nonatomic, strong) GQObjectMapping *objectMapping;
@property (nonatomic, strong) Class propertyObjectClass;
@property (nonatomic, copy) NSString *sourceName;
@property (nonatomic, copy) NSString *propertyName;

+ (GQPropertyMapping*)propertyMapping:(NSString*)sourceName propertyName:(NSString*)propertyName;
+ (GQPropertyMapping*)propertyMapping:(NSString*)sourceName propertyName:(NSString*)propertyName propertyObjectClass:(Class)cls;

/*! Returns a BOOL value indicates whether the value of property is object or system type.
 * system type includes in (NSString, NSNumber, NSValue, NSInteger, CGFloat)
 *
 */
- (BOOL)isObjectProperty;


@end
