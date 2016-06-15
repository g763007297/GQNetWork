//
//  GQMappingResult.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GQObjectDataSource;

@interface GQMappingResult : NSObject

- (instancetype)intWithDataSource:(GQObjectDataSource*)dataSource;

- (NSArray*)array;//map数组
- (NSDictionary*)dictionary;//map后结果
- (NSData *)originalData;//请求回来的原始数据
- (NSDictionary*)rawDictionary;//原始结果
- (id)valueForKeyPath:(NSString *)keyPath;
- (void)replaceObjectAtKey:(NSString*)key object:(id)object;
- (void)replaceObjectAtKeyPath:(NSString*)keyPath object:(id)object;

@end
