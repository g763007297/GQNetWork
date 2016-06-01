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

#if GQUSE_MaskView
#import "GQMaskActivityView.h"
#endif

@class GQObjectMapping;
@class GQMappingResult;

@class GQRequestDataHandler;
@class GQBaseDataRequest;

@protocol DataRequestDelegate <NSObject>

@optional
- (void)requestDidStartLoad:(GQBaseDataRequest*)request;//请求开始代理
- (void)requestDidFinishLoad:(GQBaseDataRequest*)request mappingResult:(GQMappingResult *)result;//请求完成代理
- (void)requestDidCancelLoad:(GQBaseDataRequest*)request;//请求取消代理
- (void)request:(GQBaseDataRequest*)request progressChanged:(CGFloat)progress;//请求数据变化代理
- (void)request:(GQBaseDataRequest*)request didFailLoadWithError:(NSError*)error;//请求失败代理

@end

@interface GQBaseDataRequest : NSObject
{
@protected
    BOOL        _usingCacheData;
    
    DataCacheManagerCacheType _cacheType;
#if GQUSE_MaskView
    GQMaskActivityView       *_maskActivityView;
#endif
    
    //progress related
    long long _totalData;
    long long _downloadedData;
    CGFloat   _currentProgress;
    
    NSString    *_cancelSubject;
    
    NSString    *_cacheKey;
    NSString    *_filePath;
    NSString    *_keyPath;
    NSDate      *_requestStartDate;
    
    //callback stuffs
    void (^_onRequestStartBlock)(GQBaseDataRequest *);
    void (^_onRequestFinishBlock)(GQBaseDataRequest *, GQMappingResult *);
    void (^_onRequestCanceled)(GQBaseDataRequest *);
    void (^_onRequestFailedBlock)(GQBaseDataRequest *, NSError *);
    void (^_onRequestProgressChangedBlock)(GQBaseDataRequest *, CGFloat);
    
    //the finall mapping result
    GQMappingResult    *_responseResult;
}

@property (nonatomic, strong) id<DataRequestDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL loading;
@property (nonatomic, assign) CGFloat currentProgress;
@property (nonatomic, assign) GQParameterEncoding parmaterEncoding;
@property (nonatomic, strong) NSString *rawResultString;
@property (nonatomic, strong, readonly) NSString *requestUrl;
@property (nonatomic, strong, readonly) NSMutableDictionary *userInfo;
@property (nonatomic, strong, readonly) GQRequestDataHandler *requestDataHandler;

#pragma mark - class methods using delegate

/**
 *  请求方法
 *
 *  @param delegate DataRequestDelegate
 *
 *  @return  GQBaseDataRequest
 */
+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate;

/**
 *  如果想一次性配置请求参数 则配置成GQRequestParameter
 *
 *  @param parameterBody parameterBody
 *  @param delegate      DataRequestDelegate
 *
 *  @return GQBaseDataRequest
 */
+ (id)requestWithRequestParameter:(GQRequestParameter *)parameterBody
                     withDelegate:(id<DataRequestDelegate>)delegate;

/**
 *  请求方法
 *
 *  @param delegate DataRequestDelegate
 *  @param params   请求体
 *
 *  @return GQBaseDataRequest
 */
+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
           withParameters:(NSDictionary*)params;
/**
 *  请求方法
 *
 *  @param delegate DataRequestDelegate
 *  @param subUrl   拼接url
 *
 *  @return GQBaseDataRequest
 */
+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
        withSubRequestUrl:(NSString*)subUrl;

/**
 *  请求方法
 *
 *  @param delegate      DataRequestDelegate
 *  @param subUrl        拼接url
 *  @param cancelSubject 取消请求NSNotification的Key
 *
 *  @return GQBaseDataRequest
 */

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
        withSubRequestUrl:(NSString*)subUrl
        withCancelSubject:(NSString*)cancelSubject;

#pragma mark - class methods using blocks

/**
 *  不需要添加参数的请求
 *
 *  @param onFinishedBlock 请求完成block
 *  @param onFailedBlock   请求失败block
 *
 *  @return self
 */
+ (id)requestWithOnRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
                   onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock;

/**
 *  添加请求体的request
 *
 *  @param params          请求体
 *  @param onFinishedBlock 请求完成block
 *  @param onFailedBlock   请求失败block
 *
 *  @return self
 */
+ (id)requestWithWithParameters:(NSDictionary*)params
              onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
                onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock;

/**
 *  添加请求体的request
 *
 *  @param params          请求体
 *  @param subUrl          拼接url
 *  @param onFinishedBlock 请求完成block
 *  @param onFailedBlock   请求失败block
 *
 *  @return self
 */
+ (id)requestWithWithParameters:(NSDictionary*)params
              withSubRequestUrl:(NSString*)subUrl
              onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
                onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock;

/**
 *  如果想一次性配置请求参数 则配置成GQRequestParameter
 *
 *  @param parameterBody          parameterBody
 *  @param onStartBlock           请求开始block
 *  @param onFinishedBlock        请求完成block
 *  @param onCanceledBlock        请求取消block
 *  @param onFailedBlock          请求失败block
 *  @param onProgressChangedBlock 请求进度block
 *
 *  @return GQBaseDataRequest
 */
+ (id)requestWithRequestParameter:(GQRequestParameter *)parameterBody
                   onRequestStart:(void(^)(GQBaseDataRequest *request))onStartBlock
                onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
                onRequestCanceled:(void(^)(GQBaseDataRequest *request))onCanceledBlock
                  onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock
                onProgressChanged:(void(^)(GQBaseDataRequest *request, CGFloat progress))onProgressChangedBlock;

#pragma mark -  file download class method using block
+ (id)requestWithParameters:(NSDictionary*)params
          withSubRequestUrl:(NSString*)subUrl
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
            onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock
          onProgressChanged:(void(^)(GQBaseDataRequest *request,CGFloat progress))onProgressChangedBlock;

#pragma mark - subclass not override method
- (void)notifyDelegateRequestDidErrorWithError:(NSError*)error;
- (void)notifyDelegateRequestDidSuccess;
- (void)doRelease;

#pragma mark - subclass can  override method
/*!
 * subclass can override the method, access data from responseResult and parse it to sepecfied data format
 */
- (void)processResult;
- (void)showIndicator:(BOOL)bshow;
- (void)doRequestWithParams:(NSDictionary*)params;
- (void)cancelRequest;                                     //subclass should override the method to cancel its request
- (void)handleResponseString:(NSString*)resultString;

- (BOOL)onReceivedCacheData:(NSObject*)cacheData;
- (BOOL)processDownloadFile;

- (GQParameterEncoding)getParameterEncoding;               //default method is GQURLParameterEncoding

- (GQRequestMethod)getRequestMethod;                       //default method is GET

- (NSStringEncoding)getResponseEncoding;

- (NSString*)getRequestUrl;

- (NSDictionary*)getStaticParams;

+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse;

#pragma mark - 假数据方法
- (BOOL)useDumpyData;
- (NSString*)dumpyResponseString;

@end
