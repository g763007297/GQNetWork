//
//  GQHTTPRequest.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GQHTTPRequestManager.h"
#import "GQNetworkConsts.h"

@class GQURLOperation;

@class GQURLSessionOpetation;

@interface GQHTTPRequest : NSObject
{
    void (^_onRequestStartBlock)();
    void (^_onRequestFinishBlock)(NSData *);
    void (^_onRequestCanceled)();
    void (^_onRequestFailedBlock)(NSError *);
    void (^_onRequestProgressChangedBlock)(float);
}

@property (nonatomic, assign) GQRequestMethod          requestMethod;
@property (nonatomic, assign) NSStringEncoding          requestEncoding;
@property (nonatomic, strong) NSString                  *filePath;
@property (nonatomic, strong) NSString                  *requestURL;
@property (nonatomic, strong) NSData                    *certificateData;
@property (nonatomic, strong) NSMutableDictionary       *requestParameters;
@property (nonatomic, strong) NSMutableURLRequest       *request;
@property (nonatomic, strong) NSMutableData             *bodyData;
@property (nonatomic, strong) GQURLOperation *urlOperation;
@property (nonatomic, assign) GQParameterEncoding      parmaterEncoding;

- (GQHTTPRequest *)initRequestWithParameters:(NSDictionary *)parameters
                                         URL:(NSString *)url
                             certificateData:(NSData *)certificateData
                                  saveToPath:(NSString *)filePath
                             requestEncoding:(NSStringEncoding)requestEncoding
                            parmaterEncoding:(GQParameterEncoding)parameterEncoding
                               requestMethod:(GQRequestMethod)requestMethod
                               onRequestStart:(void(^)())onStartBlock
                            onProgressChanged:(void(^)(float progress))onProgressChangedBlock
                            onRequestFinished:(void(^)(NSData *responseData))onFinishedBlock
                            onRequestCanceled:(void(^)())onCanceledBlock
                              onRequestFailed:(void(^)(NSError *error))onFailedBlock;

- (void)setTimeoutInterval:(NSTimeInterval)seconds;
- (void)addPostForm:(NSString *)key value:(NSString *)value;
- (void)addPostData:(NSString *)key data:(NSString *)data;
- (void)setRequestHeaderField:(NSString *)field value:(NSString *)value;
- (void)cancelRequest;
- (void)startRequest;

@end
