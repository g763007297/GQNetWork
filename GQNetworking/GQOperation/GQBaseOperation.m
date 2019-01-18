//
//  GQOperation.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/10/23.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseOperation.h"

#import "GQHttpRequestManager.h"

#import "GQSecurityPolicy.h"

#import "GQNetworkConsts.h"

@interface GQBaseOperation()

#if !OS_OBJECT_USE_OBJC
@property (nonatomic, assign) dispatch_queue_t saveDataDispatchQueue;
@property (nonatomic, assign) dispatch_group_t saveDataDispatchGroup;
#else
@property (nonatomic, strong) dispatch_queue_t saveDataDispatchQueue;
@property (nonatomic, strong) dispatch_group_t saveDataDispatchGroup;
#endif

@end

@implementation GQBaseOperation

@synthesize state = _state;

static NSInteger GQHTTPRequestTaskCount = 0;

- (void)dealloc
{
    self.operationSavePath = nil;
    self.operationRequest = nil;
    self.operationURLResponse = nil;
    self.operationFileHandle = nil;
    self.operationData = nil;
    self.responseData = nil;
    self.certificateData = nil;
    
#if !OS_OBJECT_USE_OBJC
    dispatch_release(_saveDataDispatchGroup);
    dispatch_release(_saveDataDispatchQueue);
#endif
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
                            completion:(GQHTTPRequestCompletionHandler)onCompletionBlock;
{
    self = [super init];
    self.operationData = [[NSMutableData alloc] init];
    self.operationRequest = urlRequest;
    self.operationSession = operationSession;
    self.certificateData = certificateData;
    self.operationSavePath = savePath;
    self.saveDataDispatchGroup = dispatch_group_create();
    self.saveDataDispatchQueue = dispatch_queue_create("com.ISS.GQRequest", DISPATCH_QUEUE_SERIAL);
    
    if (onStartBlock) {
        _onRequestStartBlock = [onStartBlock copy];
    }
    if (onRechiveResponseBlock) {
        _onRechiveResponseBlock = [onRechiveResponseBlock copy];
    }
    if (onWillHttpRedirectionBlock) {
        _onWillHttpRedirectionBlock = onWillHttpRedirectionBlock;
    }
    if (onNeedNewBodyStreamBlock) {
        _onNeedNewBodyStreamBlock = [onNeedNewBodyStreamBlock copy];
    }
    if (onProgressBlock) {
        _operationProgressBlock = [onProgressBlock copy];
    }
    if (onCompletionBlock) {
        _operationCompletionBlock = [onCompletionBlock copy];
    }
    return self;
}

- (void)cancel
{
    if([self isFinished]){
        return;
    }
    [super cancel];
    [self finish];
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isFinished
{
    return self.state == GQURLStateFinished;
}

- (BOOL)isExecuting
{
    return self.state == GQURLStateExecuting;
}

- (GQURLState)state
{
    @synchronized(self) {
        return _state;
    }
}

- (void)setState:(GQURLState)newState
{
    @synchronized(self) {
        [self willChangeValueForKey:@"state"];
        _state = newState;
        [self didChangeValueForKey:@"state"];
    }
}

- (void)main
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self increaseSVHTTPRequestTaskCount];
    });
    
    [self willChangeValueForKey:@"isExecuting"];
    self.state = GQURLStateExecuting;
    [self didChangeValueForKey:@"isExecuting"];
    
#if TARGET_OS_IPHONE
    // all requests should complete and run completion block unless we explicitely cancel them.
    self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        if(self.backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
            self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    }];
#endif
    if(self.operationSavePath) {
        [[NSFileManager defaultManager] createFileAtPath:self.operationSavePath contents:nil attributes:nil];
        self.operationFileHandle = [NSFileHandle fileHandleForWritingAtPath:self.operationSavePath];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
        BOOL inBackgroundAndInOperationQueue = (currentQueue != nil && currentQueue != [NSOperationQueue mainQueue]);
        
        if(inBackgroundAndInOperationQueue) {
            self.operationRunLoop = CFRunLoopGetCurrent();
            BOOL isWaiting = CFRunLoopIsWaiting(self.operationRunLoop);
            isWaiting?CFRunLoopWakeUp(self.operationRunLoop):CFRunLoopRun();
        }
    }
    
    if (self->_onRequestStartBlock) {
        self->_onRequestStartBlock(self);
    }
}

- (void)finish
{
    [self decreaseSVHTTPRequestTaskCount];
    
#if TARGET_OS_IPHONE
    if(self.backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }
#endif
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.state = GQURLStateFinished;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)increaseSVHTTPRequestTaskCount
{
    GQHTTPRequestTaskCount++;
    [self toggleNetworkActivityIndicator];
}

- (void)decreaseSVHTTPRequestTaskCount
{
    GQHTTPRequestTaskCount = MAX(0, GQHTTPRequestTaskCount-1);
    [self toggleNetworkActivityIndicator];
}

- (void)toggleNetworkActivityIndicator
{
#if TARGET_OS_IPHONE
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(GQHTTPRequestTaskCount > 0)];
    });
#endif
}

#pragma mark -- HandleResponseData

- (void)handleResponseData:(NSData *)data {
    dispatch_group_async(self.saveDataDispatchGroup, self.saveDataDispatchQueue, ^{
        if(self.operationSavePath) {
            @try {
                [self.operationFileHandle writeData:data];
            }@catch (NSException *exception) {
                NSError *writeError = [NSError errorWithDomain:@"GQHTTPRequestWriteError" code:0 userInfo:exception.userInfo];
                [self callCompletionBlockWithResponse:nil requestSuccess:NO error:writeError];
            }
        }
    });
    
    [self.operationData appendData:data];
    
    if(self.operationProgressBlock) {
        //If its -1 that means the header does not have the content size value
        if(self.expectedContentLength != -1) {
            self.receivedContentLength += data.length;
            self.operationProgressBlock(self.receivedContentLength/self.expectedContentLength);
        } else {
            //we dont know the full size so always return -1 as the progress
            self.operationProgressBlock(-1);
        }
    }
}

-(void)callCompletionBlockWithResponse:(NSData *)response
                        requestSuccess:(BOOL)requestSuccess
                                 error:(NSError *)error
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        if(self.operationRunLoop){
            CFRunLoopStop(self.operationRunLoop);
        }
    }
    self.responseData = self.operationData;
    NSError *serverError = error;
    if(!serverError) {
        serverError = [NSError errorWithDomain:NSURLErrorDomain
                                          code:NSURLErrorBadServerResponse
                                      userInfo:nil];
    }
    if(self.operationCompletionBlock && self.state != NSURLSessionTaskStateCanceling){
        self.operationCompletionBlock(self,requestSuccess,requestSuccess?nil:serverError);
    }
    [self finish];
}

@end
