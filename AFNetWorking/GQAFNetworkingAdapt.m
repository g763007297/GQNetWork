//
//  GQAFNetworkingAdapt.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 20/3/25.
//  Copyright © 2020年 gaoqi. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GQAFNetworkingAdapt.h"
#import "GQQueryStringPair.h"
#import "GQNetworkTrafficManager.h"
#import "GQNetworkConsts.h"
#import "GQRequestSerialization.h"

#import "GQAFNetworkingManager.h"

@interface GQAFNetworkingAdapt()

@property (nonatomic, strong) GQRequestSerialization *requestSerialization;

@property (nonatomic, strong) NSData                    *certificateData;
@property (nonatomic, strong) NSString                  *localFilePath;

@end

@implementation GQAFNetworkingAdapt

- (void)dealloc
{
    self.localFilePath = nil;
    self.certificateData = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.localFilePath = nil;
        self.certificateData = nil;
    }
    return self;
}

- (void)setTimeoutInterval:(NSTimeInterval)seconds
{
    [self.requestSerialization.request setTimeoutInterval:seconds];
}

- (NSURLRequest *)request {
    return self.requestSerialization.request;
}

- (instancetype)initRequestWithParameters:(id)parameters
                             headerParams:(NSDictionary *)headerParams
                              uploadDatas:(NSArray *)uploadDatas
                                      URL:(NSString *)url
                          certificateData:(NSData *)certificateData
                               saveToPath:(NSString *)localFilePath
                          requestEncoding:(NSStringEncoding)requestEncoding
                         parmaterEncoding:(GQParameterEncoding)parameterEncoding
                            requestMethod:(GQRequestMethod)requestMethod
                           onRequestStart:(void(^)(void))onStartBlock
                        onRechiveResponse:(NSURLSessionResponseDisposition (^)(NSURLResponse *response))onRechiveResponseBlock
                    onWillHttpRedirection:(NSURLRequest* (^)(NSURLRequest *request,NSURLResponse *response))onWillHttpRedirection
                      onNeedNewBodyStream:(NSInputStream *(^)(NSURLSession *session,NSURLSessionTask *task))onNeedNewBodyStream
                      onWillCacheResponse:(NSCachedURLResponse *(^)(NSCachedURLResponse *proposedResponse))onWillCacheResponse
                        onProgressChanged:(void(^)(float progress))onProgressChangedBlock
                        onRequestFinished:(void(^)(NSData *responseData))onFinishedBlock
                        onRequestCanceled:(void(^)(void))onCanceledBlock
                          onRequestFailed:(void(^)(NSError *error))onFailedBlock
{
    self = [self init];
    if (self) {
        self.localFilePath = localFilePath;
        self.certificateData = certificateData;
        
        self.requestSerialization = [[GQRequestSerialization alloc] initRequestWithParameters:parameters
                                                                                 headerParams:headerParams
                                                                                  uploadDatas:uploadDatas
                                                                                          URL:url
                                                                              requestEncoding:requestEncoding
                                                                             parmaterEncoding:parameterEncoding
                                                                                requestMethod:requestMethod];
        
        if (onStartBlock) {
            _onRequestStartBlock = [onStartBlock copy];
        }
        if (onRechiveResponseBlock) {
            _onRechiveResponseBlock = [onRechiveResponseBlock copy];
        }
        if (onWillHttpRedirection) {
            _onWillHttpRedirection = [onWillHttpRedirection copy];
        }
        if (onNeedNewBodyStream) {
            _onNeedNewBodyStream = [onNeedNewBodyStream copy];
        }
        if (onWillCacheResponse) {
            _onWillCacheResponse = [onWillCacheResponse copy];
        }
        if (onProgressChangedBlock) {
            _onRequestProgressChangedBlock = [onProgressChangedBlock copy];
        }
        if (onFinishedBlock) {
            _onRequestFinishBlock = [onFinishedBlock copy];
        }
        if (onCanceledBlock) {
            _onRequestCanceled = [onCanceledBlock copy];
        }
        if (onFailedBlock) {
            _onRequestFailedBlock = [onFailedBlock copy];
        }
    }
    return  self;
}

- (void)startRequest
{
    if (![GQNetworkTrafficManager sharedManager].isReachability) {
        NSError *error = [NSError errorWithDomain:@"" code:GQRequestErrorNoNetWork userInfo:@{}];
        _onRequestFailedBlock(error);
        return;
    }
    
    [self.requestSerialization serialization];
    
#if __has_include(<AFNetworking/AFURLSessionManager.h>) || __has_include("AFURLSessionManager.h")
    [[GQAFNetworkingManager sharedHttpRequestManager] addRequest:self];
#endif
    if (self&&self->_onRequestStartBlock) {
        self->_onRequestStartBlock();
    }
}

- (void)cancelRequest
{
#if __has_include(<AFNetworking/AFURLSessionManager.h>) || __has_include("AFURLSessionManager.h")
    [[GQAFNetworkingManager sharedHttpRequestManager] cancelRequest:self];
#endif
    if (_onRequestCanceled) {
        _onRequestCanceled();
    }
}

#pragma mark -- NSURLSessionDelegate NSURLSessionTaskDelegate

- (NSURL *)destination:(NSURL *)targetPath response:(NSURLResponse *) response {
    if (self.localFilePath) {
        return [NSURL URLWithString:self.localFilePath];
    } else {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    }
}

- (void)progressChange:(NSProgress *) downloadProgress {
    if (self&&self->_onRequestProgressChangedBlock) {
        self->_onRequestProgressChangedBlock(downloadProgress.fractionCompleted);
    }
}

- (void)session:(NSURLResponse *)response
 responseObject:(id)responseObject
didCompleteWithError:(NSError *)error {
    if (!error) {
        [[GQNetworkTrafficManager sharedManager] logTrafficIn:response.expectedContentLength];
        if (self&&self->_onRequestFinishBlock) {
            self->_onRequestFinishBlock(responseObject);
        }
    }else{
        if (self&&self->_onRequestFailedBlock) {
            self->_onRequestFailedBlock(error);
        }
    }
}

- (NSURLSessionResponseDisposition)session:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
{
    if (self) {
        if (self->_onRechiveResponseBlock) {
            return self->_onRechiveResponseBlock(response);
        }
    }else{
        return NSURLSessionResponseCancel;
    }
    return NSURLSessionResponseAllow;
}

- (NSURLRequest *)session:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSURLResponse *)response
newRequest:(NSURLRequest *)request
{
    if (self&&self->_onWillHttpRedirection) {
        return self->_onWillHttpRedirection(request,response);
    }
    return request;
}

- (NSInputStream *)SessionneedNewBodyStream:(NSURLSession *)session
                                       task:(NSURLSessionTask *)task {
    if (self&&self->_onNeedNewBodyStream) {
        return self->_onNeedNewBodyStream(session,task);
    }
    return nil;
}

- (NSCachedURLResponse *)session:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
{
    if (self&&self->_onWillCacheResponse) {
        return self->_onWillCacheResponse(proposedResponse);
    }
    return proposedResponse;
}

@end
