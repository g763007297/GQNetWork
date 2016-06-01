//
//  GQObjectDataSource.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQObjectDataSource : NSObject

@property (nonatomic, readonly) NSString *keyPath;
@property (nonatomic, readonly) NSDictionary *dictionary;
@property (nonatomic, readonly) NSDictionary *rawDictionary;

- (instancetype)initWithSourceDictionary:(NSDictionary*)dictionary keyPath:(NSString*)keyPath;

- (id)valueForKey:(NSString *)key;
- (id)valueForKeyPath:(NSString *)keyPath;
- (void)replaceObject:(NSString *)key object:(id)object;
- (void)replaceObjectAtKeyPath:(NSString *)keyPath object:(id)object;

@end
