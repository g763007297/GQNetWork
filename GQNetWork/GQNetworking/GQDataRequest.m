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
    
    self.httpRequest = [[GQHTTPRequest alloc] initRequestWithParameters:params URL:self.requestUrl saveToPath:_localFilePath requestEncoding:[self getResponseEncoding] parmaterEncoding:[self getParameterEncoding] requestMethod:_requestMethod onRequestStart:^() {
        if (_onRequestStart) {
            _onRequestStart(weakSelf);
        }else if (weakSelf.delegate) {
            if([weakSelf.delegate respondsToSelector:@selector(requestDidStartLoad:)]){
                [weakSelf.delegate requestDidStartLoad:weakSelf];
            }
        }
    } onProgressChanged:^(float progress) {
        if (_onProgressChanged) {
            _onProgressChanged(weakSelf,progress);
        }else if (weakSelf.delegate) {
            if([weakSelf.delegate respondsToSelector:@selector(request:progressChanged:)]){
                [weakSelf.delegate request:weakSelf progressChanged:progress];
            }
        }
    } onRequestFinished:^(NSData *responseData) {
        if (_localFilePath) {
            if (_onRequestFinished) {
                _onRequestFinished(weakSelf, nil);
            }else if (weakSelf.delegate) {
                if([weakSelf.delegate respondsToSelector:@selector(requestDidFinishLoad:mappingResult:)]){
                    [weakSelf.delegate requestDidFinishLoad:weakSelf mappingResult:nil];
                }
            }
        }else{
            [weakSelf handleResponseString:[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]];
        }
        [weakSelf showIndicator:NO];
        [weakSelf doRelease];
    } onRequestCanceled:^() {
        if (_onRequestCanceled) {
            _onRequestCanceled(weakSelf);
        }else if (weakSelf.delegate) {
            if([weakSelf.delegate respondsToSelector:@selector(requestDidCancelLoad:)]){
                [weakSelf.delegate requestDidCancelLoad:weakSelf];
            }
        }
        [weakSelf doRelease];
    } onRequestFailed:^(NSError *error) {
        [weakSelf notifyDelegateRequestDidErrorWithError:error];
        [weakSelf showIndicator:NO];
        [weakSelf doRelease];
    }];
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

- (GQParameterEncoding)getParameterEncoding{
    return GQURLParameterEncoding;
}

- (GQRequestMethod)getRequestMethod
{
    return GQRequestMethodGet;
}

- (void)cancelRequest
{
    [self.httpRequest cancelRequest];
    
    if (_onRequestCanceled) {
        __weak GQBaseDataRequest *weakSelf = self;
        _onRequestCanceled(weakSelf);
    }
    [self showIndicator:NO];
    GQDINFO(@"%@ request is cancled", [self class]);
}

@end
