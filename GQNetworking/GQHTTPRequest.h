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

@class GQBaseOperation;

@class GQURLSessionOpetation;

@interface GQHTTPRequest : NSObject
{
    void (^_onRequestStartBlock)(void);
    NSURLSessionResponseDisposition (^_onRechiveResponseBlock)(NSURLResponse *response);
    NSURLRequest *(^_onWillHttpRedirection)(NSURLRequest *request,NSURLResponse *response);
    NSInputStream *(^_onNeedNewBodyStream)(NSInputStream * originalStream);
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
@property (nonatomic, strong) GQBaseOperation           *urlOperation;
@property (nonatomic, assign) GQParameterEncoding       parmaterEncoding;

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
                         onNeedNewBodyStream:(NSInputStream *(^)(NSInputStream * originalStream))onNeedNewBodyStream
                         onWillCacheResponse:(NSCachedURLResponse *(^)(NSCachedURLResponse *proposedResponse))onWillCacheResponse
                           onProgressChanged:(void(^)(float progress))onProgressChangedBlock
                           onRequestFinished:(void(^)(NSData *responseData))onFinishedBlock
                           onRequestCanceled:(void(^)(void))onCanceledBlock
                             onRequestFailed:(void(^)(NSError *error))onFailedBlock;

- (void)setTimeoutInterval:(NSTimeInterval)seconds;
- (void)cancelRequest;
- (void)startRequest;

@end
