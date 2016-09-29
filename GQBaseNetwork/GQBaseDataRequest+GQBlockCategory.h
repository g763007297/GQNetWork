//
//  GQBaseDataRequest+GQBlockCategory.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/9/29.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseDataRequest.h"

@interface GQBaseDataRequest (GQBlockCategory)

#pragma mark - class methods using blocks

/**
 *  不需要添加参数的请求
 *
 *  @param onFinishedBlock 请求完成block
 *  @param onFailedBlock   请求失败block
 *
 *  @return self
 */
+ (id)requestWithOnRequestFinished:(GQRequestFinished)onFinishedBlock
                   onRequestFailed:(GQRequestFailed)onFailedBlock;

/**
 *  添加请求体的request
 *
 *  @param params          请求体
 *  @param onFinishedBlock 请求完成block
 *  @param onFailedBlock   请求失败block
 *
 *  @return self
 */
+ (id)requestWithWithParameters:(NSDictionary*)params
              onRequestFinished:(GQRequestFinished)onFinishedBlock
                onRequestFailed:(GQRequestFailed)onFailedBlock;

/**
 *  添加请求体的request
 *
 *  @param params          请求体
 *  @param subUrl          拼接url
 *  @param onFinishedBlock 请求完成block
 *  @param onFailedBlock   请求失败block
 *
 *  @return self
 */
+ (id)requestWithWithParameters:(NSDictionary*)params
              withSubRequestUrl:(NSString*)subUrl
              onRequestFinished:(GQRequestFinished)onFinishedBlock
                onRequestFailed:(GQRequestFailed)onFailedBlock;

/**
 *  如果想一次性配置请求参数 则配置成GQRequestParameter
 *
 *  @param parameterBody          parameterBody
 *  @param onStartBlock           请求开始block
 *  @param onRechiveResponse      收到请求头block
 *  @param onWillRedirection      将要http重定向block
 *  @param onNeedNewBodyStream    需要新的数据流block
 *  @param onWillCacheResponse    将要缓存到web中block
 *  @param onFinishedBlock        请求完成block
 *  @param onCanceledBlock        请求取消block
 *  @param onFailedBlock          请求失败block
 *  @param onProgressChangedBlock 请求进度block
 *
 *  @return GQBaseDataRequest
 */
+ (id)requestWithRequestParameter:(GQRequestParameter *)parameterBody
                   onRequestStart:(GQRequestStart)onStartBlock
                onRechiveResponse:(GQRequestRechiveResponse)onRechiveResponse
                onWillRedirection:(GQRequestWillRedirection)onWillRedirection
              onNeedNewBodyStream:(GQRequestNeedNewBodyStream)onNeedNewBodyStream
              onWillCacheResponse:(GQRequestWillCacheResponse)onWillCacheResponse
                onRequestFinished:(GQRequestFinished)onFinishedBlock
                onRequestCanceled:(GQRequestCanceled)onCanceledBlock
                  onRequestFailed:(GQRequestFailed)onFailedBlock
                onProgressChanged:(GQProgressChanged)onProgressChangedBlock;

#pragma mark -  file download class method using block
+ (id)requestWithParameters:(NSDictionary*)params
       withHeaderParameters:(NSDictionary *)headerParameters
          withSubRequestUrl:(NSString*)subUrl
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath
          onRequestFinished:(GQRequestFinished)onFinishedBlock
            onRequestFailed:(GQRequestFailed)onFailedBlock
          onProgressChanged:(GQProgressChanged)onProgressChangedBlock;


@end
