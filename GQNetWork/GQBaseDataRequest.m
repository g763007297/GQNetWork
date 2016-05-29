//
//  GQBaseDataRequest.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseDataRequest.h"
#import "GQDataRequestManager.h"
#import "GQRequestJsonDataHandler.h"
#import "GQMappingHeader.h"
#import "GQDebug.h"
#import "GQCommonMacros.h"

@interface GQBaseDataRequest()
{
    GQObjectMapping    *_mapping;
}
@end

@implementation GQBaseDataRequest

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                                 keyPath:nil
                                                                 mapping:nil
                                                          withParameters:nil
                                                       withIndicatorView:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:YES
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
           withParameters:(NSDictionary*)params{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                                 keyPath:nil
                                                                 mapping:nil
                                                          withParameters:params
                                                       withIndicatorView:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
        withSubRequestUrl:(NSString*)subUrl{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                       withSubRequestUrl:subUrl
                                                                 keyPath:nil
                                                                 mapping:nil
                                                          withParameters:nil
                                                       withIndicatorView:nil
                                                      withLoadingMessage:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
        withSubRequestUrl:(NSString*)subUrl
        withCancelSubject:(NSString*)cancelSubject{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                       withSubRequestUrl:subUrl
                                                                 keyPath:nil
                                                                 mapping:nil
                                                          withParameters:nil
                                                       withIndicatorView:nil
                                                      withLoadingMessage:nil
                                                       withCancelSubject:cancelSubject
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
        withSubRequestUrl:(NSString*)subUrl
           withParameters:(NSDictionary*)params
        withCancelSubject:(NSString*)cancelSubject{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                       withSubRequestUrl:subUrl
                                                                 keyPath:nil
                                                                 mapping:nil
                                                          withParameters:params
                                                       withIndicatorView:nil
                                                      withLoadingMessage:nil
                                                       withCancelSubject:cancelSubject
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
        withSubRequestUrl:(NSString*)subUrl
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
        withCancelSubject:(NSString*)cancelSubject
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                       withSubRequestUrl:subUrl
                                                                 keyPath:keyPath
                                                                 mapping:mapping
                                                          withParameters:nil
                                                       withIndicatorView:nil
                                                      withLoadingMessage:nil
                                                       withCancelSubject:cancelSubject withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}


+ (id)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate
                        keyPath:(NSString*)keyPath
                        mapping:(GQObjectMapping*)mapping
                 withParameters:(NSDictionary*)params
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                                 keyPath:keyPath
                                                                 mapping:mapping
                                                          withParameters:params
                                                       withIndicatorView:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:YES
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
           withParameters:(NSDictionary*)params
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                                 keyPath:keyPath
                                                                 mapping:mapping
                                                          withParameters:params
                                                       withIndicatorView:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
           withParameters:(NSDictionary*)params
             withCacheKey:(NSString*)cache
            withCacheType:(DataCacheManagerCacheType)cacheType
{
    
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                                 keyPath:keyPath
                                                                 mapping:mapping
                                                          withParameters:params
                                                       withIndicatorView:nil
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:cache
                                                           withCacheType:cacheType
                                                            withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
        withSubRequestUrl:(NSString*)subUrl
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
           withParameters:(NSDictionary*)params
        withCancelSubject:(NSString*)cancelSubject
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                       withSubRequestUrl:subUrl
                                                                 keyPath:keyPath
                                                                 mapping:mapping
                                                          withParameters:params withIndicatorView:nil withLoadingMessage:nil withCancelSubject:cancelSubject withSilentAlert:NO withCacheKey:nil withCacheType:DataCacheManagerCacheTypeMemory withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
        withIndicatorView:(UIView*)indiView
        withCancelSubject:(NSString*)cancelSubject
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                                 keyPath:keyPath
                                                                 mapping:mapping
                                                          withParameters:nil
                                                       withIndicatorView:indiView
                                                       withCancelSubject:cancelSubject
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
        withIndicatorView:(UIView*)indiView
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                                 keyPath:keyPath
                                                                 mapping:mapping
                                                          withParameters:nil
                                                       withIndicatorView:indiView
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
           withParameters:(NSDictionary*)params
        withIndicatorView:(UIView*)indiView
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                                 keyPath:keyPath
                                                                 mapping:mapping
                                                          withParameters:params
                                                       withIndicatorView:indiView
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
           withParameters:(NSDictionary*)params
        withIndicatorView:(UIView*)indiView
             withCacheKey:(NSString*)cache
            withCacheType:(DataCacheManagerCacheType)cacheType
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                                 keyPath:keyPath
                                                                 mapping:mapping
                                                          withParameters:params
                                                       withIndicatorView:indiView
                                                       withCancelSubject:nil
                                                         withSilentAlert:NO
                                                            withCacheKey:cache
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
           withParameters:(NSDictionary*)params
        withIndicatorView:(UIView*)indiView
        withCancelSubject:(NSString*)cancelSubject
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                                 keyPath:keyPath
                                                                 mapping:mapping
                                                          withParameters:params
                                                       withIndicatorView:indiView
                                                       withCancelSubject:cancelSubject
                                                         withSilentAlert:NO
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
               keyPath:(NSString*)keyPath
               mapping:(GQObjectMapping*)mapping
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cacheKey
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath
{
    
    return [self initWithDelegate:delegate
                withSubRequestUrl:nil
                          keyPath:keyPath
                          mapping:mapping
                   withParameters:params
                withIndicatorView:indiView
               withLoadingMessage:nil
                withCancelSubject:cancelSubject
                  withSilentAlert:silent
                     withCacheKey:cacheKey
                    withCacheType:cacheType
                     withFilePath:localFilePath];
}

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
     withSubRequestUrl:(NSString*)subUrl
               keyPath:(NSString*)keyPath
               mapping:(GQObjectMapping*)mapping
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
    withLoadingMessage:(NSString*)loadingMessage
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath
{
    self = [super init];
    if(self) {
        _parmaterEncoding = [self getParameterEncoding];
        _loading = NO;
        _keyPath = keyPath;
        _mapping = mapping;
        _delegate = delegate;
        
        if (!_requestUrl || ![_requestUrl length]) {
            _requestUrl = [self getRequestUrl];
        }
        if (subUrl) {
            _requestUrl = [NSString stringWithFormat:@"%@%@",_requestUrl,subUrl];
        }
        NSAssert(_requestUrl != nil || [_requestUrl length] > 0, @"invalid request url");
//        _indicatorView = indiView;
        _useSilentAlert = silent;
        _cacheKey = cache;
        if (_cacheKey && [_cacheKey length] > 0) {
            _usingCacheData = YES;
        }
        _cacheType = cacheType;
        if (cancelSubject && cancelSubject.length > 0) {
            _cancelSubject = cancelSubject;
        }
        
        if (_cancelSubject && _cancelSubject.length >0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequest) name:_cancelSubject object:nil];
        }
        if (localFilePath) {
            _filePath = localFilePath;
        }
//        self.loadingMessage = loadingMessage;
//        if (!self.loadingMessage) {
//            self.loadingMessage = DEFAULT_LOADING_MESSAGE;
//        }
        _requestStartDate = [NSDate date];
        _userInfo = [[NSDictionary alloc] initWithDictionary:params];
        if ([self useDumpyData]) {
            [self processDumpyRequest];
        }
        else {
            BOOL useCurrentCache = NO;
            NSObject *cacheData = [[GQDataCacheManager sharedManager] getCachedObjectByKey:_cacheKey];
            if (cacheData) {
                useCurrentCache = [self onReceivedCacheData:cacheData];
            }
            if (!useCurrentCache) {
                _usingCacheData = NO;
                [self doRequestWithParams:params];
                GQDINFO(@"request %@ is created", [self class]);
            }else{
                _usingCacheData = YES;
                [self performSelector:@selector(doRelease) withObject:nil afterDelay:0.1f];
            }
        }
    }
    return self;
}

#pragma mark - init methods using block

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                         withSubRequestUrl:nil
                                                         withIndicatorView:indiView
                                                                   keyPath:keyPath
                                                                   mapping:mapping
                                                        withLoadingMessage:nil
                                                         withCancelSubject:nil
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:nil
                                                            onRequestStart:nil
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:nil
                                                           onRequestFailed:nil
                                                         onProgressChanged:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
            onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                         withSubRequestUrl:nil
                                                         withIndicatorView:indiView
                                                                   keyPath:keyPath
                                                                   mapping:mapping
                                                        withLoadingMessage:nil
                                                         withCancelSubject:nil
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:nil
                                                            onRequestStart:nil
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:nil
                                                           onRequestFailed:onFailedBlock
                                                         onProgressChanged:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                         withSubRequestUrl:nil
                                                         withIndicatorView:indiView
                                                                   keyPath:keyPath
                                                                   mapping:mapping
                                                        withLoadingMessage:nil
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:nil
                                                            onRequestStart:nil
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:nil
                                                           onRequestFailed:nil
                                                         onProgressChanged:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
          withSubRequestUrl:(NSString*)subUrl
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                         withSubRequestUrl:subUrl
                                                         withIndicatorView:indiView
                                                                   keyPath:keyPath
                                                                   mapping:mapping
                                                        withLoadingMessage:nil
                                                         withCancelSubject:nil
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:nil
                                                            onRequestStart:nil
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:nil
                                                           onRequestFailed:nil
                                                         onProgressChanged:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
          withSubRequestUrl:(NSString*)subUrl
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock;
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                         withSubRequestUrl:subUrl
                                                         withIndicatorView:indiView
                                                                   keyPath:keyPath
                                                                   mapping:mapping
                                                        withLoadingMessage:nil
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:nil
                                                            onRequestStart:nil
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:nil
                                                           onRequestFailed:nil
                                                         onProgressChanged:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
             onRequestStart:(void(^)(GQBaseDataRequest *request))onStartBlock
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
          onRequestCanceled:(void(^)(GQBaseDataRequest *request))onCanceledBlock
            onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock
{
    
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                         withSubRequestUrl:nil
                                                         withIndicatorView:indiView
                                                                   keyPath:keyPath
                                                                   mapping:mapping
                                                        withLoadingMessage:nil
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:nil
                                                            onRequestStart:onStartBlock
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:onCanceledBlock
                                                           onRequestFailed:onFailedBlock
                                                         onProgressChanged:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
          withSubRequestUrl:(NSString*)subUrl
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
             onRequestStart:(void(^)(GQBaseDataRequest *request))onStartBlock
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
          onRequestCanceled:(void(^)(GQBaseDataRequest *request))onCanceledBlock
            onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                         withSubRequestUrl:subUrl
                                                         withIndicatorView:indiView
                                                                   keyPath:nil
                                                                   mapping:nil
                                                        withLoadingMessage:nil
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:nil
                                                            onRequestStart:onStartBlock
                                   
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:onCanceledBlock
                                                           onRequestFailed:onFailedBlock
                                                         onProgressChanged:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

- (id)initWithParameters:(NSDictionary*)params
       withSubRequestUrl:(NSString*)subUrl
       withIndicatorView:(UIView*)indiView
                 keyPath:(NSString*)keyPath
                 mapping:(GQObjectMapping*)mapping
      withLoadingMessage:(NSString*)loadingMessage
       withCancelSubject:(NSString*)cancelSubject
         withSilentAlert:(BOOL)silent
            withCacheKey:(NSString*)cache
           withCacheType:(DataCacheManagerCacheType)cacheType
            withFilePath:(NSString*)localFilePath
          onRequestStart:(void(^)(GQBaseDataRequest *request))onStartBlock
       onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
       onRequestCanceled:(void(^)(GQBaseDataRequest *request))onCanceledBlock
         onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock
       onProgressChanged:(void(^)(GQBaseDataRequest *request, CGFloat))onProgressChangedBlock
{
    self = [super init];
    if(self) {
        _parmaterEncoding = [self getParameterEncoding];
        _loading = NO;
        _keyPath = keyPath;
        _mapping = mapping;
        
        if (!_requestUrl || ![_requestUrl length]) {
            _requestUrl = [self getRequestUrl];
        }
        if (subUrl) {
            _requestUrl = [NSString stringWithFormat:@"%@%@",_requestUrl,subUrl];
        }
        NSAssert(_requestUrl != nil || [_requestUrl length] > 0, @"invalid request url");
//        _indicatorView = indiView;
        _useSilentAlert = silent;
        _cacheKey = cache;
        if (_cacheKey && [_cacheKey length] > 0) {
            _usingCacheData = YES;
        }
        _cacheType = cacheType;
        if (cancelSubject && cancelSubject.length > 0) {
            _cancelSubject = cancelSubject;
        }
        
        if (_cancelSubject && _cancelSubject) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequest) name:_cancelSubject object:nil];
        }
        if (onStartBlock) {
            _onRequestStartBlock = [onStartBlock copy];
        }
        if (onFinishedBlock) {
            _onRequestFinishBlock = [onFinishedBlock copy];
        }
        if (onCanceledBlock) {
            _onRequestCanceled = [onCanceledBlock copy];
        }
        if (onFailedBlock) {
            _onRequestFailedBlock = [onFailedBlock copy];
        }
        if (onProgressChangedBlock) {
            _onRequestProgressChangedBlock = [onProgressChangedBlock copy];
        }
        if (localFilePath) {
            _filePath = localFilePath;
        }
//        self.loadingMessage = loadingMessage;
//        if (!self.loadingMessage) {
//            self.loadingMessage = DEFAULT_LOADING_MESSAGE;
//        }
        _requestStartDate = [NSDate date];
        _userInfo = [[NSDictionary alloc] initWithDictionary:params];
        if ([self useDumpyData]) {
            [self processDumpyRequest];
        }
        else {
            BOOL useCurrentCache = NO;
            NSObject *cacheData = [[GQDataCacheManager sharedManager] getCachedObjectByKey:_cacheKey];
            if (cacheData) {
                useCurrentCache = [self onReceivedCacheData:cacheData];
            }
            if (!useCurrentCache) {
                _usingCacheData = NO;
                [self doRequestWithParams:params];
                GQDINFO(@"request %@ is created", [self class]);
            }else{
                _usingCacheData = YES;
                [self performSelector:@selector(doRelease) withObject:nil afterDelay:0.1f];
            }
        }
    }
    return self;
}

#pragma mark - file download related init methods
+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
          onProgressChanged:(void(^)(GQBaseDataRequest *request,CGFloat))onProgressChangedBlock
{
    
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                         withSubRequestUrl:nil
                                                         withIndicatorView:indiView
                                                                   keyPath:nil
                                                                   mapping:nil
                                                        withLoadingMessage:nil
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:localFilePath
                                                            onRequestStart:nil
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:nil
                                                           onRequestFailed:nil
                                                         onProgressChanged:onProgressChangedBlock];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
            onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock
          onProgressChanged:(void(^)(GQBaseDataRequest *request,CGFloat progress))onProgressChangedBlock
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                         withSubRequestUrl:nil
                                                         withIndicatorView:indiView
                                                                   keyPath:keyPath
                                                                   mapping:mapping
                                                        withLoadingMessage:nil
                                                         withCancelSubject:cancelSubject
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:localFilePath
                                                            onRequestStart:nil
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:nil
                                                           onRequestFailed:onFailedBlock
                                                         onProgressChanged:onProgressChangedBlock];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

#pragma mark - lifecycle methods

- (void)doRelease
{
    if (_cancelSubject && _cancelSubject) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:_cancelSubject
                                                      object:nil];
    }
    //remove self from Request Manager to release self;
    [[GQDataRequestManager sharedManager] removeRequest:self];
}

- (void)dealloc
{
    GQDINFO(@"request %@ is released, time spend on this request:%f seconds",
             [self class],[[NSDate date] timeIntervalSinceDate:_requestStartDate]);
//    if (_indicatorView) {
//        //make sure indicator is closed
//        [self showIndicator:NO];
//    }
}

#pragma mark - util methods

+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse
{
    NSData *jsonData = [cachedResponse dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
}

- (void)generateRequestHandler
{
    _requestDataHandler = [[GQRequestJsonDataHandler alloc] init];
}

- (BOOL)onReceivedCacheData:(NSObject*)cacheData
{
    // handle cache data in subclass
    // return yes to finish request, return no to continue request from server
    return NO;
}

- (void)processResult
{
    
}

- (BOOL)useDumpyData
{
    return USE_DUMPY_DATA;
}

- (NSString*)dumpyResponseString
{
    return nil;
}

- (BOOL)processDownloadFile
{
    return FALSE;
}

- (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString) {
        return newString;
    }
    return @"";
}

- (void)cancelRequest
{
}

- (void)showNetowrkUnavailableAlertView:(NSString*)message
{
    if (message && [message length]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

//- (void)showIndicator:(BOOL)bshow
//{
//    _loading = bshow;
//    if (bshow && _indicatorView) {
//        if (!_maskActivityView) {
//            _maskActivityView = [GQMaskActivityView loadFromXib];
//            [_maskActivityView showInView:self.indicatorView withHintMessage:self.loadingMessage onCancleRequest:^(GQMaskActivityView *hintView){
//                [self cancelRequest];
//            }];
//        }
//    }else {
//        if (_maskActivityView) {
//            [_maskActivityView hide];
//            _maskActivityView = nil;
//        }
//    }
//}

- (void)cacheResult
{
    if (_responseResult.dictionary && _cacheKey) {
        if (DataCacheManagerCacheTypeMemory == _cacheType) {
            [[GQDataCacheManager sharedManager] addObjectToMemory:_responseResult.rawDictionary forKey:_cacheKey];
        }
        else{
            [[GQDataCacheManager sharedManager] addObject:_responseResult.rawDictionary forKey:_cacheKey];
        }
    }
}

- (void)notifyDelegateRequestDidSuccess
{
    if (_onRequestFinishBlock) {
        _onRequestFinishBlock(self, _responseResult);
    }else if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(requestDidFinishLoad:mappingResult:)]){
            [self.delegate requestDidFinishLoad:self mappingResult:_responseResult];
        }
    }
}

- (void)notifyDelegateRequestDidErrorWithError:(NSError*)error
{
    //using block callback
    if (_onRequestFailedBlock) {
        _onRequestFailedBlock(self, error);
    }else if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(request:didFailLoadWithError:)]){
            [self.delegate request:self didFailLoadWithError:error];
        }
    }
}

- (BOOL)isDownloadFileRequest
{
    return _filePath && [_filePath length];
}

- (void)handleResponseString:(id)resultString
{
    __block BOOL success = FALSE;
    __block NSError *errorInfo = nil;
    __block __weak typeof(self) weakSelf = self;
    dispatch_block_t callback = ^{ @autoreleasepool {
        if (success) {
            [weakSelf cacheResult];
            [weakSelf notifyDelegateRequestDidSuccess];
        }
        else {
            GQDERROR(@"parse error %@", errorInfo);
            [weakSelf notifyDelegateRequestDidErrorWithError:errorInfo];
        }
    }
    };
    if([self isDownloadFileRequest]) {
        success = [self processDownloadFile];
        [self processResult];
        dispatch_async(dispatch_get_main_queue(), callback);
    }
    else {
        self.rawResultString = resultString;
        //        GQDINFO(@"raw response string:%@", self.rawResultString);
        //add callback here
        if (!self.rawResultString || ![self.rawResultString length]) {
            GQDERROR(@"!empty response error with request:%@", [self class]);
            [self notifyDelegateRequestDidErrorWithError:nil];
        }
        [self generateRequestHandler];
        id response = [self.requestDataHandler parseJsonString:self.rawResultString error:&errorInfo];
        if (errorInfo) {
            success = FALSE;
            dispatch_async(dispatch_get_main_queue(), callback);
        }
        else {
            [[GQMappingManager sharedManager] mapWithSourceData:response objectMapping:_mapping keyPath:_keyPath completionBlock:^(GQMappingResult *result, NSError *error) {
                _responseResult = result;
                if (result) {
                    success = TRUE;
                }
                else {
                    success = FALSE;
                }
                errorInfo = error;
                [weakSelf processResult];
                dispatch_async(dispatch_get_main_queue(), callback);
            }];
        }
    }
}

#pragma mark - hook methods
- (void)doRequestWithParams:(NSDictionary*)params
{
    SHOULDOVERRIDE(@"GQBaseDataRequest", NSStringFromClass([self class]));
    GQDERROR(@"should implement request logic here!");
}

- (NSStringEncoding)getResponseEncoding
{
    return NSUTF8StringEncoding;
    //return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
}

- (NSDictionary*)getStaticParams
{
    return nil;
}

- (GQParameterEncoding)getParameterEncoding{
    return GQURLParameterEncoding;
}

- (GQRequestMethod)getRequestMethod
{
    return GQRequestMethodGet;
}

- (NSString*)getRequestUrl
{
    NSString *reason = [NSString stringWithFormat:@"This is a abstract method. You should subclass of GQBaseDataRequest and override it!"];
    @throw [NSException exceptionWithName:@"Logic Error" reason:reason userInfo:nil];
    return @"";
}

- (void)processDumpyRequest
{
    [self showIndicator:TRUE];
    [self dumpyRequestDone];
    [self doRelease];
}

- (void)dumpyRequestDone
{
    [self showIndicator:FALSE];
    NSString *jsonString = [self dumpyResponseString];
    [self handleResponseString:jsonString];
}



@end
