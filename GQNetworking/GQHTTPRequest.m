//
//  GQHTTPRequest.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQHTTPRequest.h"
#import "GQQueryStringPair.h"
#import "GQHttpRequestManager.h"
#import "GQNetworkTrafficManager.h"
#import "NSJSONSerialization+GQAdditions.h"
#import "GQURLOperation.h"
#import "GQNetworkConsts.h"

@interface GQHTTPRequest()
{
    BOOL  _isUploadFile;
}

@end

@implementation GQHTTPRequest

static NSString *boundary = @"GQHTTPRequestBoundary";

- (void)dealloc
{
    self.urlOperation = nil;
    self.requestURL = nil;
    self.request = nil;
    self.bodyData = nil;
    self.requestParameters = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _isUploadFile = NO;
        self.urlOperation = nil;
        self.requestURL = nil;
        self.requestParameters = nil;
        self.request = nil;
        self.bodyData = nil;
    }
    return self;
}

- (void)setRequestHeaderField:(NSString *)field value:(NSString *)value
{
    [self.request setValue:value forHTTPHeaderField:field];
}

- (void)setTimeoutInterval:(NSTimeInterval)seconds
{
    [self.request setTimeoutInterval:seconds];
}

- (void)addPostForm:(NSString *)key value:(NSString *)value
{
    [self.requestParameters setObject:value forKey:key];
}

- (void)addPostData:(NSString *)key data:(NSString *)data
{
    [self.requestParameters setObject:data forKey:key];
}

- (GQHTTPRequest *)initRequestWithParameters:(NSDictionary *)parameters URL:(NSString *)url certificateData:(NSData *)certificateData saveToPath:(NSString *)filePath requestEncoding:(NSStringEncoding)requestEncoding  parmaterEncoding:(GQParameterEncoding)parameterEncoding requestMethod:(GQRequestMethod)requestMethod onRequestStart:(void(^)())onStartBlock
                            onProgressChanged:(void(^)(float progress))onProgressChangedBlock
                            onRequestFinished:(void(^)(NSData *responseData))onFinishedBlock
                            onRequestCanceled:(void(^)())onCanceledBlock
                              onRequestFailed:(void(^)(NSError *error))onFailedBlock
{
    self = [self init];
    if (self) {
        _isUploadFile = NO;
        self.requestURL = url;
        self.certificateData = certificateData;
        self.requestEncoding = requestEncoding;
        self.parmaterEncoding = parameterEncoding;
        self.requestMethod = requestMethod;
        self.filePath = filePath;
        if (parameters) {
            self.requestParameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
        }else{
            self.requestParameters = [[NSMutableDictionary alloc] initWithCapacity:0];
        }
        self.bodyData = [[NSMutableData alloc] init];
        self.request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.requestURL]];
        [self.request setTimeoutInterval:60];
        
        if (onStartBlock) {
            _onRequestStartBlock = [onStartBlock copy];
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

- (void)addBodyData:(NSString *)key value:(id)value
{
    if(![value isKindOfClass:[NSData class]] && ![value isKindOfClass:[UIImage class]]) {
        [self.bodyData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:self.requestEncoding]];
        [self.bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:self.requestEncoding]];
        [self.bodyData appendData:[[NSString stringWithFormat:@"%@", value] dataUsingEncoding:self.requestEncoding]];
        [self.bodyData appendData:[@"\r\n" dataUsingEncoding:self.requestEncoding]];
    } else {
        NSString *fileName = nil;
        NSData *data = nil;
        if ([value isKindOfClass:[UIImage class]]) {
            fileName = [NSString stringWithFormat:@"uploadfile_%@.png",key];
            data = UIImageJPEGRepresentation(value, 0.5f);
        } else {
            fileName = [NSString stringWithFormat:@"uploadfile_%@",key];
            data = value;
        }
        
        [self.bodyData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:self.requestEncoding]];
        [self.bodyData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, fileName] dataUsingEncoding:self.requestEncoding]];
        if ([value isKindOfClass:[UIImage class]]) {
            [self.bodyData appendData:[[NSString stringWithFormat:@"Content-Type: image/png\r\n\r\n"] dataUsingEncoding:self.requestEncoding]];
        } else {
            [self.bodyData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:self.requestEncoding]];
        }
        [self.bodyData appendData:data];
        [self.bodyData appendData:[@"\r\n" dataUsingEncoding:self.requestEncoding]];
    }
}

- (void)parseRequestParameters
{
    __weak GQHTTPRequest *weakSelf = self;
    
    NSDictionary *paramsDict = (NSDictionary*)self.requestParameters;
    [paramsDict.allValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[NSData class]] || [obj isKindOfClass:[UIImage class]]){
            _isUploadFile = YES;
        }
    }];
    [paramsDict enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        [weakSelf addBodyData:key value:value];
    }];
}

- (NSMutableURLRequest *)generateDELETERequest{
    [self parseRequestParameters];
    [self generateRequestBody];
    [self.request setHTTPMethod:@"DELETE"];
    return self.request;
}

- (NSMutableURLRequest *)generatePUTRequest{
    [self parseRequestParameters];
    [self generateRequestBody];
    [self.request setHTTPMethod:@"PUT"];
    return self.request;
}

- (NSMutableURLRequest *)generateJSONPOSTRequest
{
    if ([[self.requestParameters allKeys] count]) {
        NSString *jsonString = [NSJSONSerialization jsonStringFromDictionary:self.requestParameters];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        [self.bodyData appendData:jsonData];
    }
    [self generateRequestBody];
    [self.request setHTTPMethod:@"POST"];
    [self.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return  self.request;
}

- (NSMutableURLRequest *)generatePOSTRequest
{
    [self parseRequestParameters];
    [self generateRequestBody];
    [self.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
    [self.request setHTTPMethod:@"POST"];
    return  self.request;
}

- (NSMutableURLRequest *)generateMultipartPostRequest{
    [self parseRequestParameters];
    [self generateRequestBody];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [self.request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [self.request setHTTPMethod:@"POST"];
    return  self.request;
}

- (void)generateRequestBody{
    [self.bodyData appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:self.requestEncoding]];
    long long postBodySize =  [self.bodyData length];
    [self.request setValue:[NSString stringWithFormat:@"%llu",postBodySize] forHTTPHeaderField:@"Content-Length"];
    [self.request setHTTPBody:self.bodyData];
    [[GQNetworkTrafficManager sharedManager] logTrafficOut:postBodySize];
}

- (void)startRequest
{
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
    
    __weak typeof(self) weakSelf = self;
    self.urlOperation =  [[GQURLOperation alloc] initWithURLRequest:self.request saveToPath:self.filePath certificateData:self.certificateData progress:^(float progress) {
        __strong typeof(weakSelf) strongSelf= weakSelf;
        if (strongSelf->_onRequestProgressChangedBlock) {
            strongSelf->_onRequestProgressChangedBlock(progress);
        }
    } onRequestStart:^(GQURLOperation *urlConnectionOperation) {
        __strong typeof(weakSelf) strongSelf= weakSelf;
        if (strongSelf->_onRequestStartBlock) {
            strongSelf->_onRequestStartBlock();
        }
    } completion:^(GQURLOperation *urlConnectionOperation, BOOL requestSuccess, NSError *error) {
        __strong typeof(weakSelf) strongSelf= weakSelf;
        if (requestSuccess) {
            if (strongSelf->_onRequestFinishBlock) {
                strongSelf->_onRequestFinishBlock(strongSelf.urlOperation.responseData);
            }
        }else{
            if (strongSelf->_onRequestFailedBlock) {
                strongSelf->_onRequestFailedBlock(error);
            }
        }
    }];
    [[GQHttpRequestManager sharedHttpRequestManager] addOperation:self.urlOperation];
}

- (void)cancelRequest
{
    [self.urlOperation cancel];
    if (_onRequestCanceled) {
        _onRequestCanceled(self.urlOperation);
    }
}

@end
