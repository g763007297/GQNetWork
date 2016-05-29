//
//  GQMappingOperation.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GQObjectDataSource;
@class GQObjectMapping;
@class GQMappingResult;

@interface GQMappingOperation : NSOperation

- (instancetype)initWithObjectDataSource:(GQObjectDataSource*)dataSource
                           objectMapping:(GQObjectMapping*)objectMapping
                                 keyPath:(NSString*)keyPath
                         completionBlock:(void(^)(GQMappingResult *result, NSError *error))completionBlock;

@end
