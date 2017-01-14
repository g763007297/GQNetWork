//
//  GQUrlConnectionOperation.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQURLOperation.h"

#import "GQSecurityPolicy.h"

@interface GQURLOperation()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@end

@implementation GQURLOperation

- (void)dealloc
{
    self.operationConnection = nil;
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
    [super finish];
    [self.operationConnection cancel];
    self.operationConnection = nil;
}

- (void)main
{
    [super main];
    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
    BOOL inBackgroundAndInOperationQueue = (currentQueue != nil && currentQueue != [NSOperationQueue mainQueue]);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    self.operationConnection = [[NSURLConnection alloc] initWithRequest:self.operationRequest delegate:self startImmediately:NO];
#pragma clang diagnostic pop
    NSRunLoop *targetRunLoop = (inBackgroundAndInOperationQueue) ? [NSRunLoop currentRunLoop] : [NSRunLoop mainRunLoop];
    [self.operationConnection scheduleInRunLoop:targetRunLoop forMode:NSDefaultRunLoopMode];
    [self.operationConnection start];
}

#pragma mark - NSURLConnectionDelegate

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)response
{
    NSURLRequest *redirectionRequest = request;
    
    if (_onWillHttpRedirectionBlock) {
        redirectionRequest = _onWillHttpRedirectionBlock(request,response);
    }
    return request;
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    if (_onRechiveResponseBlock) {
        _onRechiveResponseBlock(response);
    }
    self.expectedContentLength = response.expectedContentLength;
    self.receivedContentLength = 0;
    self.operationURLResponse = (NSHTTPURLResponse *)response;
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [self handleResponseData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self callCompletionBlockWithResponse:nil requestSuccess:YES error:nil];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [self callCompletionBlockWithResponse:nil requestSuccess:NO error:error];
}

- (void)connection:(NSURLConnection *)connection
willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    GQSecurityPolicy *policy = [GQSecurityPolicy defaultSecurityPolicy:self.certificateData withChallenge:challenge];
    if (policy) {
        [challenge.sender useCredential:policy.credential forAuthenticationChallenge:challenge];
    }else{
        if (challenge.previousFailureCount > 0)
        {
            [challenge.sender cancelAuthenticationChallenge:challenge];
        }else{
            [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    }
}

@end
