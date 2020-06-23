//
//  GQRequestSerialization.m
//  GQNetWorkDemo
//
//  Created by gaoqi on 2020/3/26.
//  Copyright © 2020 gaoqi. All rights reserved.
//

#import "GQRequestSerialization.h"

#import <UIKit/UIKit.h>

#import "GQNetworkTrafficManager.h"

#import "GQQueryStringPair.h"

@interface GQRequestSerialization()
{
    BOOL  _isUploadFile;
}

@property (nonatomic, assign) GQRequestMethod           requestMethod;
@property (nonatomic, assign) NSStringEncoding          requestEncoding;

@property (nonatomic, strong) NSString                  *requestURL;
@property (nonatomic, strong) NSData                    *certificateData;
@property (nonatomic, strong) id                        requestParameters;
@property (nonatomic, strong) NSMutableDictionary       *headerParams;
@property (nonatomic, strong) NSArray                   *uploadDatas;
@property (nonatomic, strong) NSMutableURLRequest       *request;
@property (nonatomic, strong) NSMutableData             *bodyData;
@property (nonatomic, assign) GQParameterEncoding       parmaterEncoding;

@end

static NSString *boundary = @"----WebKitFormGQHTTPRequest7MA4YWxkTrZu0gW";

@implementation GQRequestSerialization

- (instancetype)initRequestWithParameters:(id)parameters
                             headerParams:(NSDictionary *)headerParams
                              uploadDatas:(NSArray *)uploadDatas
                                      URL:(NSString *)url
                          requestEncoding:(NSStringEncoding)requestEncoding
                         parmaterEncoding:(GQParameterEncoding)parameterEncoding
                            requestMethod:(GQRequestMethod)requestMethod {
    self = [super init];
    if (self) {
        self.requestURL = url;
        self.requestEncoding = requestEncoding;
        self.uploadDatas = uploadDatas;
        self.parmaterEncoding = parameterEncoding;
        self.requestMethod = requestMethod;
        
        _isUploadFile = NO;
        
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
    }
    return self;
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
    if ([self.requestParameters count] > 0) {
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

- (void)applyRequestHeader
{
    if (self.headerParams&&[[self.headerParams allKeys] count]>0) {
        [self.request setAllHTTPHeaderFields:self.headerParams];
    }
}

- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(NSString *)field {
    [self.request setValue:value forHTTPHeaderField:field];
}

- (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [self.request addValue:value forHTTPHeaderField:field];
}

- (void)setValue:(id)value forRequestBodyDataKey:(NSString *)key {
    [self.requestParameters setObject:value forKey:key];
}

- (NSURLRequest *)serialization {
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
    
    return self.request;
}

@end
