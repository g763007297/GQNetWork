//
//  GQHTTPRequest.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GQHTTPRequestManager.h"
#import "GQBaseDataRequest.h"
#import "GQNetwork.h"

@interface GQHTTPRequest : NSObject
{
    void (^_onRequestStartBlock)(GQUrlConnectionOperation *);
    void (^_onRequestFinishBlock)(GQUrlConnectionOperation *);
    void (^_onRequestCanceled)(GQUrlConnectionOperation *);
    void (^_onRequestFailedBlock)(GQUrlConnectionOperation *, NSError *);
    void (^_onRequestProgressChangedBlock)(GQUrlConnectionOperation *, float);
}

@property (nonatomic, assign) GQRequestMethod          requestMethod;
@property (nonatomic, assign) NSStringEncoding          requestEncoding;
@property (nonatomic, strong) NSString                  *filePath;
@property (nonatomic, strong) NSString                  *requestURL;
@property (nonatomic, strong) NSMutableDictionary       *requestParameters;
@property (nonatomic, strong) NSMutableURLRequest       *request;
@property (nonatomic, strong) NSMutableData             *bodyData;
@property (nonatomic, strong) GQUrlConnectionOperation *urlConnectionOperation;
@property (nonatomic, assign) GQParameterEncoding      parmaterEncoding;

- (GQHTTPRequest *)initRequestWithParameters:(NSDictionary *)parameters URL:(NSString *)url saveToPath:(NSString *)filePath requestEncoding:(NSStringEncoding)requestEncoding parmaterEncoding:(GQParameterEncoding)parameterEncoding  requestMethod:(GQRequestMethod)requestMethod
                               onRequestStart:(void(^)(GQUrlConnectionOperation *request))onStartBlock
                            onProgressChanged:(void(^)(GQUrlConnectionOperation *request,float progress))onProgressChangedBlock
                            onRequestFinished:(void(^)(GQUrlConnectionOperation *request))onFinishedBlock
                            onRequestCanceled:(void(^)(GQUrlConnectionOperation *request))onCanceledBlock
                              onRequestFailed:(void(^)(GQUrlConnectionOperation *request ,NSError *error))onFailedBlock;

- (void)setTimeoutInterval:(NSTimeInterval)seconds;
- (void)addPostForm:(NSString *)key value:(NSString *)value;
- (void)addPostData:(NSString *)key data:(NSString *)data;
- (void)setRequestHeaderField:(NSString *)field value:(NSString *)value;
- (void)cancelRequest;
- (void)startRequest;

@end
