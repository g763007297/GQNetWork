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
#import "GQNetwork.h"
#import "GQDataEnvironment.h"
#import "GQDebug.h"

@implementation GQDataRequest

- (void)doRequestWithParams:(NSDictionary*)params
{
    __weak typeof(self) weakSelf  = self;
    
    self.httpRequest = [[GQHTTPRequest alloc] initRequestWithParameters:params URL:self.requestUrl saveToPath:_filePath requestEncoding:[self getResponseEncoding] parmaterEncoding:[self getParameterEncoding] requestMethod:[self getRequestMethod] onRequestStart:^() {
        if (_onRequestStartBlock) {
            _onRequestStartBlock(weakSelf);
        }else if (weakSelf.delegate) {
            if([weakSelf.delegate respondsToSelector:@selector(requestDidStartLoad:)]){
                [weakSelf.delegate requestDidStartLoad:weakSelf];
            }
        }
    } onProgressChanged:^(float progress) {
        if (_onRequestProgressChangedBlock) {
            _onRequestProgressChangedBlock(weakSelf,progress);
        }else if (weakSelf.delegate) {
            if([weakSelf.delegate respondsToSelector:@selector(request:progressChanged:)]){
                [weakSelf.delegate request:weakSelf progressChanged:progress];
            }
        }
    } onRequestFinished:^(NSData *responseData) {
        if (_filePath) {
            if (_onRequestFinishBlock) {
                _onRequestFinishBlock(weakSelf, nil);
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

- (NSStringEncoding)getResponseEncoding
{
    return NSUTF8StringEncoding;
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
