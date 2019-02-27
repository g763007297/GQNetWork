//
//  GQOperation.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/10/23.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GQBaseOperation;

typedef void (^GQHTTPRequestStartHandler)(GQBaseOperation *urlOperation);
typedef NSURLSessionResponseDisposition (^GQHTTPRechiveResponseHandler)(NSURLResponse *response);
typedef  NSURLRequest *(^GQHTTPWillHttpRedirectionHandler)(NSURLRequest *request, NSURLResponse *response);
typedef NSInputStream * (^GQHTTPNeedNewBodyStreamHandler)(NSInputStream *originalStream);
typedef NSCachedURLResponse * (^GQHTTPWillCacheResponseHandler)(NSCachedURLResponse *proposedResponse);
typedef void (^GQHTTPRequestChangeHandler) (float progress);
typedef void (^GQHTTPRequestCompletionHandler)(GQBaseOperation *urlOperation,BOOL requestSuccess, NSError *error);

enum {
    GQURLStateReady = 0,
    GQURLStateExecuting,
    GQURLStateFinished
};
typedef NSUInteger GQURLState;

@interface GQBaseOperation : NSOperation
{
    GQHTTPRequestStartHandler           _onRequestStartBlock;
    GQHTTPRechiveResponseHandler        _onRechiveResponseBlock;
    GQHTTPWillHttpRedirectionHandler    _onWillHttpRedirectionBlock;
    GQHTTPNeedNewBodyStreamHandler      _onNeedNewBodyStreamBlock;
    GQHTTPWillCacheResponseHandler      _onWillCacheResponse;
}

@property (nonatomic, strong) NSURLRequest                      *operationRequest;
@property (nonatomic, strong) NSData                            *responseData;
@property (nonatomic, strong) NSHTTPURLResponse                 *operationURLResponse;
@property (nonatomic, strong) NSFileHandle                      *operationFileHandle;

@property (nonatomic, strong) NSString                          *operationSavePath;

@property (nonatomic, strong) NSData                            *certificateData;

@property (nonatomic, strong) NSURLSession                      *operationSession;

@property (nonatomic, strong) NSMutableData                     *operationData;
@property (nonatomic, assign) CFRunLoopRef                      operationRunLoop;
@property (nonatomic, readwrite) UIBackgroundTaskIdentifier     backgroundTaskIdentifier;

@property (nonatomic, readwrite) GQURLState                     state;
@property (nonatomic, readwrite) float                          expectedContentLength;
@property (nonatomic, readwrite) float                          receivedContentLength;

@property (nonatomic, copy) GQHTTPRequestChangeHandler          operationProgressBlock;
@property (nonatomic, copy) GQHTTPRequestCompletionHandler      operationCompletionBlock;

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

- (void)finish;
- (void)handleResponseData:(NSData *)data;
-(void)callCompletionBlockWithResponse:(NSData *)response
                        requestSuccess:(BOOL)requestSuccess
                                 error:(NSError *)error;

@end
