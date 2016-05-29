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

- (BOOL)isSuccess;

- (NSArray*)array;
- (NSDictionary*)dictionary;
- (NSDictionary*)rawDictionary;
- (id)valueForKeyPath:(NSString *)keyPath;
- (void)replaceObjectAtKey:(NSString*)key object:(id)object;
- (void)replaceObjectAtKeyPath:(NSString*)keyPath object:(id)object;

@end
