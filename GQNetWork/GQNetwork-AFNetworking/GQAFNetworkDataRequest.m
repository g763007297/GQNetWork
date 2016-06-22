//
//  GQAFNetworkDataRequest.m
//  GQNetWorkDemo
//
//  Created by tusm on 16/6/20.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQAFNetworkDataRequest.h"

#import <AFNetworking/AFHTTPSessionManager.h>
#import "GQQueryStringPair.h"
#import "GQDataRequestManager.h"

#import "GQDebug.h"

@interface GQAFNetworkDataRequest(){
      AFHTTPSessionManager *_requestOperation;
}

@end

@implementation GQAFNetworkDataRequest

- (NSMutableURLRequest *)requestWithParams:(NSDictionary *)params url:(NSString *)url
{
    NSStringEncoding stringEncoding = NSUTF8StringEncoding;
    // process params
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithCapacity:10];
    [allParams addEntriesFromDictionary: params];
    NSDictionary *staticParams = [self getStaticParams];
    if (staticParams != nil) {
        [allParams addEntriesFromDictionary:staticParams];
    }
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    // used to monitor network traffic , this is not accurate number.
    long long postBodySize = 0;
    if (GQRequestMethodGet == [self getRequestMethod]) {
        NSString *paramString = GQQueryStringFromParametersWithEncoding(allParams, stringEncoding);
        NSUInteger found = [url rangeOfString:@"?"].location;
        url = [url stringByAppendingFormat: NSNotFound == found? @"?%@" : @"&%@", paramString];
        URL = [NSURL URLWithString:url];
        [request setURL:URL];
        [request setHTTPMethod:@"GET"];
        postBodySize += [url lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        GQDINFO(@"request url %@", url);
    }
    else {
//        switch (self.parmaterEncoding) {
//            case ITTURLParameterEncoding: {
//                NSData *data = nil;
//                AFStreamingMultipartFormData *formData = [[AFStreamingMultipartFormData alloc] initWithURLRequest:request stringEncoding:NSUTF8StringEncoding];
//                for (ITTAFQueryStringPair *pair in ITTAFQueryStringPairsFromDictionary(allParams)) {
//                    NSString *key = [pair.field description];
//                    if ([pair.value isKindOfClass:[NSData class]]) {
//                        [formData appendPartWithFileData:pair.value name:key fileName:key mimeType:@"image/jpg"];
//                    }
//                    else if ([pair.value isKindOfClass:[UIImage class]]) {
//                        data = UIImageJPEGRepresentation(pair.value, 1.0);
//                        [formData appendPartWithFileData:data name:key fileName:@"image.jpg" mimeType:@"image/jpg"];
//                    }
//                    else if ([pair.value isKindOfClass:[ITTFileModel class]]) {
//                        ITTFileModel *fileModel = pair.value;
//                        [formData appendPartWithFileData:fileModel.data name:key fileName:fileModel.fileName mimeType:fileModel.mimeType];
//                    }
//                    else {
//                        data = [[pair.value description] dataUsingEncoding:NSUTF8StringEncoding];
//                        [formData appendPartWithFormData:data name:key];
//                    }
//                }
//                request = [formData requestByFinalizingMultipartFormData];
//                break;
//            }
//            case ITTJSONParameterEncoding: {
//                NSError *error = nil;
//                NSString *contentType = [self contentType];
//                [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wassign-enum"
//                NSString *jsonString = [NSJSONSerialization jsonStringFromDictionary:allParams];
//                NSData *jsonFormatPostData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//                //                NSData *jsonFormatPostData = [NSJSONSerialization dataWithJSONObject:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
//                [request setHTTPBody:jsonFormatPostData];
//                if (error) {
//                    ITTDERROR(@"create request error %@", error);
//                }
//                postBodySize += [jsonFormatPostData length];
//#pragma clang diagnostic pop
//                break;
//            }
//            case ITTPropertyListParameterEncoding:
//                //to do
//                break;
//            default:
//                break;
//        }
//        [request setHTTPMethod:@"POST"];
//        ITTDINFO(@"request url %@", url);
    }
    [request addValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
//    [[ITTNetworkTrafficManager sharedManager] logTrafficOut:postBodySize];
    return request;
}


+ (void)showNetworkActivityIndicator
{
#if TARGET_OS_IPHONE
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
#endif
}

+ (void)hideNetworkActivityIndicator
{
#if TARGET_OS_IPHONE
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
#endif
}

- (void)networkingOperationDidStart:(NSNotification *)notification
{
//    ITTDINFO(@"- (void)networkingOperationDidStart:(NSNotification *)notification");
//    AFURLConnectionOperation *connectionOperation = [notification object];
//    if (connectionOperation.request.URL) {
//        [[self class] showNetworkActivityIndicator];
//        [self showIndicator:TRUE];
//    }
}

- (void)networkingOperationDidFinish:(NSNotification *)notification
{
//    ITTDINFO(@"- (void)networkingOperationDidFinish:(NSNotification *)notification");
//    AFURLConnectionOperation *connectionOperation = [notification object];
//    if (connectionOperation.request.URL) {
//        [[self class] hideNetworkActivityIndicator];
//        [self showIndicator:FALSE];
//    }
}

- (void)doRequestWithParams:(NSDictionary *)params{
    
}


- (void)notifyDelegateDownloadProgress
{
    //using block
//    if (_onRequestProgressChangedBlock) {
//        _onRequestProgressChangedBlock(self, _currentProgress);
//    }
}

- (void)generateRequestWithUrl:(NSString*)url withParameters:(NSDictionary*)params
{
    NSMutableURLRequest *request = [self requestWithParams:params url:url];
}

@end
