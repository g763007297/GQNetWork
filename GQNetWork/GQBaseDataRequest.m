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

@interface GQBaseDataRequest()
{
    GQObjectMapping    *_mapping;
}

@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) NSString *loadingMessage;

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
      withLoadingMessage:(NSString*)loadingMessage
       withCancelSubject:(NSString*)cancelSubject
            withCacheKey:(NSString*)cache
           withCacheType:(DataCacheManagerCacheType)cacheType
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
    withLoadingMessage:(NSString*)loadingMessage
     withCancelSubject:(NSString*)cancelSubject
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath;

@end

@implementation GQBaseDataRequest

#pragma mark - class methods using delegate

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
{
    GQBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                      withSubRequestUrl:nil
                                                                keyPath:nil
                                                                mapping:nil
                                                         withParameters:nil
                                                      withIndicatorView:nil
                                                     withLoadingMessage:nil
                                                      withCancelSubject:nil
                                                           withCacheKey:nil
                                                          withCacheType:DataCacheManagerCacheTypeMemory
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
                                                     withLoadingMessage:parameterBody.loadingMessage
                                                      withCancelSubject:parameterBody.cancelSubject
                                                           withCacheKey:parameterBody.cacheKey
                                                          withCacheType:DataCacheManagerCacheTypeMemory
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
                                                     withLoadingMessage:nil
                                                      withCancelSubject:nil
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
                                                           withCacheKey:nil
                                                          withCacheType:DataCacheManagerCacheTypeMemory
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
                                                     withLoadingMessage:nil
                                                      withCancelSubject:cancelSubject
                                                           withCacheKey:nil
                                                          withCacheType:DataCacheManagerCacheTypeMemory
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
    withLoadingMessage:(NSString*)loadingMessage
     withCancelSubject:(NSString*)cancelSubject
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
        _indicatorView = indiView;
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
        self.loadingMessage = loadingMessage;
        if (!self.loadingMessage) {
            self.loadingMessage = DEFAULT_LOADING_MESSAGE;
        }
        _requestStartDate = [NSDate date];
        _userInfo = [[NSMutableDictionary alloc] initWithDictionary:params];
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

#pragma mark - class methods using block

+ (id)requestWithOnRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
                   onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:nil
                                                        withSubRequestUrl:nil
                                                        withIndicatorView:nil
                                                                  keyPath:nil
                                                                  mapping:nil
                                                       withLoadingMessage:nil
                                                        withCancelSubject:nil
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

+ (id)requestWithWithParameters:(NSDictionary*)params
              onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
                onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                        withSubRequestUrl:nil
                                                        withIndicatorView:nil
                                                                  keyPath:nil
                                                                  mapping:nil
                                                       withLoadingMessage:nil
                                                        withCancelSubject:nil
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

+ (id)requestWithWithParameters:(NSDictionary*)params
              withSubRequestUrl:(NSString*)subUrl
              onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
                onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock{
    GQBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                        withSubRequestUrl:subUrl
                                                        withIndicatorView:nil
                                                                  keyPath:nil
                                                                  mapping:nil
                                                       withLoadingMessage:nil
                                                        withCancelSubject:nil
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
                                                       withLoadingMessage:parameterBody.loadingMessage
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
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
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

- (id)initWithParameters:(NSDictionary*)params
       withSubRequestUrl:(NSString*)subUrl
       withIndicatorView:(UIView*)indiView
                 keyPath:(NSString*)keyPath
                 mapping:(GQObjectMapping*)mapping
      withLoadingMessage:(NSString*)loadingMessage
       withCancelSubject:(NSString*)cancelSubject
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
         _indicatorView = indiView;
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
        self.loadingMessage = loadingMessage;
        if (!self.loadingMessage) {
            self.loadingMessage = DEFAULT_LOADING_MESSAGE;
        }
        _requestStartDate = [NSDate date];
        _userInfo = [[NSMutableDictionary alloc] initWithDictionary:params];
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
            [_maskActivityView showInView:self.indicatorView withHintMessage:self.loadingMessage onCancleRequest:^(GQMaskActivityView *hintView){
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
