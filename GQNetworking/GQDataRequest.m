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
#import "GQDataEnvironment.h"
#import "GQObjectSingleton.h"
#import "GQDebug.h"

@implementation GQDataRequest

- (void)doRequestWithParams:(NSDictionary*)params
{
    GQWeakify(self);
    self.httpRequest = [[GQHTTPRequest alloc]
                        initRequestWithParameters:params
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
                            [self notifyRequestDidFinish:responseData];
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
    
    if (_headerParameters) {
        [_headerParameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isKindOfClass:[NSString class]]&&[obj isKindOfClass:[NSString class]]) {
                [self.httpRequest setRequestHeaderField:key value:obj];
            }
        }];
    }
    [self.httpRequest setTimeoutInterval:[self getTimeOutInterval]];
    
    [self.httpRequest startRequest];
    [self showIndicator:YES];
}

- (NSDictionary*)getStaticParams
{
    return nil;
}

- (void)doRelease
{
    [super doRelease];
    self.httpRequest = nil;
}

- (GQParameterEncoding)getParameterEncoding
{
    return GQURLParameterEncoding;
}

- (GQRequestMethod)getRequestMethod
{
    return GQRequestMethodGet;
}

- (void)cancelRequest
{
    [self.httpRequest cancelRequest];
    
    [self showIndicator:NO];
    GQDINFO(@"%@ request is cancled", [self class]);
}

@end
