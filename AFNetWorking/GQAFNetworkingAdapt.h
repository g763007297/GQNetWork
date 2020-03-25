//
//  GQAFNetworkingAdapt.h
//  GQNetWorkDemo
//
//  Created by gaoqi on 2020/3/25.
//  Copyright © 2020 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GQNetworkConsts.h"

@protocol GQAFNetworkingAdaptDelegate <NSObject>

- (NSURL *)destination:(NSURL *)targetPath response:(NSURLResponse *) response;

- (void)progressChange:(NSProgress *) downloadProgress;

- (void)session:(NSURLResponse *)response
 responseObject:(id)responseObject
didCompleteWithError:(NSError *)error;

- (NSURLSessionResponseDisposition)session:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response;

- (NSURLRequest *)session:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSURLResponse *)response
newRequest:(NSURLRequest *)request;

- (NSInputStream *)SessionneedNewBodyStream:(NSURLSession *)session
task:(NSURLSessionTask *)task;

- (NSCachedURLResponse *)session:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
willCacheResponse:(NSCachedURLResponse *)proposedResponse;

@end

@interface GQAFNetworkingAdapt : NSObject <GQAFNetworkingAdaptDelegate>
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

@property (nonatomic, assign) GQRequestMethod           requestMethod;
@property (nonatomic, assign) NSStringEncoding          requestEncoding;
@property (nonatomic, strong) NSString                  *localFilePath;
@property (nonatomic, strong) NSString                  *requestURL;
@property (nonatomic, strong) NSData                    *certificateData;
@property (nonatomic, strong) NSDictionary              *requestParameters;
@property (nonatomic, strong) NSMutableDictionary       *headerParams;
@property (nonatomic, strong) NSArray                   *uploadDatas;
@property (nonatomic, strong) NSMutableURLRequest       *request;
@property (nonatomic, strong) NSMutableData             *bodyData;
@property (nonatomic, assign) GQParameterEncoding       parmaterEncoding;
@property (nonatomic, strong) NSURLSessionTask          *requestTask;

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
