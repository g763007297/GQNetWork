//
//  GQBaseDataRequest+GQBlockCategory.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/9/29.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseDataRequest+GQBlockCategory.h"
#import "GQDataRequestManager.h"

@implementation GQBaseDataRequest (GQBlockCategory)

#pragma mark - class methods using block

+ (id)requestWithOnRequestFinished:(GQRequestFinished)onFinishedBlock
                   onRequestFailed:(GQRequestFailed)onFailedBlock{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:nil
                                                     withHeaderParameters:nil
                                                        withSubRequestUrl:nil
                                                        withIndicatorView:nil
                                                              uploadDatas:nil
                                                                  keyPath:nil
                                                                  mapping:nil
                                                        withCancelSubject:nil
                                                             withCacheKey:nil
                                                            withCacheType:GQDataCacheManagerMemory
                                                             withFilePath:nil
                                                           onRequestStart:nil
                                                        onRechiveResponse:nil
                                                        onWillRedirection:nil
                                                      onNeedNewBodyStream:nil
                                                      onWillCacheResponse:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithWithParameters:(NSDictionary*)params
              onRequestFinished:(GQRequestFinished)onFinishedBlock
                onRequestFailed:(GQRequestFailed)onFailedBlock{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                     withHeaderParameters:nil
                                                        withSubRequestUrl:nil
                                                        withIndicatorView:nil
                                                              uploadDatas:nil
                                                                  keyPath:nil
                                                                  mapping:nil
                                                        withCancelSubject:nil
                                                             withCacheKey:nil
                                                            withCacheType:GQDataCacheManagerMemory
                                                             withFilePath:nil
                                                           onRequestStart:nil
                                                        onRechiveResponse:nil
                                                        onWillRedirection:nil
                                                      onNeedNewBodyStream:nil
                                                      onWillCacheResponse:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithWithParameters:(NSDictionary*)params
              withSubRequestUrl:(NSString*)subUrl
              onRequestFinished:(GQRequestFinished)onFinishedBlock
                onRequestFailed:(GQRequestFailed)onFailedBlock{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                     withHeaderParameters:nil
                                                        withSubRequestUrl:subUrl
                                                        withIndicatorView:nil
                                                              uploadDatas:nil
                                                                  keyPath:nil
                                                                  mapping:nil
                                                        withCancelSubject:nil
                                                             withCacheKey:nil
                                                            withCacheType:GQDataCacheManagerMemory
                                                             withFilePath:nil
                                                           onRequestStart:nil
                                                        onRechiveResponse:nil
                                                        onWillRedirection:nil
                                                      onNeedNewBodyStream:nil
                                                      onWillCacheResponse:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithRequestParameter:(GQRequestParameter *)parameterBody
                   onRequestStart:(GQRequestStart)onStartBlock
                onRechiveResponse:(GQRequestRechiveResponse)onRechiveResponse
                onWillRedirection:(GQRequestWillRedirection)onWillRedirection
              onNeedNewBodyStream:(GQRequestNeedNewBodyStream)onNeedNewBodyStream
              onWillCacheResponse:(GQRequestWillCacheResponse)onWillCacheResponse
                onRequestFinished:(GQRequestFinished)onFinishedBlock
                onRequestCanceled:(GQRequestCanceled)onCanceledBlock
                  onRequestFailed:(GQRequestFailed)onFailedBlock
                onProgressChanged:(GQProgressChanged)onProgressChangedBlock{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:parameterBody.parameters
                                                     withHeaderParameters:parameterBody.headerParameters
                                                        withSubRequestUrl:parameterBody.subRequestUrl
                                                        withIndicatorView:parameterBody.indicatorView
                                                              uploadDatas:parameterBody.uploadDatas
                                                                  keyPath:parameterBody.keyPath
                                                                  mapping:parameterBody.mapping
                                                        withCancelSubject:parameterBody.cancelSubject
                                                             withCacheKey:parameterBody.cacheKey
                                                            withCacheType:parameterBody.cacheType
                                                             withFilePath:parameterBody.localFilePath
                                                           onRequestStart:onStartBlock
                                                        onRechiveResponse:onRechiveResponse
                                                        onWillRedirection:onWillRedirection
                                                      onNeedNewBodyStream:onNeedNewBodyStream
                                                      onWillCacheResponse:onWillCacheResponse
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:onCanceledBlock
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:onProgressChangedBlock];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
       withHeaderParameters:(NSDictionary *)headerParameters
          withSubRequestUrl:(NSString*)subUrl
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath
          onRequestFinished:(GQRequestFinished)onFinishedBlock
            onRequestFailed:(GQRequestFailed)onFailedBlock
          onProgressChanged:(GQProgressChanged)onProgressChangedBlock{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                     withHeaderParameters:headerParameters
                                                        withSubRequestUrl:subUrl
                                                        withIndicatorView:nil
                                                              uploadDatas:nil
                                                                  keyPath:nil
                                                                  mapping:nil
                                                        withCancelSubject:cancelSubject
                                                             withCacheKey:nil
                                                            withCacheType:GQDataCacheManagerMemory
                                                             withFilePath:localFilePath
                                                           onRequestStart:nil
                                                        onRechiveResponse:nil
                                                        onWillRedirection:nil
                                                      onNeedNewBodyStream:nil
                                                      onWillCacheResponse:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:onProgressChangedBlock];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

/**
 *  Block实例方法
 *
 *  param params                 请求体
 *  param headerParameters         请求头
 *  param subUrl                 拼接url
 *  param indiView               正在加载maskview
 *  param uploadDatas            上传文件数组  使用 GQBuildUploadDataCategory 中两个方法创建
 *  param keyPath                需要过滤的key
 *  param mapping                映射map
 *  param loadingMessage         正在加载弹框显示的文字
 *  param cancelSubject          NSNotificationCenter 取消key
 *  param cache                  缓存key
 *  param cacheType              缓存类型
 *  param localFilePath          下载到什么文件位置
 *  param onStartBlock           请求开始block
 *  param onRechiveResponse      收到请求头block
 *  param onFinishedBlock        请求完成block
 *  param onCanceledBlock        请求取消block
 *  param onFailedBlock          请求失败block
 *  param onProgressChangedBlock 请求百分比变化block
 *
 *  @return GQBaseDataRequest
 */
- (id)initWithParameters:(NSDictionary*)params
    withHeaderParameters:(NSDictionary *)headerParameters
       withSubRequestUrl:(NSString*)subUrl
       withIndicatorView:(UIView*)indiView
             uploadDatas:(NSArray*)uploadDatas
                 keyPath:(NSString*)keyPath
                 mapping:(GQObjectMapping*)mapping
       withCancelSubject:(NSString*)cancelSubject
            withCacheKey:(NSString*)cache
           withCacheType:(GQDataCacheManagerType)cacheType
            withFilePath:(NSString*)localFilePath
          onRequestStart:(GQRequestStart)onStartBlock
       onRechiveResponse:(GQRequestRechiveResponse)onRechiveResponse
       onWillRedirection:(GQRequestWillRedirection)onWillRedirection
     onNeedNewBodyStream:(GQRequestNeedNewBodyStream)onNeedNewBodyStream
     onWillCacheResponse:(GQRequestWillCacheResponse)onWillCacheResponse
       onRequestFinished:(GQRequestFinished)onFinishedBlock
       onRequestCanceled:(GQRequestCanceled)onCanceledBlock
         onRequestFailed:(GQRequestFailed)onFailedBlock
       onProgressChanged:(GQProgressChanged)onProgressChangedBlock
{
    self = [super init];
    if(self) {
        _keyPath = keyPath;
        
        _mapping = mapping;
        
        _subRequestUrl = subUrl;
        
        _indicatorView = indiView;
        
        _cacheKey = cache;
        
        _cacheType = cacheType;
        
        _cancelSubject = cancelSubject;
        
        _localFilePath = localFilePath;
        
        _parameters = params;
        
        _headerParameters = headerParameters;
        
        if (onStartBlock) {
            _onRequestStart = [onStartBlock copy];
        }
        
        if (onRechiveResponse) {
            _onRequestRechiveResponse = [onRechiveResponse copy];
        }
        
        if (onWillRedirection) {
            _onRequestWillRedirection = [onWillRedirection copy];
        }
        
        if (onNeedNewBodyStream) {
            _onRequestNeedNewBodyStream = [onNeedNewBodyStream copy];
        }
        
        if (onWillCacheResponse) {
            _onRequestWillCacheRespons = [onWillCacheResponse copy];
        }
        
        if (onFinishedBlock) {
            _onRequestFinished = [onFinishedBlock copy];
        }
        
        if (onCanceledBlock) {
            _onRequestCanceled = [onCanceledBlock copy];
        }
        
        if (onFailedBlock) {
            _onRequestFailed = [onFailedBlock copy];
        }
        
        if (onProgressChangedBlock) {
            _onProgressChanged = [onProgressChangedBlock copy];
        }
        
        [self startRequest];
    }
    return self;
}

@end
