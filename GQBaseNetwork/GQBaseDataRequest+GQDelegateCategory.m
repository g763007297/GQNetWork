//
//  GQBaseDataRequest+DelegateCategory.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/9/29.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseDataRequest+GQDelegateCategory.h"
#import "GQDataRequestManager.h"

@implementation GQBaseDataRequest (GQDelegateCategory)

#pragma mark - class methods using delegate

+ (id)requestWithDelegate:(id<GQDataRequestDelegate>)delegate
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                      withSubRequestUrl:nil
                                                                keyPath:nil
                                                            uploadDatas:nil
                                                                mapping:nil
                                                         withParameters:nil
                                                   withHeaderParameters:nil
                                                      withIndicatorView:nil
                                                      withCancelSubject:nil
                                                           withCacheKey:nil
                                                          withCacheType:GQDataCacheManagerMemory
                                                           withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithRequestParameter:(GQRequestParameter *)parameterBody withDelegate:(id<GQDataRequestDelegate>)delegate
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                      withSubRequestUrl:parameterBody.subRequestUrl
                                                                keyPath:parameterBody.keyPath
                                                            uploadDatas:parameterBody.uploadDatas
                                                                mapping:parameterBody.mapping
                                                         withParameters:parameterBody.parameters
                                                   withHeaderParameters:parameterBody.headerParameters
                                                      withIndicatorView:parameterBody.indicatorView
                                                      withCancelSubject:parameterBody.cancelSubject
                                                           withCacheKey:parameterBody.cacheKey
                                                          withCacheType:(parameterBody.cacheType?parameterBody.cacheType:GQDataCacheManagerMemory)
                                                           withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<GQDataRequestDelegate>)delegate
           withParameters:(NSDictionary*)params{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                      withSubRequestUrl:nil
                                                                keyPath:nil
                                                            uploadDatas:nil
                                                                mapping:nil
                                                         withParameters:params
                                                   withHeaderParameters:nil
                                                      withIndicatorView:nil
                                                      withCancelSubject:nil
                                                           withCacheKey:nil
                                                          withCacheType:GQDataCacheManagerMemory
                                                           withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<GQDataRequestDelegate>)delegate
        withSubRequestUrl:(NSString*)subUrl{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                      withSubRequestUrl:subUrl
                                                                keyPath:nil
                                                            uploadDatas:nil
                                                                mapping:nil
                                                         withParameters:nil
                                                   withHeaderParameters:nil
                                                      withIndicatorView:nil
                                                      withCancelSubject:nil
                                                           withCacheKey:nil
                                                          withCacheType:GQDataCacheManagerMemory
                                                           withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<GQDataRequestDelegate>)delegate
        withSubRequestUrl:(NSString*)subUrl
        withCancelSubject:(NSString*)cancelSubject{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                      withSubRequestUrl:subUrl
                                                                keyPath:nil
                                                            uploadDatas:nil
                                                                mapping:nil
                                                         withParameters:nil
                                                   withHeaderParameters:nil
                                                      withIndicatorView:nil
                                                      withCancelSubject:cancelSubject
                                                           withCacheKey:nil
                                                          withCacheType:GQDataCacheManagerMemory
                                                           withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

/**
 *  代理实例方法
 *
 *  param delegate       代理
 *  param subUrl         拼接url
 *  param keyPath        需要过滤的key
 *  param mapping        映射map
 *  param params         请求体
 *  param headerParameters  请求头
 *  param uploadDatas    上传文件数组  使用 GQBuildUploadDataCategory 中两个方法创建
 *  param indiView       maskview显示在你的view
 *  param loadingMessage 正在加载弹框显示的文字
 *  param cancelSubject  NSNotificationCenter 取消key
 *  param cache          缓存key
 *  param cacheType      缓存类型
 *  param localFilePath  下载到什么文件位置
 *
 *  @return GQBaseDataRequest
 */
- (id)initWithDelegate:(id<GQDataRequestDelegate>)delegate
     withSubRequestUrl:(NSString*)subUrl
               keyPath:(NSString*)keyPath
           uploadDatas:(NSArray*)uploadDatas
               mapping:(GQObjectMapping*)mapping
        withParameters:(NSDictionary*)params
  withHeaderParameters:(NSDictionary *)headerParameters
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
          withCacheKey:(NSString*)cache
         withCacheType:(GQDataCacheManagerType)cacheType
          withFilePath:(NSString*)localFilePath
{
    self = [super init];
    if(self) {
        _keyPath = keyPath;
        
        _mapping = mapping;
        
        self.delegate = delegate;
        
        _subRequestUrl = subUrl;
    
        _uploadDatas = uploadDatas;
        
        _indicatorView = indiView;
        
        _cacheKey = cache;
        
        _cacheType = cacheType;
        
        _cancelSubject = cancelSubject;
        
        _localFilePath = localFilePath;
        
        _parameters = params;
        
        [self startRequest];
    }
    return self;
}

@end
