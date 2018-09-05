//
//  GQNetworkDefine.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/9/29.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#ifndef GQNetworkDefine_h
#define GQNetworkDefine_h

@class GQBaseDataRequest;
@class GQRequestResult;
#pragma mark -- blockTypedef  普通函数式block

typedef void (^GQRequestStart)(GQBaseDataRequest * request);//请求开始block
typedef NSURLSessionResponseDisposition (^GQRequestRechiveResponse)(GQBaseDataRequest * request,NSURLResponse *response);//收到请求头block
typedef NSURLRequest *(^GQRequestWillRedirection)(GQBaseDataRequest * request,NSURLRequest *urlRequest,NSURLResponse *response);//HTTP重定向block
typedef NSInputStream * (^GQRequestNeedNewBodyStream)(GQBaseDataRequest * request,NSInputStream *originalStream);//需要新的数据流block
typedef NSCachedURLResponse * (^GQRequestWillCacheResponse)(GQBaseDataRequest * request,NSCachedURLResponse *proposedResponse);//将要缓存到web的block
typedef void (^GQRequestFinished)(GQBaseDataRequest * request, GQRequestResult * result);//请求完成block
typedef void (^GQRequestCanceled)(GQBaseDataRequest * request);//请求取消block
typedef void (^GQRequestFailed)(GQBaseDataRequest * request, NSError * error);//请求失败block
typedef void (^GQProgressChanged)(GQBaseDataRequest * request, CGFloat progress);//请求进度改变block

#pragma mark -- ChainBlockTypedef 链式写法block

typedef GQBaseDataRequest *(^GQChainObjectRequest)(id value);//NSObject block
typedef GQBaseDataRequest *(^GQChainStuctRequest)(NSInteger value);   //NSInteger block
//typedef GQBaseDataRequest *(^GQDispatchRequest)(dispatch_queue_t value);

typedef void(^GQChainBlockStartRequest)(void);//发送请求block

typedef GQBaseDataRequest * (^GQChainBlockRequestStart)(GQRequestStart);//请求开始block
typedef GQBaseDataRequest * (^GQChainBlockRequestRechiveResponse)(GQRequestRechiveResponse);//收到请求头block
typedef GQBaseDataRequest * (^GQChainBlockRequestWillRedirection)(GQRequestWillRedirection);//HTTP重定向block
typedef GQBaseDataRequest * (^GQChainBlockRequestNeedNewBodyStream) (GQRequestNeedNewBodyStream);//需要新的数据流block
typedef GQBaseDataRequest * (^GQChainBlockRequestWillCacheResponse)(GQRequestWillCacheResponse);//将要缓存到web的block
typedef GQBaseDataRequest * (^GQChainBlockRequestFinished)(GQRequestFinished);//请求完成block
typedef GQBaseDataRequest * (^GQChainBlockRequestCanceled)(GQRequestCanceled);//请求取消block
typedef GQBaseDataRequest * (^GQChainBlockRequestFailed)(GQRequestFailed);//请求失败block
typedef GQBaseDataRequest * (^GQChainBlockProgressChanged)(GQProgressChanged);//请求进度改变block

#pragma mark -- GQDataRequestDelegate
@protocol GQDataRequestDelegate <NSObject>

@required
- (void)requestDidFinishLoad:(GQBaseDataRequest*)request mappingResult:(GQRequestResult *)result;//请求完成代理
- (void)request:(GQBaseDataRequest*)request didFailLoadWithError:(NSError*)error;//请求失败代理

@optional
- (void)requestDidStartLoad:(GQBaseDataRequest*)request;//请求开始代理
- (NSURLSessionResponseDisposition )requestRechiveResponse:(GQBaseDataRequest *)request urlResponse:(NSURLResponse *)response;//收到请求头代理
- (NSURLRequest *)requestWillRedirection:(GQBaseDataRequest *)request urlRequset:(NSURLRequest *)urlRequest urlResponse:(NSURLResponse *)response;//HTTP重定向代理
- (NSInputStream *)requestNeedNewBodyStream:(GQBaseDataRequest *)request originStream:(NSInputStream *)originStream;//需要新的数据流代理
- (NSCachedURLResponse *)requestWillCacheResponse:(GQBaseDataRequest *)request originStream:(NSCachedURLResponse *)originStream;//将要缓存到web代理
- (void)requestDidCancelLoad:(GQBaseDataRequest*)request;//请求取消代理
- (void)request:(GQBaseDataRequest*)request progressChanged:(CGFloat)progress;//请求数据变化代理

@end

#endif /* GQNetworkDefine_h */
