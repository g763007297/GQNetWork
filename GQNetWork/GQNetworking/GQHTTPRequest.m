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
#import "CONSTS.h"
#import "NSJSONSerialization+GQAdditions.h"

@interface GQHTTPRequest()
{
    BOOL  _isUploadFile;
}

@end

@implementation GQHTTPRequest

static NSString *boundary = @"GQHTTPRequestBoundary";

- (void)dealloc
{
    self.requestURL = nil;
    self.request = nil;
    self.bodyData = nil;
    self.requestParameters = nil;
    self.urlConnectionOperation = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _isUploadFile = NO;
        self.requestURL = nil;
        self.requestParameters = nil;
        self.request = nil;
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

- (GQHTTPRequest *)initRequestWithParameters:(NSDictionary *)parameters URL:(NSString *)url  saveToPath:(NSString *)filePath requestEncoding:(NSStringEncoding)requestEncoding  parmaterEncoding:(GQParameterEncoding)parameterEncoding requestMethod:(GQRequestMethod)requestMethod onRequestStart:(void(^)(GQUrlConnectionOperation *request))onStartBlock
                            onProgressChanged:(void(^)(GQUrlConnectionOperation *request,float progress))onProgressChangedBlock
                            onRequestFinished:(void(^)(GQUrlConnectionOperation *request))onFinishedBlock
                            onRequestCanceled:(void(^)(GQUrlConnectionOperation *request))onCanceledBlock
                              onRequestFailed:(void(^)(GQUrlConnectionOperation *request ,NSError *error))onFailedBlock
{
    self = [self init];
    if (self) {
        _isUploadFile = NO;
        self.requestURL = url;
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
        self.request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.requestURL ]];
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
    
    __block BOOL hasData = NO;
    NSDictionary *paramsDict = (NSDictionary*)self.requestParameters;
    [paramsDict.allValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[NSData class]] || [obj isKindOfClass:[UIImage class]]){
            hasData = YES;
        }
    }];
    if(!hasData) {
        _isUploadFile = NO;
        NSString *paramString = GQAFQueryStringFromParametersWithEncoding(self.requestParameters,self.requestEncoding);
        NSData *postData = [paramString dataUsingEncoding:weakSelf.requestEncoding allowLossyConversion:YES];
        [weakSelf.bodyData appendData:postData];
    } else {
        _isUploadFile = YES;
        [paramsDict enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
            [weakSelf addBodyData:key value:value];
        }];
    }
}

- (NSMutableURLRequest *)generatePOSTRequest
{
    [self parseRequestParameters];
    [self.bodyData appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:self.requestEncoding]];
    long long postBodySize =  [self.bodyData length];
    if (_isUploadFile) {
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [self.request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    }else{
        [self.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    [self.request setValue:[NSString stringWithFormat:@"%llu",postBodySize] forHTTPHeaderField:@"Content-Length"];
    [self.request setHTTPBody:self.bodyData];
    [self.request setHTTPMethod:@"POST"];
    [[GQNetworkTrafficManager sharedManager] logTrafficOut:postBodySize];
    return  self.request;
}

- (NSMutableURLRequest *)generateURLJSONPOSTRequest{
    __weak GQHTTPRequest *weakSelf = self;
    
    [self.bodyData appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:self.requestEncoding]];
    
    __block BOOL isExitUplodeFile = NO;
    NSMutableDictionary *newParamsDic = [NSMutableDictionary new];
    NSDictionary *paramsDict = (NSDictionary*)self.requestParameters;
    [paramsDict enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL * stop) {
        if([value isKindOfClass:[NSData class]] || [value isKindOfClass:[UIImage class]]){
            [weakSelf addBodyData:key value:value];
            isExitUplodeFile = YES;
        }else{
            [newParamsDic setObject:value forKey:key];
        }
    }];
    long long postBodySize =  [self.bodyData length];
    
    if (isExitUplodeFile) {
        [self.request setHTTPBody:self.bodyData];
    }else{
        [self.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    postBodySize =  [self.bodyData length];
    
    if ([newParamsDic count]>0) {
        NSString *paramString = GQAFQueryStringFromParametersWithEncoding(newParamsDic,self.requestEncoding);
        NSUInteger found = [self.requestURL rangeOfString:@"?"].location;
        self.requestURL = [self.requestURL stringByAppendingFormat: NSNotFound == found ? @"?%@" : @"&%@", paramString];
    }
    [self.request setURL:[NSURL URLWithString:self.requestURL]];
    
    [self.request setHTTPMethod:@"POST"];
    [[GQNetworkTrafficManager sharedManager] logTrafficOut:postBodySize];
    return self.request;
}

- (NSMutableURLRequest *)generateJSONPOSTRequest
{
    long long postBodySize;
    if ([[self.requestParameters allKeys] count]) {
        NSString *jsonString = [NSJSONSerialization jsonStringFromDictionary:self.requestParameters];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        [self.bodyData appendData:jsonData];
        [self.bodyData appendData: [@"\r\n" dataUsingEncoding:self.requestEncoding]];
        postBodySize =  [self.bodyData length];
        [self.request setValue:[NSString stringWithFormat:@"%llu",postBodySize] forHTTPHeaderField:@"Content-Length"];
        [self.request setHTTPBody:self.bodyData];
    }
    
    [self.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.request setHTTPMethod:@"POST"];
    [[GQNetworkTrafficManager sharedManager] logTrafficOut:postBodySize];
    return  self.request;
}

- (NSMutableURLRequest *)generateGETRequest
{
    NSString *paramString = GQAFQueryStringFromParametersWithEncoding(self.requestParameters,self.requestEncoding);
    NSUInteger found = [self.requestURL rangeOfString:@"?"].location;
    self.requestURL = [self.requestURL stringByAppendingFormat: NSNotFound == found ? @"?%@" : @"&%@", paramString];
    [self.request setURL:[NSURL URLWithString:self.requestURL]];
    [self.request setHTTPMethod:@"GET"];
    long long postBodySize = [self.requestURL lengthOfBytesUsingEncoding:self.requestEncoding];
    [[GQNetworkTrafficManager sharedManager] logTrafficOut:postBodySize];
    return self.request;
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
                    
                case GQPropertyListParameterEncoding: {
                    
                }
                case GQURLJSONParameterEncoding:{
                    [self generateURLJSONPOSTRequest];
                }
                    break;
            }
            break;
        }
        case GQRequestMethodMultipartPost:{
            [self generatePOSTRequest];
        }
            break;
    }
    
    __weak typeof(self) weakself = self;
    
    self.urlConnectionOperation =  [[GQUrlConnectionOperation alloc] initWithURLRequest:self.request saveToPath:self.filePath progress:^(float progress) {
        if (_onRequestProgressChangedBlock) {
            _onRequestProgressChangedBlock(weakself.urlConnectionOperation,progress);
        }
    } onRequestStart:^(GQUrlConnectionOperation *urlConnectionOperation) {
        if (_onRequestStartBlock) {
            _onRequestStartBlock(weakself.urlConnectionOperation);
        }
    } completion:^(GQUrlConnectionOperation *urlConnectionOperation, BOOL requestSuccess, NSError *error) {
        if (requestSuccess) {
            if (_onRequestFinishBlock) {
                _onRequestFinishBlock(weakself.urlConnectionOperation);
            }
        }else{
            if (_onRequestFailedBlock) {
                _onRequestFailedBlock(weakself.urlConnectionOperation,error);
            }
        }
    }];
    [[GQHttpRequestManager sharedHttpRequestManager] addOperation:self.urlConnectionOperation];
}

- (void)cancelRequest
{
    [self.urlConnectionOperation cancel];
    if (_onRequestCanceled) {
        _onRequestCanceled(self.urlConnectionOperation);
    }
}



@end
