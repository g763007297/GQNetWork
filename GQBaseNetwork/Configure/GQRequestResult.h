//
//  GQRequestResult.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GQObjectDataSource;

@interface GQRequestResult : NSObject

- (instancetype)initWithRawResultData:(NSData *)rawResultData rawJsonString:(NSString *)rawJsonString rawResponse:(id)rawResponse;

- (NSData *)rawResultData;//请求回来的原始数据
- (NSString *)rawJsonString;//请求回来的原始字符数据
- (id)rawResponse;//原始结果

@end
