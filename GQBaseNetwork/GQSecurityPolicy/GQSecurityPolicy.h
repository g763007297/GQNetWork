//
//  GQSecurityPolicy.h
//  GQNetWorkDemo
//
//  Created by tusm on 16/6/24.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQSecurityPolicy : NSObject

@property (nonatomic, copy) NSURLCredential *credential;

/**
 *  根据服务器的证书进行创建
 *
 *  @param challenge 需要授权
 *
 *  @return GQSecurityPolicy
 */
+ (GQSecurityPolicy *)defaultServerTrust:(NSURLAuthenticationChallenge *)challenge;

/**
 *  根据file创建GQSecurityPolicy
 *
 *  @param cerData   证书的二进制数据
 *  @param challenge 需要授权
 *
 *  @return GQSecurityPolicy
 */
+ (GQSecurityPolicy *)defaultSecurityPolicy:(NSData *)cerData withChallenge:(NSURLAuthenticationChallenge *)challenge;

@end
