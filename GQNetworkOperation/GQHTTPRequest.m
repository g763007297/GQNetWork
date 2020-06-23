//
//  GQHTTPRequest.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GQHTTPRequest.h"
#import "GQQueryStringPair.h"
#import "GQHttpRequestManager.h"
#import "GQNetworkTrafficManager.h"
#import "GQURLOperation.h"
#import "GQSessionOperation.h"
#import "GQNetworkConsts.h"
#import "GQRequestSerialization.h"

@interface GQHTTPRequest()

@property (nonatomic, strong) GQRequestSerialization    *requestSerialization;
@property (nonatomic, strong) NSString                  *localFilePath;
@property (nonatomic, strong) NSData                    *certificateData;

@property (nonatomic, strong) GQBaseOperation           *urlOperation;

@end

@implementation GQHTTPRequest

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

- (GQHTTPRequest *)initRequestWithParameters:(NSDictionary *)parameters
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
    
    Class operationClass;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        operationClass = [GQSessionOperation class];
    }else {
        operationClass = [GQURLOperation class];
    }
    
    if (operationClass) {
        GQWeakify(self);
        self.urlOperation = [[operationClass alloc]
                            initWithURLRequest:self.requestSerialization.request
                              operationSession:[GQHttpRequestManager sharedHttpRequestManager].session
                              saveToPath:self.localFilePath
                              certificateData:self.certificateData
                              progress:^(float progress) {
                                  GQStrongify(self);
                                  if (self&&self->_onRequestProgressChangedBlock) {
                                      self->_onRequestProgressChangedBlock(progress);
                                  }
                              }
                              onRequestStart:^(GQBaseOperation *urlConnectionOperation) {
                                  GQStrongify(self);
                                  if (self&&self->_onRequestStartBlock) {
                                      self->_onRequestStartBlock();
                                  }
                              }
                              onRechiveResponse:^NSURLSessionResponseDisposition(NSURLResponse *response) {
                                  GQStrongify(self);
                                  if (self) {
                                      if (self->_onRechiveResponseBlock) {
                                          return self->_onRechiveResponseBlock(response);
                                      }
                                  }else{
                                      return NSURLSessionResponseCancel;
                                  }
                                  return NSURLSessionResponseAllow;
                              }
                              onWillHttpRedirection:^NSURLRequest *(NSURLRequest *request, NSURLResponse *response) {
                                  GQStrongify(self);
                                  if (self&&self->_onWillHttpRedirection) {
                                      return self->_onWillHttpRedirection(request,response);
                                  }
                                  return request;
                              }
                              onNeedNewBodyStream:^NSInputStream *(NSURLSession *session,NSURLSessionTask *task){
                                  GQStrongify(self);
                                if (self&&self->_onNeedNewBodyStream) {
                                    return self->_onNeedNewBodyStream(session,task);
                                }
                                return nil;
                              }
                              onWillCacheResponse:^NSCachedURLResponse *(NSCachedURLResponse *proposedResponse) {
                                  GQStrongify(self);
                                  if (self&&self->_onWillCacheResponse) {
                                      return self->_onWillCacheResponse(proposedResponse);
                                  }
                                  return proposedResponse;
                              }
                              completion:^(GQBaseOperation *urlConnectionOperation, BOOL requestSuccess, NSError *error) {
                                  GQStrongify(self);
                                  if (requestSuccess) {
                                      [[GQNetworkTrafficManager sharedManager] logTrafficIn:urlConnectionOperation.responseData.length];
                                      if (self&&self->_onRequestFinishBlock) {
                                          self->_onRequestFinishBlock(self.urlOperation.responseData);
                                      }
                                  }else{
                                      if (self&&self->_onRequestFailedBlock) {
                                          self->_onRequestFailedBlock(error);
                                      }
                                  }
                              }];
        [[GQHttpRequestManager sharedHttpRequestManager] addOperation:self.urlOperation];
    }else {
        NSError *error = [[NSError alloc] initWithDomain:@"class missing" code:-110 userInfo:@{@"userInfo":@"class missing"}];
        if (self&&self->_onRequestFailedBlock) {
            self->_onRequestFailedBlock(error);
        }
    }
}

- (void)cancelRequest
{
    [self.urlOperation cancel];
    if (_onRequestCanceled) {
        _onRequestCanceled();
    }
}

@end
