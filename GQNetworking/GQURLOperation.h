//
//  GQUrlConnectionOperation.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class GQURLOperation;

enum {
    GQURLStateReady = 0,
    GQURLStateExecuting,
    GQURLStateFinished
};
typedef NSUInteger GQURLState;

typedef void (^GQHTTPRequestCompletionHandler)(GQURLOperation *urlOperation,BOOL requestSuccess, NSError *error);

@interface GQURLOperation : NSOperation
{
    void (^_onRequestStartBlock)(GQURLOperation *);
}

@property (nonatomic, strong) NSURLRequest                      *operationRequest;
@property (nonatomic, strong) NSData                            *responseData;
@property (nonatomic, strong) NSHTTPURLResponse                 *operationURLResponse;
@property (nonatomic, readwrite) NSUInteger                     timeoutInterval;
@property (nonatomic, copy) GQHTTPRequestCompletionHandler      operationCompletionBlock;
@property (nonatomic, strong) NSFileHandle                      *operationFileHandle;

@property (nonatomic, strong) NSString                          *operationSavePath;

@property (nonatomic, strong) NSData                            *certificateData;

@property (nonatomic, strong) NSURLSession                      *operationSession;

@property (nonatomic, strong) NSURLSessionDataTask              *operationSessionTask;

@property (nonatomic, strong) NSURLConnection                   *operationConnection;
@property (nonatomic, strong) NSMutableData                     *operationData;
@property (nonatomic, assign) CFRunLoopRef                      operationRunLoop;
@property (nonatomic, readwrite) UIBackgroundTaskIdentifier     backgroundTaskIdentifier;

@property (nonatomic, readwrite) GQURLState                     state;
@property (nonatomic, readwrite) float                          expectedContentLength;
@property (nonatomic, readwrite) float                          receivedContentLength;
@property (nonatomic, copy) void (^operationProgressBlock)(float progress);

- (GQURLOperation *)initWithURLRequest:(NSURLRequest *)urlRequest
                            saveToPath:(NSString*)savePath
                       certificateData:(NSData *)certificateData
                              progress:(void (^)(float progress))progressBlock
                        onRequestStart:(void(^)(GQURLOperation *urlOperation))onStartBlock
                            completion:(GQHTTPRequestCompletionHandler)completionBlock;



@end
