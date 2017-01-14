//
//  GQSessionOperation.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/10/23.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQSessionOperation.h"
#import "GQHttpRequestManager.h"
#import "GQSecurityPolicy.h"

@implementation GQSessionOperation

- (void)dealloc
{
    self.operationSessionTask = nil;
}

- (instancetype)initWithURLRequest:(NSURLRequest *)urlRequest
                  operationSession:(NSURLSession *)operationSession
                        saveToPath:(NSString*)savePath
                   certificateData:(NSData *)certificateData
                          progress:(GQHTTPRequestChangeHandler)onProgressBlock
                    onRequestStart:(GQHTTPRequestStartHandler)onStartBlock
                 onRechiveResponse:(GQHTTPRechiveResponseHandler)onRechiveResponseBlock
             onWillHttpRedirection:(GQHTTPWillHttpRedirectionHandler)onWillHttpRedirectionBlock
               onNeedNewBodyStream:(GQHTTPNeedNewBodyStreamHandler)onNeedNewBodyStreamBlock
               onWillCacheResponse:(GQHTTPWillCacheResponseHandler)onWillCacheResponse
                        completion:(GQHTTPRequestCompletionHandler)onCompletionBlock
{
    self = [super initWithURLRequest:urlRequest
                    operationSession:operationSession
                          saveToPath:savePath
                     certificateData:certificateData
                            progress:onProgressBlock
                      onRequestStart:onStartBlock
                   onRechiveResponse:onRechiveResponseBlock
               onWillHttpRedirection:onWillHttpRedirectionBlock
                 onNeedNewBodyStream:onNeedNewBodyStreamBlock
                 onWillCacheResponse:onWillCacheResponse
                          completion:onCompletionBlock];
    return self;
}

- (void)finish
{
    [self.operationSessionTask cancel];
    [super finish];
}

- (void)main
{
    [super main];
    
    self.operationSessionTask = [self.operationSession dataTaskWithRequest:self.operationRequest];
    [self.operationSessionTask resume];
}

#pragma mark -- NSURLSessionDelegate NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if (error) {
        [self callCompletionBlockWithResponse:nil requestSuccess:NO error:error];
    }else{
        [self callCompletionBlockWithResponse:nil requestSuccess:YES error:nil];
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    self.expectedContentLength = response.expectedContentLength;
    
    self.receivedContentLength = 0;
    
    self.operationURLResponse = (NSHTTPURLResponse *)response;
    
    NSURLSessionResponseDisposition disposition = NSURLSessionResponseAllow;
    
    if (_onRechiveResponseBlock) {
        disposition = _onRechiveResponseBlock(response);
    }
    
    if (completionHandler) {
        completionHandler(disposition);
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    NSURLRequest *redirectionRequest = request;
    
    if (_onWillHttpRedirectionBlock) {
        redirectionRequest = _onWillHttpRedirectionBlock(request,response);
    }
    
    if (completionHandler) {
        completionHandler(redirectionRequest);
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))completionHandler
{
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    GQSecurityPolicy *policy = [GQSecurityPolicy defaultSecurityPolicy:self.certificateData withChallenge:challenge];
    if (policy) {
        credential = policy.credential;
        disposition = NSURLSessionAuthChallengeUseCredential;
    }else{
        if (challenge.previousFailureCount > 0)
        {
            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
    }
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * bodyStream))completionHandler
{
    NSInputStream *inputStream = nil;
    if (task.originalRequest.HTTPBodyStream && [task.originalRequest.HTTPBodyStream conformsToProtocol:@protocol(NSCopying)]) {
        inputStream = [task.originalRequest.HTTPBodyStream copy];
    }
    if (_onNeedNewBodyStreamBlock) {
        inputStream = _onNeedNewBodyStreamBlock(inputStream);
    }
    if (completionHandler) {
        completionHandler(inputStream);
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    [self handleResponseData:data];
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * cachedResponse))completionHandler
{
    NSCachedURLResponse *cachedResponse = proposedResponse;
    
    if (completionHandler) {
        completionHandler(cachedResponse);
    }
}

@end
