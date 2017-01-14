//
//  GQHttpRequestManager.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQHttpRequestManager.h"
#import "GQObjectSingleton.h"

#import "GQSessionOperation.h"

@implementation GQHttpRequestManager

GQOBJECT_SINGLETON_BOILERPLATE(GQHttpRequestManager, sharedHttpRequestManager)

- (void)dealloc {
    [self.session invalidateAndCancel];
    self.session = nil;
    
    [self.connectionQueue cancelAllOperations];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.connectionQueue  = [[NSOperationQueue alloc] init];
        self.connectionQueue.maxConcurrentOperationCount = 8;
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        self.session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                     delegate:self
                                                delegateQueue:nil];
    }
    return self;
}

- (void)addOperation:(NSOperation *)operation {
    [self.connectionQueue addOperation:operation];
}

#pragma mark Helper methods

- (GQSessionOperation *)operationWithTask:(NSURLSessionTask *)task {
    GQSessionOperation *returnOperation = nil;
    for (GQSessionOperation *operation in self.connectionQueue.operations) {
        if (operation.operationSessionTask.taskIdentifier == task.taskIdentifier) {
            returnOperation = operation;
            break;
        }
    }
    return returnOperation;
}

#pragma mark -- NSURLSessionDelegate  NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest *))completionHandler {
    
    GQSessionOperation *dataOperation = [self operationWithTask:task];
    
    [dataOperation URLSession:session task:task willPerformHTTPRedirection:response newRequest:request completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    GQSessionOperation *dataOperation = [self operationWithTask:dataTask];
    
    [dataOperation URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * bodyStream))completionHandler {
    GQSessionOperation *dataOperation = [self operationWithTask:task];
    
    [dataOperation URLSession:session task:task needNewBodyStream:completionHandler];
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    
    // Identify the operation that runs this task and pass it the delegate method
    GQSessionOperation *dataOperation = [self operationWithTask:dataTask];
    
    [dataOperation URLSession:session dataTask:dataTask didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
    
    // Identify the operation that runs this task and pass it the delegate method
    GQSessionOperation *dataOperation = [self operationWithTask:dataTask];
    
    [dataOperation URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // Identify the operation that runs this task and pass it the delegate method
    GQSessionOperation *dataOperation = [self operationWithTask:task];
    
    [dataOperation URLSession:session task:task didCompleteWithError:error];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    // Identify the operation that runs this task and pass it the delegate method
    GQSessionOperation *dataOperation = [self operationWithTask:task];
    
    [dataOperation URLSession:session task:task didReceiveChallenge:challenge completionHandler:completionHandler];
}


@end
