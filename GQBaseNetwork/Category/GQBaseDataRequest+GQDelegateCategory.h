//
//  GQBaseDataRequest+DelegateCategory.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/9/29.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseDataRequest.h"

@interface GQBaseDataRequest (GQDelegateCategory)

#pragma mark - class methods using delegate

/**
 *  请求方法
 *
 *  param delegate DataRequestDelegate
 *
 *  @return  GQBaseDataRequest
 */
+ (instancetype)requestWithDelegate:(id<GQDataRequestDelegate>)delegate;

/**
 *  如果想一次性配置请求参数 则配置成GQRequestParameter
 *
 *  param parameterBody parameterBody
 *  param delegate      DataRequestDelegate
 *
 *  @return GQBaseDataRequest
 */
+ (instancetype)requestWithRequestParameter:(GQRequestParameter *)parameterBody
                               withDelegate:(id<GQDataRequestDelegate>)delegate;

/**
 *  请求方法
 *
 *  param delegate DataRequestDelegate
 *  param params   请求体
 *
 *  @return GQBaseDataRequest
 */
+ (instancetype)requestWithDelegate:(id<GQDataRequestDelegate>)delegate
                     withParameters:(NSDictionary*)params;
/**
 *  请求方法
 *
 *  param delegate DataRequestDelegate
 *  param subUrl   拼接url
 *
 *  @return GQBaseDataRequest
 */
+ (instancetype)requestWithDelegate:(id<GQDataRequestDelegate>)delegate
                  withSubRequestUrl:(NSString*)subUrl;

/**
 *  请求方法
 *
 *  param delegate      DataRequestDelegate
 *  param subUrl        拼接url
 *  param cancelSubject 取消请求NSNotification的Key
 *
 *  @return GQBaseDataRequest
 */

+ (instancetype)requestWithDelegate:(id<GQDataRequestDelegate>)delegate
                  withSubRequestUrl:(NSString*)subUrl
                  withCancelSubject:(NSString*)cancelSubject;

@end

