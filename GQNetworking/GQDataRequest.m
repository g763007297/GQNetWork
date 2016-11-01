//
//  GQDataRequest.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQDataRequest.h"
#import "GQHttpRequestManager.h"
#import "GQNetworkTrafficManager.h"
#import "GQRequestJsonDataHandler.h"
#import "GQNetworkConsts.h"
#import "GQDebugLog.h"

@implementation GQDataRequest

- (void)doRequestWithParams:(NSDictionary*)params
{
    GQWeakify(self);
    self.httpRequest = [[GQHTTPRequest alloc]
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
                        onNeedNewBodyStream:^NSInputStream *(NSInputStream * originalStream){
                            GQStrongify(self);
                            return [self notifyRequestNeedNewBodyStream:originalStream];
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
                            [self showIndicator:NO];
                            [self doRelease];
                        }
                        onRequestCanceled:^() {
                            GQStrongify(self);
                            [self notifyRequestDidCancel];
                            [self doRelease];
                        }
                        onRequestFailed:^(NSError *error) {
                            GQStrongify(self);
                            [self notifyRequestDidErrorWithError:error];
                            [self showIndicator:NO];
                            [self doRelease];
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
