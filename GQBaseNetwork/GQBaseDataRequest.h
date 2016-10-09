//
//  GQBaseDataRequest.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GQDataCacheManager.h"
#import "GQMappingResult.h"
#import "GQNetworkConsts.h"
#import "GQRequestParameter.h"
#import "GQNetworkDefine.h"

@class GQObjectMapping;
@class GQMappingResult;

@class GQRequestDataHandler;
@class GQMaskActivityView;

@interface GQBaseDataRequest : NSObject
{
@protected

    GQRequestMethod     _requestMethod;
    
    NSString            *_cacheKey;
    
    NSString            *_subRequestUrl;
    
    GQDataCacheManagerType _cacheType;
    
    NSString            *_keyPath;
    
    UIView              *_indicatorView;
    
    NSString            *_cancelSubject;
    
    //请求体
    NSDictionary        *_parameters;
    
    //请求头
    NSDictionary<NSString *,NSString *> *_headerParameters;
    
    NSString            *_localFilePath;
    
    //callback stuffs
    GQRequestStart      _onRequestStart;
    GQRequestRechiveResponse _onRequestRechiveResponse;
    GQRequestWillRedirection _onRequestWillRedirection;
    GQRequestNeedNewBodyStream _onRequestNeedNewBodyStream;
    GQRequestWillCacheResponse _onRequestWillCacheRespons;
    
    GQRequestFinished   _onRequestFinished;
    GQRequestCanceled   _onRequestCanceled;
    GQRequestFailed     _onRequestFailed;
    GQProgressChanged   _onProgressChanged;
    
    GQObjectMapping     *_mapping;
    //the finally mapping result
    GQMappingResult     *_responseResult;
}

@property (nonatomic, weak) id<GQDataRequestDelegate> delegate;//代理
@property (nonatomic, assign, readonly) BOOL loading;//是否正在加载
@property (nonatomic, copy, readonly) NSData *rawResultData;//请求回来的元数据
@property (nonatomic, copy, readonly) NSString *requestUrl;//请求地址
@property (nonatomic, copy, readonly) NSMutableDictionary *userInfo;//请求参数
@property (nonatomic, copy, readonly) GQRequestDataHandler *requestDataHandler;//解析方式

#pragma mark -- chain code methods   链式写法

+ (instancetype)prepareRequset;

/**
 *  请求地址    type : NSString
 */
@property (nonatomic, copy, readonly) GQChainObjectRequest requestUrlChain;

/**
 *  请求方法   type :枚举 GQRequestMethod
 */
@property (nonatomic, copy, readonly) GQChainStuctRequest requestMethodChain;

/**
 *  请求代理  type: self
 */
@property (nonatomic, copy, readonly) GQChainObjectRequest delegateChain;

/**
 *  拼接url  type : NSString
 */
@property (nonatomic, copy , readonly) GQChainObjectRequest subRequestUrlChain;

/**
 *  取消请求的key   type : NSString
 */
@property (nonatomic, copy , readonly) GQChainObjectRequest cancelSubjectChain;

/**
 *  mapping所需的key层级  type : NSString
 */
@property (nonatomic, copy , readonly) GQChainObjectRequest keyPathChain;

/**
 *  timeOutInterval    type  NSTimeInterval
 */
@property (nonatomic, copy, readonly) GQChainStuctRequest timeOutIntervalChain;

/**
 *  具体映射的关系   type : GQObjectMapping
 */
@property (nonatomic, copy , readonly) GQChainObjectRequest mappingChain;

/**
 *  请求头  type : NSDictionary
 */
@property (nonatomic, copy, readonly) GQChainObjectRequest headerParametersChain;

/**
 *  请求参数字典   type : NSDictionary
 */
@property (nonatomic, copy , readonly) GQChainObjectRequest parametersChain;

/**
 *  提示框所需要显示在哪个view上面  type : UIView
 */
@property (nonatomic, copy , readonly) GQChainObjectRequest indicatorViewChain;

/**
 *  缓存key   type : NSString
 */
@property (nonatomic, copy , readonly) GQChainObjectRequest cacheKeyChain;

/**
 *  缓存类型   type : GQDataCacheManagerType
 */
@property (nonatomic, copy , readonly) GQChainStuctRequest cacheTypeChain;

/**
 *  如果是需要把文件下载到某一个文件夹的话就传全地址  type : NSString
 */
@property (nonatomic, copy , readonly) GQChainObjectRequest localFilePathChain;

/**
 *  请求开始block    type : void (^GQRequestStart)(GQBaseDataRequest * request);
 */
@property (nonatomic, copy , readonly) GQChainBlockRequestStart onStartBlockChain;

/**
 *  收到请求头block   type : NSURLSessionResponseDisposition (^GQRequestRechiveResponse)(GQBaseDataRequest * request,NSURLResponse *response)
 */
@property (nonatomic, copy , readonly) GQChainBlockRequestRechiveResponse onRechiveResponseBlockChain;

/**
 *  HTTP重定向block type: NSURLRequest *(^GQRequestWillRedirection)(GQBaseDataRequest * request,NSURLRequest *urlRequest,NSURLResponse *response)
 */
@property (nonatomic, copy, readonly) GQChainBlockRequestWillRedirection onWillRedirectionBlockChain;

/**
 *  需要新的数据流block type: NSInputStream * (^GQRequestNeedNewBodyStream)(GQBaseDataRequest * request,NSInputStream *originalStream)
 */
@property (nonatomic, copy, readonly) GQChainBlockRequestNeedNewBodyStream onNeedNewBodyStreamBlockChain;

/**
 *  将要缓存到web的block  type : NSCachedURLResponse * (^GQRequestWillCacheResponse)(GQBaseDataRequest * request,NSCachedURLResponse *proposedResponse)
 */
@property (nonatomic, copy, readonly) GQChainBlockRequestWillCacheResponse onWillCacheResponseBlockChain;

/**
 *  请求完成block   type : void (^GQRequestFinished)(GQBaseDataRequest * request, GQMappingResult * result);
 */
@property (nonatomic, copy , readonly) GQChainBlockRequestFinished onFinishedBlockChain;

/**
 *  请求取消block   type : void (^GQRequestCanceled)(GQBaseDataRequest * request)
 */
@property (nonatomic, copy , readonly) GQChainBlockRequestCanceled onCanceledBlockChain;

/**
 *  请求失败block       type : void (^GQRequestFailed)(GQBaseDataRequest * request, NSError * error)
 */
@property (nonatomic, copy , readonly) GQChainBlockRequestFailed onFailedBlockChain;

/**
 *  请求进度改变block     type : void (^GQProgressChanged)(GQBaseDataRequest * request, CGFloat progress)
 */
@property (nonatomic, copy , readonly) GQChainBlockProgressChanged onProgressChangedBlockChain;

/**
 *  发起请求  不需要传值
 */
@property (nonatomic, copy, readonly) GQChainBlockStartRequest startRequestChain;

#pragma mark --  方法调用式写法  如果不习惯链式的block不自动提示的话就可以用下面的block写法  调用起来唯一的差别在于链式使用.调用  而下面的是方法调用
/**
 *  请求开始
 *
 *  @param onRequestStart 请求开始block
 *
 *  @return GQBaseDataRequest
 */
- (instancetype)onStartBlockChain:(GQRequestStart)onRequestStart;

/**
 *  收到请求头
 *
 *  @param onRechiveResponse 收到请求头block
 *
 *  @return GQBaseDataRequest
 */
- (instancetype)onRechiveResponseBlockChain:(GQRequestRechiveResponse)onRechiveResponse;

/**
 *  HTTP重定向
 *
 *  @param onWillRedirection HTTP重定向block
 *
 *  @return GQBaseDataRequest
 */
- (instancetype)onWillRedirectionBlockChain:(GQRequestWillRedirection)onWillRedirection;

/**
 *  需要新的数据流
 *
 *  @param onNeedNewBodyStream 需要新的数据流block
 *
 *  @return GQBaseDataRequest
 */
- (instancetype)onNeedNewBodyStreamBlockChain:(GQRequestNeedNewBodyStream)onNeedNewBodyStream;

/**
 *  将要缓存到web
 *
 *  @param onWillCacheResponse 将要缓存到web的block
 *
 *  @return GQBaseDataRequest
 */
- (instancetype)onWillCacheResponseBlockChain:(GQRequestWillCacheResponse)onWillCacheResponse;

/**
 *  请求完成
 *
 *  @param onRequestFinished 请求完成block
 *
 *  @return GQBaseDataRequest
 */
- (instancetype)onFinishedBlockChain:(GQRequestFinished)onRequestFinished;

/**
 *  请求取消
 *
 *  @param onRequestCanceled 请求取消block
 *
 *  @return GQBaseDataRequest
 */
- (instancetype)onCanceledBlockChain:(GQRequestCanceled)onRequestCanceled;
/**
 *  请求失败
 *
 *  @param onRequestFailed 请求失败block
 *
 *  @return GQBaseDataRequest
 */
- (instancetype)onFailedBlockChain:(GQRequestFailed)onRequestFailed;
/**
 *  请求进度改变
 *
 *  @param onProgressChanged 请求进度改变block
 *
 *  @return GQBaseDataRequest
 */
- (instancetype)onProgressChangedBlockChain:(GQProgressChanged)onProgressChanged;

/**
 *  发起请求
 */
- (void)startRequest;

#pragma mark - subclass not override method
- (void)notifyRequestDidStart;
- (void)notifyRequestDidChange:(float)progress;
- (void)notifyRequestDidSuccess;
- (void)notifyRequestDidErrorWithError:(NSError*)error;
- (void)notifyRequestDidCancel;
- (NSURLSessionResponseDisposition)notifyRequestRechiveResponse:(NSURLResponse *)response;
- (NSURLRequest *)notifyRequestWillRedirection:(NSURLRequest *)request response:(NSURLResponse *)response;
- (NSInputStream *)notifyRequestNeedNewBodyStream:(NSInputStream *)originalStream;
- (NSCachedURLResponse *)notifyRequestWillCacheResponse:(NSCachedURLResponse *)proposedResponse;

- (void)doRelease;

#pragma mark - subclass can  override method(@required)

/**
 *  请求url  必须重写的方法
 *
 *  @return requestUrl
 */
- (NSString*)getRequestUrl;

/**
 *  host
 *
 *  @return BaseUrl
 */
- (NSString *)getBaseUrl;

#pragma mark - subclass can  override method(@optional)

/*!
 * subclass can override the method, access data from responseResult and parse it to sepecfied data format
 */
- (void)processResult;
- (void)showIndicator:(BOOL)bshow;
- (void)doRequestWithParams:(NSDictionary*)params;

/**
 *  取消请求  subclass should override the method to cancel its request
 */
- (void)cancelRequest;

/**
 *  处理请求结果，如果需要自己解析数据那就覆盖该方法，但是需要处理结果逻辑
 *
 *  @param result 请求结果
 */
- (void)handleResponseString:(id)result;

/**
 *  如果需要处理缓存就覆盖这个方法  前提是要使用到了缓存
 *
 *  @param cacheData 缓存数据
 *
 *  @return 是否使用缓存数据
 */
- (BOOL)onReceivedCacheData:(NSObject*)cacheData;

/**
 *  处理下载文件   比如说 copy 取数据之类的   最终效验文件的合法性
 *
 *  @return 是否请求成功
 */
- (BOOL)processDownloadFile;

/**
 *  请求体的encoding  //default method is GQURLParameterEncoding
 *
 *  @return  parameterEncoding
 */
- (GQParameterEncoding)getParameterEncoding;

/**
 *  请求方法  默认为GET  //default method is GET
 *
 *  @return requestMethod
 */
- (GQRequestMethod)getRequestMethod;

/**
 *  请求体encode格式  默认为NSUTF8StringEncoding
 *
 *  @return  responseEncoding
 */
- (NSStringEncoding)getResponseEncoding;

/**
 *  请求时的弹出框loading信息  默认为 “正在加载...”
 *
 *  @return NSString *
 */
- (NSString *)getLoadingMessage;

/**
 *  映射关系  默认为nil
 *
 *  @return GQObjectMapping *
 */
- (GQObjectMapping *)getMapping;

/**
 *  静态的请求参数   默认为nil
 *
 *  @return NSDictionary *
 */
- (NSDictionary*)getStaticParams;

/**
 *  静态的请求头参数   默认为nil
 *
 *  @return NSDictionary *
 */
- (NSDictionary *)getStaticHeaderParams;

/**
 *  设置超时时间  默认为30秒
 *
 *  @return NSInteger
 */
- (NSInteger)getTimeOutInterval;

/**
 *   从缓存string中提取字典
 *
 *  @param cachedResponse 缓存string
 *
 *  @return NSDictionary *
 */
+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse;

/**
 *  子类覆盖该方法修改数据解析方式  默认为json解析
 */
- (GQRequestDataHandler *)generateRequestHandler;

/**
 *  https证书二进制数据
 *
 *  @return NSData*
 */
- (NSData *)getCertificateData;

/**
 *  是否使用网站自带cookie  默认为NO
 *
 *  @return BOOL
 */
- (BOOL)useStorageCookie;

/**
 *  设置userAgent   默认为系统参数
 *
 *  @return NSString *
 */
- (NSString *)userAgentString;

#pragma mark - 假数据方法
/**
 *  是否使用假数据 默认为NO
 *
 *  @return BOOL
 */
- (BOOL)useDumpyData;

/**
 *  假数据字符串
 *
 *  @return BOOL
 */
- (NSString*)dumpyResponseString;

@end
