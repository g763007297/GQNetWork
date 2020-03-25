//
//  GQAFNetworkingManager.h
//  GQNetWorkDemo
//
//  Created by gaoqi on 2020/3/25.
//  Copyright © 2020 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GQAFNetworkingAdapt;

@interface GQAFNetworkingManager : NSObject

#if __has_include(<AFNetworking/AFURLSessionManager.h>) || __has_include("AFURLSessionManager.h")

+ (GQAFNetworkingManager *)sharedHttpRequestManager;

- (void)addRequest:(GQAFNetworkingAdapt *)request;

- (void)cancelRequest:(GQAFNetworkingAdapt *)request;

#endif

@end

NS_ASSUME_NONNULL_END
