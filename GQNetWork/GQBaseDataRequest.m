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
#import "GQObjectSingleton.h"
#import "GQDebug.h"

@interface GQBaseDataRequest()

/**
 *  Block实例方法
 *
 *  @param params                 请求体
 *  @param subUrl                 拼接url
 *  @param indiView               正在加载maskview
 *  @param keyPath                需要过滤的key
 *  @param mapping                映射map
 *  @param loadingMessage         正在加载弹框显示的文字
 *  @param cancelSubject          NSNotificationCenter 取消key
 *  @param cache                  缓存key
 *  @param cacheType              缓存类型
 *  @param localFilePath          下载到什么文件位置
 *  @param onStartBlock           请求开始block
 *  @param onFinishedBlock        请求完成block
 *  @param onCanceledBlock        请求取消block
 *  @param onFailedBlock          请求失败block
 *  @param onProgressChangedBlock 请求百分比变化block
 *
 *  @return GQBaseDataRequest
 */
- (id)initWithParameters:(NSDictionary*)params
       withSubRequestUrl:(NSString*)subUrl
       withIndicatorView:(UIView*)indiView
                 keyPath:(NSString*)keyPath
                 mapping:(GQObjectMapping*)mapping
       withCancelSubject:(NSString*)cancelSubject
            withCacheKey:(NSString*)cache
           withCacheType:(GQDataCacheManagerType)cacheType
            withFilePath:(NSString*)localFilePath
          onRequestStart:(void(^)(GQBaseDataRequest *request))onStartBlock
       onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
       onRequestCanceled:(void(^)(GQBaseDataRequest *request))onCanceledBlock
         onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock
       onProgressChanged:(void(^)(GQBaseDataRequest *request, CGFloat))onProgressChangedBlock;

/**
 *  代理实例方法
 *
 *  @param delegate       代理
 *  @param subUrl         拼接url
 *  @param keyPath        需要过滤的key
 *  @param mapping        映射map
 *  @param params         请求体
 *  @param indiView       maskview显示在你的view
 *  @param loadingMessage 正在加载弹框显示的文字
 *  @param cancelSubject  NSNotificationCenter 取消key
 *  @param cache          缓存key
 *  @param cacheType      缓存类型
 *  @param localFilePath  下载到什么文件位置
 *
 *  @return GQBaseDataRequest
 */
- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
     withSubRequestUrl:(NSString*)subUrl
               keyPath:(NSString*)keyPath
               mapping:(GQObjectMapping*)mapping
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
          withCacheKey:(NSString*)cache
         withCacheType:(GQDataCacheManagerType)cacheType
          withFilePath:(NSString*)localFilePath;

@end

@implementation GQBaseDataRequest

@synthesize delegateChain = _delegateChain;
@synthesize subRequestUrlChain = _subRequestUrlChain;
@synthesize cancelSubjectChain = _cancelSubjectChain;
@synthesize keyPathChain = _keyPathChain;
@synthesize mappingChain = _mappingChain;
@synthesize parametersChain = _parametersChain;
@synthesize indicatorViewChain = _indicatorViewChain;
@synthesize cacheKeyChain = _cacheKeyChain;
@synthesize cacheTypeChain = _cacheTypeChain;
@synthesize localFilePathChain = _localFilePathChain;
@synthesize onStartBlockChain = _onStartBlockChain;
@synthesize onFinishedBlockChain = _onFinishedBlockChain;
@synthesize onCanceledBlockChain = _onCanceledBlockChain;
@synthesize onFailedBlockChain = _onFailedBlockChain;
@synthesize onProgressChangedBlockChain = _onProgressChangedBlockChain;
@synthesize startRequestChain = _startRequestChain;

+ (instancetype)prepareRequset{
    GQBaseDataRequest *request = [[[self class] alloc] init];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

GQChainRequestDefine(delegateChain, delegate, id, GQChainObjectRequest);
GQChainRequestDefine(subRequestUrlChain,subRequestUrl, NSString *, GQChainObjectRequest);
GQChainRequestDefine(cancelSubjectChain, cancelSubject, NSString *, GQChainObjectRequest);
GQChainRequestDefine(keyPathChain, keyPath, NSString *, GQChainObjectRequest);
GQChainRequestDefine(mappingChain, mapping, GQObjectMapping *, GQChainObjectRequest);
GQChainRequestDefine(parametersChain, parameters, NSDictionary *, GQChainObjectRequest);
GQChainRequestDefine(indicatorViewChain, indicatorView, UIView *, GQChainObjectRequest);
GQChainRequestDefine(localFilePathChain, localFilePath, NSString * , GQChainObjectRequest);
GQChainRequestDefine(cacheKeyChain, cacheKey, NSString * , GQChainObjectRequest);
GQChainRequestDefine(cacheTypeChain, cacheType, GQDataCacheManagerType , GQChainStuctRequest);

GQChainRequestDefine(onStartBlockChain, onRequestStart, GQRequestStart, GQChainBlockRequestStart);
GQChainRequestDefine(onFinishedBlockChain, onRequestFinished, GQRequestFinished, GQChainBlockRequestFinished);
GQChainRequestDefine(onCanceledBlockChain, onRequestCanceled, GQRequestCanceled, GQChainBlockRequestCanceled);
GQChainRequestDefine(onFailedBlockChain, onRequestFailed, GQRequestFailed, GQChainBlockRequestFailed);
GQChainRequestDefine(onProgressChangedBlockChain, onProgressChanged, GQProgressChanged, GQChainBlockProgressChanged);

- (GQChainBlockStartRequest)startRequestChain{
    __weak typeof(self) weakSelf = self;
    if (!_startRequestChain) {
        _startRequestChain = ^(){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf startRequest];
        };
    }
    return _startRequestChain;
}

GQMethodRequestDefine(onRequestStart,GQRequestStart);
GQMethodRequestDefine(onRequestFinished,GQRequestFinished);
GQMethodRequestDefine(onRequestCanceled,GQRequestCanceled);
GQMethodRequestDefine(onRequestFailed,GQRequestFailed);
GQMethodRequestDefine(onProgressChanged,GQProgressChanged);

- (void)startRequest{
    
    NSAssert(!_loading, @"The request has already begun");
    
    _parmaterEncoding = [self getParameterEncoding];
    _loading = NO;
    
    if (!_requestUrl || ![_requestUrl length]) {
        _requestUrl = [self getRequestUrl];
    }
    if (_subRequestUrl) {
        _requestUrl = [NSString stringWithFormat:@"%@%@",_requestUrl,_subRequestUrl];
    }
    NSAssert(_requestUrl != nil || [_requestUrl length] > 0, @"invalid request url");
    if (_cacheKey && [_cacheKey length] > 0) {
        _usingCacheData = YES;
    }
    if (_cancelSubject && _cancelSubject.length >0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequest) name:_cancelSubject object:nil];
    }
    _requestStartDate = [NSDate date];
    _userInfo = [[NSMutableDictionary alloc] initWithDictionary:_parameters];
    if ([self getStaticParams]) {
        [_userInfo addEntriesFromDictionary:[self getStaticParams]];
    }
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
            [self doRequestWithParams:_userInfo];
            GQDINFO(@"request %@ is created", [self class]);
        }else{
            _usingCacheData = YES;
            [self performSelector:@selector(doRelease) withObject:nil afterDelay:0.1f];
        }
    }
}

#pragma mark - class methods using delegate

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                      withSubRequestUrl:nil
                                                                keyPath:nil
                                                                mapping:nil
                                                         withParameters:nil
                                                      withIndicatorView:nil
                                                      withCancelSubject:nil
                                                           withCacheKey:nil
                                                          withCacheType:GQDataCacheManagerMemory
                                                           withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithRequestParameter:(GQRequestParameter *)parameterBody withDelegate:(id<DataRequestDelegate>)delegate
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                      withSubRequestUrl:parameterBody.subRequestUrl
                                                                keyPath:parameterBody.keyPath
                                                                mapping:parameterBody.mapping
                                                         withParameters:parameterBody.parameters
                                                      withIndicatorView:parameterBody.indicatorView
                                                      withCancelSubject:parameterBody.cancelSubject
                                                           withCacheKey:parameterBody.cacheKey
                                                          withCacheType:(parameterBody.cacheType?parameterBody.cacheType:GQDataCacheManagerMemory)
                                                           withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
           withParameters:(NSDictionary*)params{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                      withSubRequestUrl:nil
                                                                keyPath:nil
                                                                mapping:nil
                                                         withParameters:params
                                                      withIndicatorView:nil
                                                      withCancelSubject:nil
                                                           withCacheKey:nil
                                                          withCacheType:GQDataCacheManagerMemory
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
                                                      withCancelSubject:nil
                                                           withCacheKey:nil
                                                          withCacheType:GQDataCacheManagerMemory
                                                           withFilePath:nil];
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
                                                      withCancelSubject:cancelSubject
                                                           withCacheKey:nil
                                                          withCacheType:GQDataCacheManagerMemory
                                                           withFilePath:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
     withSubRequestUrl:(NSString*)subUrl
               keyPath:(NSString*)keyPath
               mapping:(GQObjectMapping*)mapping
        withParameters:(NSDictionary*)params
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
        _delegate = delegate;
        
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

#pragma mark - class methods using block

+ (id)requestWithOnRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
                   onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:nil
                                                        withSubRequestUrl:nil
                                                        withIndicatorView:nil
                                                                  keyPath:nil
                                                                  mapping:nil
                                                        withCancelSubject:nil
                                                             withCacheKey:nil
                                                            withCacheType:GQDataCacheManagerMemory
                                                             withFilePath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithWithParameters:(NSDictionary*)params
              onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
                onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                        withSubRequestUrl:nil
                                                        withIndicatorView:nil
                                                                  keyPath:nil
                                                                  mapping:nil
                                                        withCancelSubject:nil
                                                             withCacheKey:nil
                                                            withCacheType:GQDataCacheManagerMemory
                                                             withFilePath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithWithParameters:(NSDictionary*)params
              withSubRequestUrl:(NSString*)subUrl
              onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
                onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                        withSubRequestUrl:subUrl
                                                        withIndicatorView:nil
                                                                  keyPath:nil
                                                                  mapping:nil
                                                        withCancelSubject:nil
                                                             withCacheKey:nil
                                                            withCacheType:GQDataCacheManagerMemory
                                                             withFilePath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithRequestParameter:(GQRequestParameter *)parameterBody
                   onRequestStart:(void(^)(GQBaseDataRequest *request))onStartBlock
                onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
                onRequestCanceled:(void(^)(GQBaseDataRequest *request))onCanceledBlock
                  onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock
                onProgressChanged:(void(^)(GQBaseDataRequest *request, CGFloat progress))onProgressChangedBlock{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:parameterBody.parameters
                                                        withSubRequestUrl:parameterBody.subRequestUrl
                                                        withIndicatorView:parameterBody.indicatorView
                                                                  keyPath:parameterBody.keyPath
                                                                  mapping:parameterBody.mapping
                                                        withCancelSubject:parameterBody.cancelSubject
                                                             withCacheKey:parameterBody.cacheKey
                                                            withCacheType:parameterBody.cacheType
                                                             withFilePath:parameterBody.localFilePath
                                                           onRequestStart:onStartBlock
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:onCanceledBlock
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:onProgressChangedBlock];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
          withSubRequestUrl:(NSString*)subUrl
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
            onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock
          onProgressChanged:(void(^)(GQBaseDataRequest *request,CGFloat progress))onProgressChangedBlock{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                        withSubRequestUrl:subUrl
                                                        withIndicatorView:nil
                                                                  keyPath:nil
                                                                  mapping:nil
                                                        withCancelSubject:cancelSubject
                                                             withCacheKey:nil
                                                            withCacheType:GQDataCacheManagerMemory
                                                             withFilePath:localFilePath
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:onProgressChangedBlock];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

- (id)initWithParameters:(NSDictionary*)params
       withSubRequestUrl:(NSString*)subUrl
       withIndicatorView:(UIView*)indiView
                 keyPath:(NSString*)keyPath
                 mapping:(GQObjectMapping*)mapping
       withCancelSubject:(NSString*)cancelSubject
            withCacheKey:(NSString*)cache
           withCacheType:(GQDataCacheManagerType)cacheType
            withFilePath:(NSString*)localFilePath
          onRequestStart:(void(^)(GQBaseDataRequest *request))onStartBlock
       onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
       onRequestCanceled:(void(^)(GQBaseDataRequest *request))onCanceledBlock
         onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock
       onProgressChanged:(void(^)(GQBaseDataRequest *request, CGFloat))onProgressChangedBlock
{
    self = [super init];
    if(self) {
        _keyPath = keyPath;
        _mapping = mapping;
        
        _indicatorView = indiView;
        _cacheKey = cache;
        _cacheType = cacheType;
        _cancelSubject = cancelSubject;
        _localFilePath = localFilePath;
        _parameters = params;
        if (onStartBlock) {
            _onRequestStart = [onStartBlock copy];
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
    if (_indicatorView) {
        //make sure indicator is closed
        [self showIndicator:NO];
    }
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
    return GQUSE_DUMPY_DATA;
}

- (NSString*)dumpyResponseString
{
    return nil;
}

- (BOOL)processDownloadFile
{
    return FALSE;
}

- (void)cancelRequest
{
    
}

- (void)showIndicator:(BOOL)bshow
{
    _loading = bshow;
#if GQUSE_MaskView
    if (bshow && _indicatorView) {
        if (!_maskActivityView) {
            _maskActivityView = [GQMaskActivityView loadFromXib];
            [_maskActivityView showInView:_indicatorView withHintMessage:[self getLoadingMessage] onCancleRequest:^(GQMaskActivityView *hintView){
                [self cancelRequest];
            }];
        }
    }else {
        if (_maskActivityView) {
            [_maskActivityView hide];
            _maskActivityView = nil;
        }
    }
#endif
}

- (void)cacheResult
{
    if (_responseResult.dictionary && _cacheKey) {
        if (GQDataCacheManagerMemory == _cacheType) {
            [[GQDataCacheManager sharedManager] addObjectToMemory:_responseResult.rawDictionary forKey:_cacheKey];
        }
        else{
            [[GQDataCacheManager sharedManager] addObject:_responseResult.rawDictionary forKey:_cacheKey];
        }
    }
}

- (void)notifyDelegateRequestDidSuccess
{
    if (_onRequestFinished) {
        _onRequestFinished(self, _responseResult);
    }else if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(requestDidFinishLoad:mappingResult:)]){
            [self.delegate requestDidFinishLoad:self mappingResult:_responseResult];
        }
    }
}

- (void)notifyDelegateRequestDidErrorWithError:(NSError*)error
{
    if (_onRequestFailed) {
        _onRequestFailed(self, error);
    }else if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(request:didFailLoadWithError:)]){
            [self.delegate request:self didFailLoadWithError:error];
        }
    }
}

- (BOOL)isDownloadFileRequest
{
    return _localFilePath && [_localFilePath length];
}

- (void)handleResponseString:(id)resultString
{
    __block BOOL success = FALSE;
    __block NSError *errorInfo = nil;
    __block __weak typeof(self) weakSelf = self;
    dispatch_block_t callback = ^{
        @autoreleasepool {
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

- (NSString *)getLoadingMessage
{
    return DEFAULT_LOADING_MESSAGE;
}

- (GQObjectMapping *)getMapping{
    return nil;
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
