//
//  GQBaseDataRequest.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseDataRequest.h"
#import "GQDataRequestManager.h"
#import "GQRequestDataHandleHeader.h"
#import "GQMappingHeader.h"
#import "GQObjectSingleton.h"
#import "GQMaskActivityView.h"
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
 *  @param onRechiveResponse      收到请求头block
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
          onRequestStart:(GQRequestCanceled)onStartBlock
       onRechiveResponse:(GQRequestRechiveResponse)onRechiveResponse
       onRequestFinished:(GQRequestFinished)onFinishedBlock
       onRequestCanceled:(GQRequestCanceled)onCanceledBlock
         onRequestFailed:(GQRequestFailed)onFailedBlock
       onProgressChanged:(GQProgressChanged)onProgressChangedBlock;

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

@synthesize requestUrlChain = _requestUrlChain;
@synthesize requestMethodChain = _requestMethodChain;
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
@synthesize onRechiveResponseBlockChain = _onRechiveResponseBlockChain;
@synthesize onFinishedBlockChain = _onFinishedBlockChain;
@synthesize onCanceledBlockChain = _onCanceledBlockChain;
@synthesize onFailedBlockChain = _onFailedBlockChain;
@synthesize onProgressChangedBlockChain = _onProgressChangedBlockChain;
@synthesize startRequestChain = _startRequestChain;
@synthesize timeOutIntervalChain = _timeOutIntervalChain;

+ (instancetype)prepareRequset{
    GQBaseDataRequest *request = [[[self class] alloc] init];
    [[GQDataRequestManager sharedManager] addRequest:request];
    return request;
}

GQChainRequestDefine(requestUrlChain, requestUrl, NSString *, GQChainObjectRequest);
GQChainRequestDefine(requestMethodChain, requestMethod, NSInteger , GQChainStuctRequest);
GQChainRequestDefine(delegateChain, delegate, id, GQChainObjectRequest);
GQChainRequestDefine(subRequestUrlChain,subRequestUrl, NSString *, GQChainObjectRequest);
GQChainRequestDefine(cancelSubjectChain, cancelSubject, NSString *, GQChainObjectRequest);
GQChainRequestDefine(keyPathChain, keyPath, NSString *, GQChainObjectRequest);
GQChainRequestDefine(timeOutIntervalChain, timeOutInterval, NSInteger, GQChainStuctRequest);
GQChainRequestDefine(mappingChain, mapping, GQObjectMapping *, GQChainObjectRequest);
GQChainRequestDefine(parametersChain, parameters, NSDictionary *, GQChainObjectRequest);
GQChainRequestDefine(indicatorViewChain, indicatorView, UIView *, GQChainObjectRequest);
GQChainRequestDefine(localFilePathChain, localFilePath, NSString * , GQChainObjectRequest);
GQChainRequestDefine(cacheKeyChain, cacheKey, NSString * , GQChainObjectRequest);
GQChainRequestDefine(cacheTypeChain, cacheType, NSInteger , GQChainStuctRequest);

GQChainRequestDefine(onStartBlockChain, onRequestStart, GQRequestStart, GQChainBlockRequestStart);
GQChainRequestDefine(onRechiveResponseBlockChain, onRequestRechiveResponse, GQRequestRechiveResponse, GQChainBlockRequestRechiveResponse);
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
GQMethodRequestDefine(onRequestRechiveResponse, GQRequestRechiveResponse);
GQMethodRequestDefine(onRequestFinished,GQRequestFinished);
GQMethodRequestDefine(onRequestCanceled,GQRequestCanceled);
GQMethodRequestDefine(onRequestFailed,GQRequestFailed);
GQMethodRequestDefine(onProgressChanged,GQProgressChanged);

- (void)startRequest{
    
    NSAssert(!_loading, @"The request has already begun");
    
    _parmaterEncoding = [self getParameterEncoding];
    _loading = NO;
    
    if (_requestMethod == 0) {
        _requestMethod = [self getRequestMethod];
    }
    
    if (!_requestUrl || ![_requestUrl length]) {
        _requestUrl = [self getRequestUrl];
    }
    
    if ([self getBaseUrl]) {
        _requestUrl = [NSString stringWithFormat:@"%@%@",[self getBaseUrl],_requestUrl];
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
            GQDINFO(@"request %@ is created , url is \"%@\"", [self class],_requestUrl);
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
        
        _subRequestUrl = subUrl;
        
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

+ (id)requestWithOnRequestFinished:(GQRequestFinished)onFinishedBlock
                   onRequestFailed:(GQRequestFailed)onFailedBlock{
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
                                                        onRechiveResponse:nil
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
                                                        withSubRequestUrl:nil
                                                        withIndicatorView:nil
                                                                  keyPath:nil
                                                                  mapping:nil
                                                        withCancelSubject:nil
                                                             withCacheKey:nil
                                                            withCacheType:GQDataCacheManagerMemory
                                                             withFilePath:nil
                                                           onRequestStart:nil
                                                        onRechiveResponse:nil
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
                                                        withSubRequestUrl:subUrl
                                                        withIndicatorView:nil
                                                                  keyPath:nil
                                                                  mapping:nil
                                                        withCancelSubject:nil
                                                             withCacheKey:nil
                                                            withCacheType:GQDataCacheManagerMemory
                                                             withFilePath:nil
                                                           onRequestStart:nil
                                                        onRechiveResponse:nil
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
                onRequestFinished:(GQRequestFinished)onFinishedBlock
                onRequestCanceled:(GQRequestCanceled)onCanceledBlock
                  onRequestFailed:(GQRequestFailed)onFailedBlock
                onProgressChanged:(GQProgressChanged)onProgressChangedBlock{
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
                                                        onRechiveResponse:onRechiveResponse
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
          onRequestFinished:(GQRequestFinished)onFinishedBlock
            onRequestFailed:(GQRequestFailed)onFailedBlock
          onProgressChanged:(GQProgressChanged)onProgressChangedBlock{
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
                                                        onRechiveResponse:nil
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
          onRequestStart:(GQRequestStart)onStartBlock
          onRechiveResponse:(GQRequestRechiveResponse)onRechiveResponse
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
        
        if (onStartBlock) {
            _onRequestStart = [onStartBlock copy];
        }
        
        if (onRechiveResponse) {
            _onRequestRechiveResponse = [onRechiveResponse copy];
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

- (GQRequestDataHandler*)generateRequestHandler
{
    return [[GQRequestJsonDataHandler alloc] init];
}

- (NSData *)getCertificateData{
    return nil;
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
    return NO;
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
    if (bshow && _indicatorView) {
        if (!_maskActivityView) {
            _maskActivityView = [GQMaskActivityView loadView];
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

- (void)notifyRequestDidStart
{
    if (_onRequestStart) {
        _onRequestStart(self);
    }else if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(requestDidStartLoad:)]){
            [self.delegate requestDidStartLoad:self];
        }
    }
}

- (void)notifyRequestDidChange:(float)progress
{
    if (_onProgressChanged) {
        _onProgressChanged(self,progress);
    }else if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(request:progressChanged:)]){
            [self.delegate request:self progressChanged:progress];
        }
    }
}

- (NSURLSessionResponseDisposition)notifyRequestRechiveResponse:(NSURLResponse *)response
{
    NSURLSessionResponseDisposition  disposition = NSURLSessionResponseAllow;
    if (_onRequestRechiveResponse) {
       disposition = _onRequestRechiveResponse(self, response);
    }else if (self.delegate){
        if ([self.delegate respondsToSelector:@selector(requestRechiveResponse:urlResponse:)]) {
            disposition =[self.delegate requestRechiveResponse:self urlResponse:response];
        }
    }
    return disposition;
}

- (void)notifyRequestDidSuccess
{
    if (_onRequestFinished) {
        _onRequestFinished(self, _responseResult);
    }else if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(requestDidFinishLoad:mappingResult:)]){
            [self.delegate requestDidFinishLoad:self mappingResult:_responseResult];
        }
    }
}

- (void)notifyRequestDidErrorWithError:(NSError*)error
{
    if (_onRequestFailed) {
        _onRequestFailed(self, error);
    }else if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(request:didFailLoadWithError:)]){
            [self.delegate request:self didFailLoadWithError:error];
        }
    }
}

- (void)notifyRequestDidCancel
{
    if (_onRequestCanceled) {
        _onRequestCanceled(self);
    }else if (self.delegate) {
        if([self.delegate respondsToSelector:@selector(requestDidCancelLoad:)]){
            [self.delegate requestDidCancelLoad:self];
        }
    }
}

- (BOOL)isDownloadFileRequest
{
    return _localFilePath && [_localFilePath length];
}

- (void)handleResponseString:(id)result
{
    __block BOOL success = FALSE;
    __block NSError *errorInfo = nil;
    dispatch_block_t callback = ^{
        @autoreleasepool {
            if (success) {
                [self cacheResult];
                [self notifyRequestDidSuccess];
            }
            else {
                [self notifyRequestDidErrorWithError:errorInfo];
            }
        }
    };
    if([self isDownloadFileRequest]) {
        success = [self processDownloadFile];
        [self processResult];
        dispatch_async(dispatch_get_main_queue(), callback);
    }
    else {
        self.rawResultData = result;
        NSString *rawResultString = [[NSString alloc] initWithData:self.rawResultData encoding:[self getResponseEncoding]];
        //add callback here
        if (!rawResultString|| ![rawResultString length]) {
            errorInfo = [NSError errorWithDomain:@"empty data" code:GQRequestErrorNoData userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), callback);
        }else{
            _requestDataHandler = [self generateRequestHandler];
            id response = [self.requestDataHandler parseJsonString:rawResultString error:&errorInfo];
            if (errorInfo) {
                errorInfo = [NSError errorWithDomain:errorInfo?errorInfo.domain:@"" code:GQRequestErrorParse userInfo:errorInfo?errorInfo.userInfo:@{}];
                success = FALSE;
                dispatch_async(dispatch_get_main_queue(), callback);
            }
            else {
                [[GQMappingManager sharedManager]mapWithSourceData:response
                                                      originalData:self.rawResultData
                                                     objectMapping:_mapping keyPath:_keyPath
                                                   completionBlock:^(GQMappingResult *result, NSError *error)
                 {
                     _responseResult = result;
                     if (result) {
                         success = TRUE;
                     }
                     else {
                         success = FALSE;
                     }
                     if (error) {
                         errorInfo = [NSError errorWithDomain:error.domain code:GQRequestErrorMap userInfo:error.userInfo];
                     }
                     [self processResult];
                     dispatch_async(dispatch_get_main_queue(), callback);
                 }];
            }
        }
    }
}

#pragma mark - hook methods
- (void)doRequestWithParams:(NSDictionary*)params
{
    SHOULDOVERRIDE(@"GQBaseDataRequest", NSStringFromClass([self class]));
}

- (NSStringEncoding)getResponseEncoding
{
    return NSUTF8StringEncoding;
}

- (NSDictionary*)getStaticParams
{
    return nil;
}

- (NSInteger)getTimeOutInterval
{
    return 30;
}

- (GQParameterEncoding)getParameterEncoding
{
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

- (NSString *)getBaseUrl
{
    NSString *reason = [NSString stringWithFormat:@"This is a abstract method. You should subclass of GQBaseDataRequest and override it!"];
    @throw [NSException exceptionWithName:@"Logic Error" reason:reason userInfo:nil];
    return @"";
}

- (NSString *)getLoadingMessage
{
    return @"加载中...";
}

- (GQObjectMapping *)getMapping
{
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(rand()/(double)RAND_MAX * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSData *jsonData = [[self dumpyResponseString] dataUsingEncoding:[self getResponseEncoding]];
        [self handleResponseString:jsonData];
    });
}

@end
