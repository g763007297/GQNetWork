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
#import "GQMaskActivityView.h"
#import "GQDebug.h"

static NSString *defaultUserAgent = nil;

@interface GQBaseDataRequest()
{
    BOOL     _usingCacheData;
    
    GQParameterEncoding _parmaterEncoding;
    
    NSInteger           _timeOutInterval;
    
    NSDate   *_requestStartDate;
    
    GQMaskActivityView  *_maskActivityView;
}

@end

@implementation GQBaseDataRequest

@synthesize requestUrlChain = _requestUrlChain;
@synthesize requestMethodChain = _requestMethodChain;
@synthesize delegateChain = _delegateChain;
@synthesize subRequestUrlChain = _subRequestUrlChain;
@synthesize cancelSubjectChain = _cancelSubjectChain;
@synthesize keyPathChain = _keyPathChain;
@synthesize mappingChain = _mappingChain;
@synthesize headerParametersChain = _headerParametersChain;
@synthesize parametersChain = _parametersChain;
@synthesize indicatorViewChain = _indicatorViewChain;
@synthesize cacheKeyChain = _cacheKeyChain;
@synthesize cacheTypeChain = _cacheTypeChain;
@synthesize localFilePathChain = _localFilePathChain;
@synthesize onStartBlockChain = _onStartBlockChain;
@synthesize onRechiveResponseBlockChain = _onRechiveResponseBlockChain;
@synthesize onWillRedirectionBlockChain = _onWillRedirectionBlockChain;
@synthesize onNeedNewBodyStreamBlockChain = _onNeedNewBodyStreamBlockChain;
@synthesize onWillCacheResponseBlockChain = _onWillCacheResponseBlockChain;
@synthesize onFinishedBlockChain = _onFinishedBlockChain;
@synthesize onCanceledBlockChain = _onCanceledBlockChain;
@synthesize onFailedBlockChain = _onFailedBlockChain;
@synthesize onProgressChangedBlockChain = _onProgressChangedBlockChain;
@synthesize startRequestChain = _startRequestChain;
@synthesize timeOutIntervalChain = _timeOutIntervalChain;

+ (instancetype)prepareRequset{
    id request = [[[self class] alloc] init];
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
GQChainRequestDefine(headerParametersChain, headerParameters, NSDictionary *, GQChainObjectRequest);
GQChainRequestDefine(parametersChain, parameters, NSDictionary *, GQChainObjectRequest);
GQChainRequestDefine(indicatorViewChain, indicatorView, UIView *, GQChainObjectRequest);
GQChainRequestDefine(localFilePathChain, localFilePath, NSString * , GQChainObjectRequest);
GQChainRequestDefine(cacheKeyChain, cacheKey, NSString * , GQChainObjectRequest);
GQChainRequestDefine(cacheTypeChain, cacheType, NSInteger , GQChainStuctRequest);

GQChainRequestDefine(onStartBlockChain, onRequestStart, GQRequestStart, GQChainBlockRequestStart);
GQChainRequestDefine(onRechiveResponseBlockChain, onRequestRechiveResponse, GQRequestRechiveResponse, GQChainBlockRequestRechiveResponse);
GQChainRequestDefine(onWillRedirectionBlockChain, onRequestWillRedirection, GQRequestWillRedirection, GQChainBlockRequestWillRedirection);
GQChainRequestDefine(onNeedNewBodyStreamBlockChain, onRequestNeedNewBodyStream, GQRequestNeedNewBodyStream, GQChainBlockRequestNeedNewBodyStream);
GQChainRequestDefine(onWillCacheResponseBlockChain, onRequestWillCacheRespons, GQRequestWillCacheResponse, GQChainBlockRequestWillCacheResponse);
GQChainRequestDefine(onFinishedBlockChain, onRequestFinished, GQRequestFinished, GQChainBlockRequestFinished);
GQChainRequestDefine(onCanceledBlockChain, onRequestCanceled, GQRequestCanceled, GQChainBlockRequestCanceled);
GQChainRequestDefine(onFailedBlockChain, onRequestFailed, GQRequestFailed, GQChainBlockRequestFailed);
GQChainRequestDefine(onProgressChangedBlockChain, onProgressChanged, GQProgressChanged, GQChainBlockProgressChanged);

- (GQChainBlockStartRequest)startRequestChain{
    GQWeakify(self);
    if (!_startRequestChain) {
        _startRequestChain = ^(){
            GQStrongify(self);
            [self startRequest];
        };
    }
    return _startRequestChain;
}

GQMethodRequestDefine(onStartBlockChain,GQRequestStart);
GQMethodRequestDefine(onRechiveResponseBlockChain, GQRequestRechiveResponse);
GQMethodRequestDefine(onWillRedirectionBlockChain, GQRequestWillRedirection);
GQMethodRequestDefine(onNeedNewBodyStreamBlockChain, GQRequestNeedNewBodyStream);
GQMethodRequestDefine(onWillCacheResponseBlockChain, GQRequestWillCacheResponse);
GQMethodRequestDefine(onFinishedBlockChain,GQRequestFinished);
GQMethodRequestDefine(onCanceledBlockChain,GQRequestCanceled);
GQMethodRequestDefine(onFailedBlockChain,GQRequestFailed);
GQMethodRequestDefine(onProgressChangedBlockChain,GQProgressChanged);

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
    
    //是否使用假数据
    if ([self useDumpyData]) {
        //处理假数据
        [self processDumpyRequest];
    }else {
        BOOL useCurrentCache = NO;
        
        NSObject *cacheData = [[GQDataCacheManager sharedManager] getCachedObjectByKey:_cacheKey];
        
        if (cacheData){
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
    if (_onRequestRechiveResponse)
    {
       disposition = _onRequestRechiveResponse(self, response);
    }else if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(requestRechiveResponse:urlResponse:)])
        {
            disposition =[self.delegate requestRechiveResponse:self urlResponse:response];
        }
    }
    return disposition;
}

- (NSURLRequest *)notifyRequestWillRedirection:(NSURLRequest *)request response:(NSURLResponse *)response
{
    NSURLRequest *redirectionRequest = request;
    if (_onRequestWillRedirection) {
        redirectionRequest = _onRequestWillRedirection(self,request,response);
    }else if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(requestWillRedirection:urlRequset:urlResponse:)]) {
            redirectionRequest = [self.delegate requestWillRedirection:self urlRequset:request urlResponse:response];
        }
    }
    return redirectionRequest;
}

- (NSInputStream *)notifyRequestNeedNewBodyStream:(NSInputStream *)originalStream
{
    NSInputStream *inputSteam = originalStream;
    if (_onRequestNeedNewBodyStream) {
        inputSteam = _onRequestNeedNewBodyStream(self,originalStream);
    }else if
        (self.delegate){
        if ([self.delegate respondsToSelector:@selector(requestNeedNewBodyStream:originStream:)]) {
            inputSteam = [self.delegate requestNeedNewBodyStream:self originStream:originalStream];
        }
    }
    return inputSteam;
}

- (NSCachedURLResponse *)notifyRequestWillCacheResponse:(NSCachedURLResponse *)proposedResponse
{
    NSCachedURLResponse *cachedResponse = proposedResponse;
    if (_onRequestWillCacheRespons) {
        cachedResponse = _onRequestWillCacheRespons(self,proposedResponse);
    }else if (self.delegate){
        if ([self.delegate respondsToSelector:@selector(requestWillCacheResponse:originStream:)]) {
            cachedResponse = [self.delegate requestWillCacheResponse:self originStream:proposedResponse];
        }
    }
    return cachedResponse;
}

- (void)notifyRequestDidSuccess
{
    if (_onRequestFinished)
    {
        _onRequestFinished(self, _responseResult);
    }else if (self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(requestDidFinishLoad:mappingResult:)])
        {
            [self.delegate requestDidFinishLoad:self mappingResult:_responseResult];
        }
    }
}

- (void)notifyRequestDidErrorWithError:(NSError*)error
{
    if (_onRequestFailed)
    {
        _onRequestFailed(self, error);
    }else if (self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(request:didFailLoadWithError:)])
        {
            [self.delegate request:self didFailLoadWithError:error];
        }
    }
}

- (void)notifyRequestDidCancel
{
    if (_onRequestCanceled)
    {
        _onRequestCanceled(self);
    }else if (self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(requestDidCancelLoad:)])
        {
            [self.delegate requestDidCancelLoad:self];
        }
    }
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
        _rawResultData = result;
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
                                                     objectMapping:_mapping
                                                           keyPath:_keyPath
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

#pragma mark -- private method
//显示加载View
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

//缓存数据
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

- (BOOL)isDownloadFileRequest
{
    return _localFilePath && [_localFilePath length];
}

- (void)processDumpyRequest
{
    [self showIndicator:TRUE];
    [self dumpyRequestDone];
    [self doRelease];
}

//处理假数据
- (void)dumpyRequestDone
{
    [self showIndicator:FALSE];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(rand()/(double)RAND_MAX * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSData *jsonData = [[self dumpyResponseString] dataUsingEncoding:[self getResponseEncoding]];
        [self handleResponseString:jsonData];
    });
}

#pragma mark -- override method(@optional)
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

- (NSDictionary *)getStaticHeaderParams
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

+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse
{
    NSData *jsonData = [cachedResponse dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
}

- (GQRequestDataHandler*)generateRequestHandler
{
    return [[GQRequestJsonDataHandler alloc] init];
}

- (NSData *)getCertificateData
{
    return nil;
}

- (BOOL)useResponseCookie
{
    return NO;
}

- (NSString *)userAgentString
{
    @synchronized (self) {
        
        if (!defaultUserAgent) {
            
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            
            NSString *appName = [bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
            if (!appName) {
                appName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
            }
            
            NSData *latin1Data = [appName dataUsingEncoding:NSUTF8StringEncoding];
            appName = [[NSString alloc] initWithData:latin1Data encoding:NSISOLatin1StringEncoding];
            
            if (!appName) {
                return nil;
            }
            
            NSString *appVersion = nil;
            NSString *marketingVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            NSString *developmentVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
            if (marketingVersionNumber && developmentVersionNumber) {
                if ([marketingVersionNumber isEqualToString:developmentVersionNumber]) {
                    appVersion = marketingVersionNumber;
                } else {
                    appVersion = [NSString stringWithFormat:@"%@ rv:%@",marketingVersionNumber,developmentVersionNumber];
                }
            } else {
                appVersion = (marketingVersionNumber ? marketingVersionNumber : developmentVersionNumber);
            }
            
            NSString *deviceName;
            NSString *OSName;
            NSString *OSVersion;
            NSString *locale = [[NSLocale currentLocale] localeIdentifier];
            
#if TARGET_OS_IPHONE
            UIDevice *device = [UIDevice currentDevice];
            deviceName = [device model];
            OSName = [device systemName];
            OSVersion = [device systemVersion];
            
#else
            deviceName = @"Macintosh";
            OSName = @"Mac OS X";
            
            OSErr err;
            SInt32 versionMajor, versionMinor, versionBugFix;
            err = Gestalt(gestaltSystemVersionMajor, &versionMajor);
            if (err != noErr) return nil;
            err = Gestalt(gestaltSystemVersionMinor, &versionMinor);
            if (err != noErr) return nil;
            err = Gestalt(gestaltSystemVersionBugFix, &versionBugFix);
            if (err != noErr) return nil;
            OSVersion = [NSString stringWithFormat:@"%u.%u.%u", versionMajor, versionMinor, versionBugFix];
#endif
            
            defaultUserAgent = [NSString stringWithFormat:@"%@ %@ (%@; %@ %@; %@)", appName, appVersion, deviceName, OSName, OSVersion, locale];
        }
        return defaultUserAgent;
    }
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

- (NSString *)getLoadingMessage
{
    return @"加载中...";
}

- (GQObjectMapping *)getMapping
{
    return nil;
}

#pragma mark -- override method(@required)

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

@end
