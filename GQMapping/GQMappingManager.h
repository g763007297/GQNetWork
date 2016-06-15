//
//  GQMappingManager.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GQMappingResult;
@class GQObjectMapping;

@interface GQMappingManager : NSObject

+ (GQMappingManager*)sharedManager;

/*!
 * @param sourceData An json-formated object of NSArray or NSDictionary type
 * @param objectMapping The mapping being used to parse data
 * @param keyPath A key path specifying the subset of the parsed response for which the mapping is to be used. Such as result/cities
 * @param completionBlock A completion callback handler
 */
- (void)mapWithSourceData:(id)sourceData
             originalData:(NSData *)originalData
            objectMapping:(GQObjectMapping*)objectMapping
                  keyPath:(NSString*)keyPath
          completionBlock:(void(^)(GQMappingResult *result, NSError *error))completionBlock;

@end
