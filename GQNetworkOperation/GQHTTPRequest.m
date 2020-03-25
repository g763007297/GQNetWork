//
//  GQHTTPRequest.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GQHTTPRequest.h"
#import "GQQueryStringPair.h"
#import "GQHttpRequestManager.h"
#import "GQNetworkTrafficManager.h"
#import "GQURLOperation.h"
#import "GQSessionOperation.h"
#import "GQNetworkConsts.h"

@interface GQHTTPRequest()
{
    BOOL  _isUploadFile;
}

@end

@implementation GQHTTPRequest

static NSString *boundary = @"----WebKitFormGQHTTPRequest7MA4YWxkTrZu0gW";

- (void)dealloc
{
    self.urlOperation = nil;
    self.requestURL = nil;
    self.request = nil;
    self.bodyData = nil;
    self.requestParameters = nil;
    self.localFilePath = nil;
    self.certificateData = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _isUploadFile = NO;
        self.urlOperation = nil;
        self.requestURL = nil;
        self.requestParameters = nil;
        self.localFilePath = nil;
        self.certificateData = nil;
        self.request = nil;
        self.bodyData = nil;
    }
    return self;
}

- (void)setTimeoutInterval:(NSTimeInterval)seconds
{
    [self.request setTimeoutInterval:seconds];
}

- (void)applyRequestHeader
{
    if (self.headerParams&&[[self.headerParams allKeys] count]>0) {
        [self.request setAllHTTPHeaderFields:self.headerParams];
    }
}

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
                         onNeedNewBodyStream:(NSInputStream *(^)(NSURLSession *session,NSURLSessionTask *task))onNeedNewBodyStream
                         onWillCacheResponse:(NSCachedURLResponse *(^)(NSCachedURLResponse *proposedResponse))onWillCacheResponse
                           onProgressChanged:(void(^)(float progress))onProgressChangedBlock
                           onRequestFinished:(void(^)(NSData *responseData))onFinishedBlock
                           onRequestCanceled:(void(^)(void))onCanceledBlock
                             onRequestFailed:(void(^)(NSError *error))onFailedBlock
{
    self = [self init];
    if (self) {
        _isUploadFile = NO;
        self.requestURL = url;
        self.certificateData = certificateData;
        self.requestEncoding = requestEncoding;
        self.uploadDatas = uploadDatas;
        self.parmaterEncoding = parameterEncoding;
        self.requestMethod = requestMethod;
        self.localFilePath = localFilePath;
        if (parameters) {
            self.requestParameters = parameters;
        } else{
            self.requestParameters = @{};
        }
        
        if (headerParams) {
            self.headerParams = [[NSMutableDictionary alloc] initWithDictionary:headerParams];
        } else {
            self.headerParams = [[NSMutableDictionary alloc] initWithCapacity:0];
        }
        self.bodyData = [[NSMutableData alloc] init];
        self.request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.requestURL]];
        [self.request setTimeoutInterval:30];
        
        if (onStartBlock) {
            _onRequestStartBlock = [onStartBlock copy];
        }
        if (onRechiveResponseBlock) {
            _onRechiveResponseBlock = [onRechiveResponseBlock copy];
        }
        if (onWillHttpRedirection) {
            _onWillHttpRedirection = [onWillHttpRedirection copy];
        }
        if (onNeedNewBodyStream) {
            _onNeedNewBodyStream = [onNeedNewBodyStream copy];
        }
        if (onWillCacheResponse) {
            _onWillCacheResponse = [onWillCacheResponse copy];
        }
        if (onProgressChangedBlock) {
            _onRequestProgressChangedBlock = [onProgressChangedBlock copy];
        }
        if (onFinishedBlock) {
            _onRequestFinishBlock = [onFinishedBlock copy];
        }
        if (onCanceledBlock) {
            _onRequestCanceled = [onCanceledBlock copy];
        }
        if (onFailedBlock) {
            _onRequestFailedBlock = [onFailedBlock copy];
        }
    }
    return  self;
}

- (void)addBodyData:(NSString *)key value:(id)value
{
    [self addBodyData:key value:value contentType:nil fileName:nil];
}

- (void)addBodyData:(NSString *)key value:(id)value contentType:(NSString *)contentType fileName:(NSString *)fileName
{
    [self.bodyData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:self.requestEncoding]];
    if(![value isKindOfClass:[NSData class]] && ![value isKindOfClass:[UIImage class]]) {
        [self.bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:self.requestEncoding]];
        [self.bodyData appendData:[[NSString stringWithFormat:@"%@", value] dataUsingEncoding:self.requestEncoding]];
    } else {
        if (!fileName) {
            if ([value isKindOfClass:[UIImage class]]) {
                fileName = [NSString stringWithFormat:@"uploadfile_%@.jpeg",key];
            } else {
                fileName = [NSString stringWithFormat:@"uploadfile_%@",key];
            }
        }
        
        NSData *data = value;
        if ([value isKindOfClass:[UIImage class]]) {
            data = UIImageJPEGRepresentation(value, 1.0f);
        }
        
        [self.bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, fileName] dataUsingEncoding:self.requestEncoding]];
        
        if (!contentType) {
            if ([value isKindOfClass:[UIImage class]]) {
                contentType = @"image/jpeg";
            } else {
                contentType = @"application/octet-stream";
            }
        }
        
        [self.bodyData appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",contentType] dataUsingEncoding:self.requestEncoding]];
        [self.bodyData appendData:data];
    }
    [self.bodyData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:self.requestEncoding]];
}

- (void)parseRequestParameters
{
    GQWeakify(self);
    NSDictionary *paramsDict = (NSDictionary*)self.requestParameters;
    [paramsDict.allValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GQStrongify(self);
        if([obj isKindOfClass:[NSData class]] || [obj isKindOfClass:[UIImage class]]){
            self->_isUploadFile = YES;
        }
    }];
    [paramsDict enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        GQStrongify(self);
        [self addBodyData:key value:value];
    }];
}

- (void)parseRequestDatas
{
    if (self.uploadDatas&&[self.uploadDatas count]) {
        [self.uploadDatas enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * stop) {
            if ([obj isKindOfClass:[NSDictionary class]]&&[[obj allKeys] count] == 4) {
                [self addBodyData:obj[GQUploadKey] value:obj[GQUploadData] contentType:obj[GQUploadContentType] fileName:obj[GQUploadFileName]];
            }
        }];
    }
    if ([self.requestParameters count] > 0 || [self.uploadDatas count] > 0) {
        [self.bodyData appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:self.requestEncoding]];
    }
}

- (NSMutableURLRequest *)generateGETRequest
{
    if ([[self.requestParameters allKeys] count]) {
        NSString *paramString = GQQueryStringFromParametersWithEncoding(self.requestParameters,self.requestEncoding);
        NSUInteger found = [self.requestURL rangeOfString:@"?"].location;
        self.requestURL = [self.requestURL stringByAppendingFormat: NSNotFound == found ? @"?%@" : @"&%@", paramString];
    }
    [self.request setURL:[NSURL URLWithString:self.requestURL]];
    [self.request setHTTPMethod:@"GET"];
    long long postBodySize = [self.requestURL lengthOfBytesUsingEncoding:self.requestEncoding];
    [[GQNetworkTrafficManager sharedManager] logTrafficOut:postBodySize];
    return self.request;
}

- (NSMutableURLRequest *)generateDELETERequest
{
    [self parseRequestParameters];
    [self parseRequestDatas];
    [self generateRequestBody];
    [self.request setHTTPMethod:@"DELETE"];
    return self.request;
}

- (NSMutableURLRequest *)generatePUTRequest
{
    [self parseRequestParameters];
    [self parseRequestDatas];
    [self generateRequestBody];
    [self.request setHTTPMethod:@"PUT"];
    return self.request;
}

- (NSMutableURLRequest *)generateJSONPOSTRequest
{
    if ([[self.requestParameters allKeys] count]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.requestParameters options:NSJSONWritingPrettyPrinted error:nil];
        [self.bodyData appendData:jsonData];
    }
    [self generateRequestBody];
    [self.request setHTTPMethod:@"POST"];
    [self.headerParams setObject:@"application/json" forKey:@"Content-Type"];
    return  self.request;
}

- (NSMutableURLRequest *)generatePOSTRequest
{
    [self parseRequestParameters];
    [self parseRequestDatas];
    [self generateRequestBody];
    
    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.requestEncoding));
    [self.headerParams setObject:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@",charset] forKey:@"content-type"];
    [self.headerParams setObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    
    [self.request setHTTPMethod:@"POST"];
    return  self.request;
}

- (NSMutableURLRequest *)generateMultipartPostRequest
{
    [self parseRequestParameters];
    [self parseRequestDatas];
    [self generateRequestBody];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [self.headerParams addEntriesFromDictionary:@{@"Content-Type":contentType}];
    [self.request setHTTPMethod:@"POST"];
    return  self.request;
}

- (void)generateRequestBody
{
    long long postBodySize =  [self.bodyData length];
    [self.headerParams setObject:[NSString stringWithFormat:@"%llu",postBodySize] forKey:@"Content-Length"];
    [self.request setHTTPBody:self.bodyData];
    [[GQNetworkTrafficManager sharedManager] logTrafficOut:postBodySize];
}

- (void)startRequest
{
    if (![GQNetworkTrafficManager sharedManager].isReachability) {
        NSError *error = [NSError errorWithDomain:@"" code:GQRequestErrorNoNetWork userInfo:@{}];
        _onRequestFailedBlock(error);
        return;
    }
    
    switch (self.requestMethod) {
        case GQRequestMethodGet:{
            [self generateGETRequest];
        }
            break;
        case GQRequestMethodPost:{
            switch (self.parmaterEncoding) {
                case GQURLParameterEncoding: {
                    [self generatePOSTRequest];
                }
                    break;
                    
                case GQJSONParameterEncoding: {
                    [self generateJSONPOSTRequest];
                }
                    break;
            }
            break;
        }
        case GQRequestMethodMultipartPost:{
            [self generateMultipartPostRequest];
        }
            break;
        case GQRequestMethodPut:{
            [self generatePUTRequest];
        }
            break;
        case GQRequestMethodDelete:{
            [self generateDELETERequest];
        }
            break;
    }
    //添加请求头
    [self applyRequestHeader];
    Class operationClass;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        operationClass = [GQSessionOperation class];
    }else {
        operationClass = [GQURLOperation class];
    }
    
    if (operationClass) {
        GQWeakify(self);
        self.urlOperation = [[operationClass alloc]
                            initWithURLRequest:self.request
                              operationSession:[GQHttpRequestManager sharedHttpRequestManager].session
                              saveToPath:self.localFilePath
                              certificateData:self.certificateData
                              progress:^(float progress) {
                                  GQStrongify(self);
                                  if (self&&self->_onRequestProgressChangedBlock) {
                                      self->_onRequestProgressChangedBlock(progress);
                                  }
                              }
                              onRequestStart:^(GQBaseOperation *urlConnectionOperation) {
                                  GQStrongify(self);
                                  if (self&&self->_onRequestStartBlock) {
                                      self->_onRequestStartBlock();
                                  }
                              }
                              onRechiveResponse:^NSURLSessionResponseDisposition(NSURLResponse *response) {
                                  GQStrongify(self);
                                  if (self) {
                                      if (self->_onRechiveResponseBlock) {
                                          return self->_onRechiveResponseBlock(response);
                                      }
                                  }else{
                                      return NSURLSessionResponseCancel;
                                  }
                                  return NSURLSessionResponseAllow;
                              }
                              onWillHttpRedirection:^NSURLRequest *(NSURLRequest *request, NSURLResponse *response) {
                                  GQStrongify(self);
                                  if (self&&self->_onWillHttpRedirection) {
                                      return self->_onWillHttpRedirection(request,response);
                                  }
                                  return request;
                              }
                              onNeedNewBodyStream:^NSInputStream *(NSURLSession *session,NSURLSessionTask *task){
                                  GQStrongify(self);
                                if (self&&self->_onNeedNewBodyStream) {
                                    return self->_onNeedNewBodyStream(session,task);
                                }
                                return nil;
                              }
                              onWillCacheResponse:^NSCachedURLResponse *(NSCachedURLResponse *proposedResponse) {
                                  GQStrongify(self);
                                  if (self&&self->_onWillCacheResponse) {
                                      return self->_onWillCacheResponse(proposedResponse);
                                  }
                                  return proposedResponse;
                              }
                              completion:^(GQBaseOperation *urlConnectionOperation, BOOL requestSuccess, NSError *error) {
                                  GQStrongify(self);
                                  if (requestSuccess) {
                                      [[GQNetworkTrafficManager sharedManager] logTrafficIn:urlConnectionOperation.responseData.length];
                                      if (self&&self->_onRequestFinishBlock) {
                                          self->_onRequestFinishBlock(self.urlOperation.responseData);
                                      }
                                  }else{
                                      if (self&&self->_onRequestFailedBlock) {
                                          self->_onRequestFailedBlock(error);
                                      }
                                  }
                              }];
        [[GQHttpRequestManager sharedHttpRequestManager] addOperation:self.urlOperation];
    }else {
        NSError *error = [[NSError alloc] initWithDomain:@"class missing" code:-110 userInfo:@{@"userInfo":@"class missing"}];
        if (self&&self->_onRequestFailedBlock) {
            self->_onRequestFailedBlock(error);
        }
    }
}

- (void)cancelRequest
{
    [self.urlOperation cancel];
    if (_onRequestCanceled) {
        _onRequestCanceled();
    }
}

@end
