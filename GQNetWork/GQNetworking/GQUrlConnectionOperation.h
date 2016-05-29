//
//  GQUrlConnectionOperation.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class GQUrlConnectionOperation;

enum {
    GQHTTPRequestStateReady = 0,
    GQHTTPRequestStateExecuting,
    GQHTTPRequestStateFinished
};
typedef NSUInteger GQHTTPRequestState;

enum {
    GQHTTPRequestMethodGET = 0,
    GQHTTPRequestMethodPOST,
    GQHTTPRequestMethodPUT,
    GQHTTPRequestMethodDELETE,
    GQHTTPRequestMethodHEAD
};
typedef NSUInteger GQHTTPRequestMethod;

typedef void (^GQHTTPRequestCompletionHandler)(GQUrlConnectionOperation *urlConnectionOperation,BOOL requestSuccess, NSError *error);

@interface GQUrlConnectionOperation : NSOperation
{
    void (^_onRequestStartBlock)(GQUrlConnectionOperation *);
}

@property (nonatomic, strong) NSMutableURLRequest           *operationRequest;
@property (nonatomic, strong) NSData                        *responseData;
@property (nonatomic, strong) NSString                      *responseString;
@property (nonatomic, strong) NSHTTPURLResponse             *operationURLResponse;
@property (nonatomic, readwrite) NSUInteger                 timeoutInterval;
@property (nonatomic, copy) GQHTTPRequestCompletionHandler operationCompletionBlock;
@property (nonatomic, strong) NSFileHandle                  *operationFileHandle;

@property (nonatomic, strong) NSString                      *operationSavePath;

@property (nonatomic, strong) NSURLConnection               *operationConnection;
@property (nonatomic, strong) NSMutableData                 *operationData;
@property (nonatomic, assign) CFRunLoopRef                  operationRunLoop;
//@property (nonatomic, strong) NSTimer                       *timeoutTimer;
@property (nonatomic, readwrite) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (nonatomic, readwrite) GQHTTPRequestState        state;
@property (nonatomic, readwrite) float                      expectedContentLength;
@property (nonatomic, readwrite) float                      receivedContentLength;
@property (nonatomic, copy) void (^operationProgressBlock)(float progress);

- (GQUrlConnectionOperation *)initWithURLRequest:(NSURLRequest *)urlRequest saveToPath:(NSString*)savePath progress:(void (^)(float progress))progressBlock           onRequestStart:(void(^)(GQUrlConnectionOperation *urlConnectionOperation))onStartBlock
                                       completion:(GQHTTPRequestCompletionHandler)completionBlock;



@end
