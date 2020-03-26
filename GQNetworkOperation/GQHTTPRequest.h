//
//  GQHTTPRequest.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GQHttpRequestManager.h"
#import "GQNetworkConsts.h"
#import "GQRequestSerialization.h"

@class GQBaseOperation;

@class GQURLSessionOpetation;

@interface GQHTTPRequest : NSObject
{
    void (^_onRequestStartBlock)(void);
    NSURLSessionResponseDisposition (^_onRechiveResponseBlock)(NSURLResponse *response);
    NSURLRequest *(^_onWillHttpRedirection)(NSURLRequest *request,NSURLResponse *response);
    NSInputStream *(^_onNeedNewBodyStream)(NSURLSession *session,NSURLSessionTask *task);
    NSCachedURLResponse *(^_onWillCacheResponse)(NSCachedURLResponse *proposedResponse);
    void (^_onRequestFinishBlock)(NSData *);
    void (^_onRequestCanceled)(void);
    void (^_onRequestFailedBlock)(NSError *);
    void (^_onRequestProgressChangedBlock)(float);
}

@property (nonatomic, strong, readonly) NSString                  *localFilePath;
@property (nonatomic, strong, readonly) NSData                    *certificateData;

- (instancetype)initRequestWithParameters:(NSDictionary *)parameters
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
                             onRequestFailed:(void(^)(NSError *error))onFailedBlock;

- (void)setTimeoutInterval:(NSTimeInterval)seconds;
- (void)cancelRequest;
- (void)startRequest;

@end
