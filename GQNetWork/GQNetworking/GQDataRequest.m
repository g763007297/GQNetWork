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
#import "GQCommonMacros.h"
#import "GQDataEnvironment.h"
#import "GQDebug.h"

@implementation GQDataRequest

- (void)doRequestWithParams:(NSDictionary*)params
{
    //    __weak GQBaseDataRequest *weakSelf = self;
    
    __weak typeof(self) weakSelf  = self;
    
    self.httpRequest = [[GQHTTPRequest alloc] initRequestWithParameters:params URL:self.requestUrl saveToPath:_filePath requestEncoding:[self getResponseEncoding] parmaterEncoding:[self getParameterEncoding] requestMethod:[self getRequestMethod] onRequestStart:^(GQUrlConnectionOperation *request) {
        if (_onRequestStartBlock) {
            _onRequestStartBlock(weakSelf);
        }else if (weakSelf.delegate) {
            if([weakSelf.delegate respondsToSelector:@selector(requestDidStartLoad:)]){
                [weakSelf.delegate requestDidStartLoad:weakSelf];
            }
        }
    } onProgressChanged:^(GQUrlConnectionOperation *request, float progress) {
        if (_onRequestProgressChangedBlock) {
            _onRequestProgressChangedBlock(weakSelf,progress);
        }else if (weakSelf.delegate) {
            if([weakSelf.delegate respondsToSelector:@selector(request:progressChanged:)]){
                [weakSelf.delegate request:weakSelf progressChanged:progress];
            }
        }
    } onRequestFinished:^(GQUrlConnectionOperation *request) {
        if (_filePath) {
            if (_onRequestFinishBlock) {
                _onRequestFinishBlock(weakSelf, nil);
            }else if (weakSelf.delegate) {
                if([weakSelf.delegate respondsToSelector:@selector(requestDidFinishLoad:mappingResult:)]){
                    [weakSelf.delegate requestDidFinishLoad:weakSelf mappingResult:nil];
                }
            }
        }else{
            [weakSelf handleResponseString:[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding]];
        }
        
        [weakSelf showIndicator:NO];
        [weakSelf doRelease];
    } onRequestCanceled:^(GQUrlConnectionOperation *request) {
        if (_onRequestCanceled) {
            _onRequestCanceled(weakSelf);
        }else if (weakSelf.delegate) {
            if([weakSelf.delegate respondsToSelector:@selector(requestDidCancelLoad:)]){
                [weakSelf.delegate requestDidCancelLoad:weakSelf];
            }
        }
        [weakSelf doRelease];
    } onRequestFailed:^(GQUrlConnectionOperation *request, NSError *error) {
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
    //return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
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

- (NSString*)getRequestHost
{
    return DATA_ENV.urlRequestHost;
}

- (void)cancelRequest
{
    [self.httpRequest cancelRequest];
    //to cancel here
    
    if (_onRequestCanceled) {
        __weak GQBaseDataRequest *weakSelf = self;
        _onRequestCanceled(weakSelf);
    }
    [self showIndicator:NO];
    GQDINFO(@"%@ request is cancled", [self class]);
}

- (void)dealloc
{
    
}

@end
