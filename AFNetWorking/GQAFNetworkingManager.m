//
//  GQAFNetworkingManager.m
//  GQNetWorkDemo
//
//  Created by gaoqi on 2020/3/25.
//  Copyright © 2020 gaoqi. All rights reserved.
//

#import "GQAFNetworkingManager.h"
#import "GQObjectSingleton.h"

#import "GQAFNetworkingAdapt.h"

#import <pthread/pthread.h>

#if __has_include(<AFNetworking/AFURLSessionManager.h>)
#import <AFNetworking/AFURLSessionManager.h>
#elif __has_include("AFURLSessionManager.h")
#import "AFURLSessionManager.h"
#endif

#if __has_include(<AFNetworking/AFURLSessionManager.h>) || __has_include("AFURLSessionManager.h")

@interface GQAFNetworkingManager() {
    AFURLSessionManager *_manager;
    pthread_mutex_t _lock;
    NSMutableDictionary<NSNumber *, GQAFNetworkingAdapt *> *_requestsRecord;
}

@end

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

@implementation GQAFNetworkingManager

GQOBJECT_SINGLETON_BOILERPLATE(GQAFNetworkingManager, sharedHttpRequestManager)

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        _requestsRecord = [NSMutableDictionary dictionary];
        pthread_mutex_init(&_lock, NULL);
        [self configure];
    }
    return self;
}

- (void)configure {
    GQWeakify(self);
    [_manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        GQStrongify(self);
        return [[self getRequestAdapt:dataTask] session:session dataTask:dataTask didReceiveResponse:response];
    }];

    [_manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nullable(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
        GQStrongify(self);
        return [[self getRequestAdapt:task] session:session task:task willPerformHTTPRedirection:response newRequest:request];
    }];

    [_manager setTaskNeedNewBodyStreamBlock:^NSInputStream * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task) {
        GQStrongify(self);
        return [[self getRequestAdapt:task] SessionneedNewBodyStream:session task:task];
    }];

    [_manager setDataTaskWillCacheResponseBlock:^NSCachedURLResponse * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSCachedURLResponse * _Nonnull proposedResponse) {
        GQStrongify(self);
        return [[self getRequestAdapt:dataTask] session:session dataTask:dataTask willCacheResponse:proposedResponse];
    }];
}

- (void)addRequest:(GQAFNetworkingAdapt *)requestAdapt {
    NSParameterAssert(requestAdapt != nil);
    
    if (requestAdapt.certificateData) {
        _manager.securityPolicy.pinnedCertificates = [NSSet setWithObject:requestAdapt.certificateData];
    }
    //如果有文件path就是下载
    GQWeakify(self);
    if (requestAdapt.localFilePath) {
        requestAdapt.requestTask = [_manager downloadTaskWithRequest:requestAdapt.request progress:^(NSProgress * _Nonnull downloadProgress) {
            [requestAdapt progressChange:downloadProgress];
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [requestAdapt destination:targetPath response:response];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            GQStrongify(self);
            [self handleRequestResult:response adapt:requestAdapt responseObject:nil error:error];
        }];
    } else {
        requestAdapt.requestTask = [_manager dataTaskWithRequest:requestAdapt.request
                                                  uploadProgress:nil
                                                downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            [requestAdapt progressChange:downloadProgress];
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            [self handleRequestResult:response adapt:requestAdapt responseObject:responseObject error:error];
        }];
    }
    
    [self addRequestToRecord:requestAdapt];
    [requestAdapt.requestTask resume];
}

- (void)handleRequestResult:(NSURLResponse *)response adapt:(GQAFNetworkingAdapt *)requestAdapt responseObject:(id)responseObject error:(NSError *)error {
    [requestAdapt session:response responseObject:responseObject didCompleteWithError:error];
    [self removeRequestFromRecord:requestAdapt];
}

- (void)cancelRequest:(GQAFNetworkingAdapt *)request  {
    NSParameterAssert(request != nil);
    [request.requestTask cancel];
    [self removeRequestFromRecord:request];
}

- (GQAFNetworkingAdapt *)getRequestAdapt:(NSURLSessionTask *)task {
    Lock();
    GQAFNetworkingAdapt *adapt = self->_requestsRecord[@(task.taskIdentifier)];
    Unlock();
    return adapt;
}

- (void)addRequestToRecord:(GQAFNetworkingAdapt *)request {
    Lock();
    _requestsRecord[@(request.requestTask.taskIdentifier)] = request;
    Unlock();
}

- (void)removeRequestFromRecord:(GQAFNetworkingAdapt *)request {
    Lock();
    [_requestsRecord removeObjectForKey:@(request.requestTask.taskIdentifier)];
    Unlock();
}

@end

#else

@implementation GQAFNetworkingManager

@end

#endif

