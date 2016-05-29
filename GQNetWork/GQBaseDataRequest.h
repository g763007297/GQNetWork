//
//  GQBaseDataRequest.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GQDataCacheManager.h"
#import <UIKit/UIKit.h>
#import "GQNetwork.h"

#define USE_DUMPY_DATA	TRUE

@class GQObjectMapping;
@class GQMappingResult;

typedef enum : NSUInteger{
    GQRequestMethodGet = 0,
    GQRequestMethodPost = 1,           // content type = @"application/x-www-form-urlencoded"
    GQRequestMethodMultipartPost = 2,   // content type = @"multipart/form-data"
} GQRequestMethod;

@class GQRequestDataHandler;
@class GQBaseDataRequest;

@protocol DataRequestDelegate <NSObject>

@optional
- (void)requestDidStartLoad:(GQBaseDataRequest*)request;
- (void)requestDidFinishLoad:(GQBaseDataRequest*)request mappingResult:(GQMappingResult *)result;
- (void)requestDidCancelLoad:(GQBaseDataRequest*)request;
- (void)request:(GQBaseDataRequest*)request progressChanged:(CGFloat)progress;
- (void)request:(GQBaseDataRequest*)request didFailLoadWithError:(NSError*)error;

@end

@interface GQBaseDataRequest : NSObject
{
@protected
    BOOL        _useSilentAlert;
    BOOL        _usingCacheData;
    
    DataCacheManagerCacheType _cacheType;
//    GQMaskActivityView       *_maskActivityView;
    
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
@property (nonatomic, strong, readonly) NSDictionary *userInfo;
@property (nonatomic, strong, readonly) GQRequestDataHandler *requestDataHandler;

#pragma mark - init methods using delegate

/**
 *  请求方法
 *
 *  @param delegate DataRequestDelegate
 *
 *  @return  GQBaseDataRequest
 */
+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate;

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

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
        withSubRequestUrl:(NSString*)subUrl
           withParameters:(NSDictionary*)params
        withCancelSubject:(NSString*)cancelSubject;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
        withSubRequestUrl:(NSString*)subUrl
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
        withCancelSubject:(NSString*)cancelSubject;

+ (id)silentRequestWithDelegate:(id<DataRequestDelegate>)delegate
                        keyPath:(NSString*)keyPath
                        mapping:(GQObjectMapping*)mapping
                 withParameters:(NSDictionary*)params;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
           withParameters:(NSDictionary*)params;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
           withParameters:(NSDictionary*)params
             withCacheKey:(NSString*)cache
            withCacheType:(DataCacheManagerCacheType)cacheType;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
        withSubRequestUrl:(NSString*)subUrl
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
           withParameters:(NSDictionary*)params
        withCancelSubject:(NSString*)cancelSubject;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
        withIndicatorView:(UIView*)indiView;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
        withIndicatorView:(UIView*)indiView
        withCancelSubject:(NSString*)cancelSubject;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
           withParameters:(NSDictionary*)params
        withIndicatorView:(UIView*)indiView;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
           withParameters:(NSDictionary*)params
        withIndicatorView:(UIView*)indiView
             withCacheKey:(NSString*)cache
            withCacheType:(DataCacheManagerCacheType)cacheType;

+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
                  keyPath:(NSString*)keyPath
                  mapping:(GQObjectMapping*)mapping
           withParameters:(NSDictionary*)params
        withIndicatorView:(UIView*)indiView
        withCancelSubject:(NSString*)cancelSubject;

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
               keyPath:(NSString*)keyPath
               mapping:(GQObjectMapping*)mapping
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath;

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
     withSubRequestUrl:(NSString*)subUrl
               keyPath:(NSString*)keyPath
               mapping:(GQObjectMapping*)mapping
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
    withLoadingMessage:(NSString*)loadingMessage
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath;

#pragma mark - init methods using blocks

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
            onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
          withSubRequestUrl:(NSString*)subUrl
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
          withSubRequestUrl:(NSString*)subUrl
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
             onRequestStart:(void(^)(GQBaseDataRequest *request))onStartBlock
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
          onRequestCanceled:(void(^)(GQBaseDataRequest *request))onCanceledBlock
            onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
          withSubRequestUrl:(NSString*)subUrl
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
             onRequestStart:(void(^)(GQBaseDataRequest *request))onStartBlock
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
          onRequestCanceled:(void(^)(GQBaseDataRequest *request))onCanceledBlock
            onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock;

#pragma mark - file download related init methods
+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
          onProgressChanged:(void(^)(GQBaseDataRequest *request,CGFloat progress))onProgressChangedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
                    keyPath:(NSString*)keyPath
                    mapping:(GQObjectMapping*)mapping
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath
          onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
            onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock
          onProgressChanged:(void(^)(GQBaseDataRequest *request,CGFloat progress))onProgressChangedBlock;

- (id)initWithParameters:(NSDictionary*)params
       withSubRequestUrl:(NSString*)subUrl
       withIndicatorView:(UIView*)indiView
                 keyPath:(NSString*)keyPath
                 mapping:(GQObjectMapping*)mapping
      withLoadingMessage:(NSString*)loadingMessage
       withCancelSubject:(NSString*)cancelSubject
         withSilentAlert:(BOOL)silent
            withCacheKey:(NSString*)cache
           withCacheType:(DataCacheManagerCacheType)cacheType
            withFilePath:(NSString*)localFilePath
          onRequestStart:(void(^)(GQBaseDataRequest *request))onStartBlock
       onRequestFinished:(void(^)(GQBaseDataRequest *request, GQMappingResult *result))onFinishedBlock
       onRequestCanceled:(void(^)(GQBaseDataRequest *request))onCanceledBlock
         onRequestFailed:(void(^)(GQBaseDataRequest *request, NSError *error))onFailedBlock
       onProgressChanged:(void(^)(GQBaseDataRequest *request, CGFloat))onProgressChangedBlock;

- (void)notifyDelegateRequestDidErrorWithError:(NSError*)error;
- (void)notifyDelegateRequestDidSuccess;
- (void)doRelease;
/*!
 * subclass can override the method, access data from responseResult and parse it to sepecfied data format
 */
- (void)processResult;
- (void)showIndicator:(BOOL)bshow;
- (void)doRequestWithParams:(NSDictionary*)params;
- (void)cancelRequest;                                     //subclass should override the method to cancel its request
- (void)showNetowrkUnavailableAlertView:(NSString*)message;
- (void)handleResponseString:(NSString*)resultString;

- (BOOL)onReceivedCacheData:(NSObject*)cacheData;
- (BOOL)processDownloadFile;

- (GQParameterEncoding)getParameterEncoding;               //default method is GQURLParameterEncoding

- (GQRequestMethod)getRequestMethod;                       //default method is GET

- (NSStringEncoding)getResponseEncoding;

- (NSString*)encodeURL:(NSString *)string;
- (NSString*)getRequestUrl;

- (NSDictionary*)getStaticParams;

+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse;

#pragma mark - 假数据方法
- (BOOL)useDumpyData;
- (NSString*)dumpyResponseString;



@end
