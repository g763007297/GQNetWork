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
#import "GQDebug.h"

@implementation GQDataRequest

- (void)doRequestWithParams:(NSDictionary*)params
{
    __weak typeof(self) weakSelf  = self;
    
    self.httpRequest = [[GQHTTPRequest alloc]
                        initRequestWithParameters:params
                        URL:self.requestUrl
                        certificateData:[self getCertificateData]
                        saveToPath:_localFilePath
                        requestEncoding:[self getResponseEncoding]
                        parmaterEncoding:[self getParameterEncoding]
                        requestMethod:_requestMethod
                        onRequestStart:^() {
                            __strong typeof(weakSelf) strongSelf = weakSelf;
                            [strongSelf notifyRequestDidStart];
                        }
                        onRechiveResponse:^NSURLSessionResponseDisposition(NSURLResponse *response) {
                            __strong typeof(weakSelf) strongSelf = weakSelf;
                            return [strongSelf notifyRequestRechiveResponse:response];
                        }
                        onWillHttpRedirection:^NSURLRequest *(NSURLRequest *request, NSURLResponse *response) {
                            __strong typeof(weakSelf) strongSelf = weakSelf;
                            return [strongSelf notifyRequestWillRedirection:request response:response];
                        }
                        onProgressChanged:^(float progress) {
                            __strong typeof(weakSelf) strongSelf = weakSelf;
                            [strongSelf notifyRequestDidChange:progress];
                        }
                        onRequestFinished:^(NSData *responseData) {
                            __strong typeof(weakSelf) strongSelf = weakSelf;
                            if (strongSelf&&strongSelf->_localFilePath) {
                                [strongSelf notifyRequestDidSuccess];
                            }else{
                                [strongSelf handleResponseString:responseData];
                            }
                            [strongSelf showIndicator:NO];
                            [strongSelf doRelease];
                        }
                        onRequestCanceled:^() {
                            __strong typeof(weakSelf) strongSelf = weakSelf;
                            [strongSelf notifyRequestDidCancel];
                            [strongSelf doRelease];
                        }
                        onRequestFailed:^(NSError *error) {
                            __strong typeof(weakSelf) strongSelf = weakSelf;
                            [strongSelf notifyRequestDidErrorWithError:error];
                            [strongSelf showIndicator:NO];
                            [strongSelf doRelease];
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
