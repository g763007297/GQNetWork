//
//  GQDataRequest.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQDataRequest.h"

#import "GQNetworkTrafficManager.h"
#import "GQNetworkConsts.h"
#import "GQDebugLog.h"

#if __has_include(<AFNetworking/AFURLSessionManager.h>) || __has_include("AFURLSessionManager.h")
#import "GQAFNetworkingAdapt.h"
#else
#import "GQHTTPRequest.h"
#endif

@interface GQDataRequest()

#if __has_include(<AFNetworking/AFURLSessionManager.h>) || __has_include("AFURLSessionManager.h")
@property (nonatomic, strong) GQAFNetworkingAdapt *httpRequest;
#else
@property (nonatomic, strong) GQHTTPRequest *httpRequest;
#endif

@end

@implementation GQDataRequest

- (void)doRequestWithParams:(NSDictionary*)params
{
    GQWeakify(self);
    self.httpRequest =
#if __has_include(<AFNetworking/AFURLSessionManager.h>) || __has_include("AFURLSessionManager.h")
    [[GQAFNetworkingAdapt alloc]
#else
    [[GQHTTPRequest alloc]
#endif
                        initRequestWithParameters:params
                        headerParams:_headerParameters
                        uploadDatas:_uploadDatas
                        URL:self.requestUrl
                        certificateData:[self getCertificateData]
                        saveToPath:_localFilePath
                        requestEncoding:[self getResponseEncoding]
                        parmaterEncoding:[self getParameterEncoding]
                        requestMethod:_requestMethod
                        onRequestStart:^() {
                            GQStrongify(self);
                            [self notifyRequestDidStart];
                        }
                        onRechiveResponse:^NSURLSessionResponseDisposition(NSURLResponse *response) {
                            GQStrongify(self);
                            return [self notifyRequestRechiveResponse:response];
                        }
                        onWillHttpRedirection:^NSURLRequest *(NSURLRequest *request, NSURLResponse *response) {
                            GQStrongify(self);
                            return [self notifyRequestWillRedirection:request response:response];
                        }
                        onNeedNewBodyStream:^NSInputStream *(NSURLSession *session,NSURLSessionTask *task){
                            GQStrongify(self);
                            return [self notifyRequestNeedNewBodyStream:session task:task];
                        }
                        onWillCacheResponse:^NSCachedURLResponse *(NSCachedURLResponse *proposedResponse) {
                            GQStrongify(self);
                            return [self notifyRequestWillCacheResponse:proposedResponse];
                        }
                        onProgressChanged:^(float progress) {
                            GQStrongify(self);
                            [self notifyRequestDidChange:progress];
                        }
                        onRequestFinished:^(NSData *responseData) {
                            GQStrongify(self);
                            [self handleResponseString:responseData];
                            GQDispatch_main_async_safe(^{
                                [self showIndicator:NO];
                                [self doRelease];
                            });
                        }
                        onRequestCanceled:^() {
                            GQStrongify(self);
                            GQDispatch_main_async_safe(^{
                                [self notifyRequestDidCancel];
                                [self doRelease];
                            });
                        }
                        onRequestFailed:^(NSError *error) {
                            GQStrongify(self);
                            GQDispatch_main_async_safe(^{
                                [self notifyRequestDidErrorWithError:error];
                                [self showIndicator:NO];
                                [self doRelease];
                            });
                        }];
    
    [self.httpRequest setTimeoutInterval:[self getTimeOutInterval]];
    
    [self.httpRequest startRequest];
    [self showIndicator:YES];
}

- (void)doRelease
{
    [super doRelease];
    self.httpRequest = nil;
}

- (void)cancelRequest
{
    [self.httpRequest cancelRequest];
    
    [self showIndicator:NO];
    [GQDebugLog infoMessage:[NSString stringWithFormat:@"%@ request is cancled", [self class]]];
}

@end
