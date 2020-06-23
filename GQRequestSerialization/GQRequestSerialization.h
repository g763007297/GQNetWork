//
//  GQRequestSerialization.h
//  GQNetWorkDemo
//
//  Created by gaoqi on 2020/3/26.
//  Copyright © 2020 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GQNetworkConsts.h"

NS_ASSUME_NONNULL_BEGIN

@interface GQRequestSerialization : NSObject
 
@property (nonatomic, strong, readonly) NSMutableURLRequest *request;

- (instancetype)initRequestWithParameters:(id)parameters
                             headerParams:(NSDictionary *)headerParams
                              uploadDatas:(NSArray *)uploadDatas
                                      URL:(NSString *)url
                          requestEncoding:(NSStringEncoding)requestEncoding
                         parmaterEncoding:(GQParameterEncoding)parameterEncoding
                            requestMethod:(GQRequestMethod)requestMethod;

- (void)setValue:(id)value forRequestBodyDataKey:(NSString *)key;

- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(NSString *)field;

- (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

- (NSURLRequest *)serialization;

@end

NS_ASSUME_NONNULL_END
