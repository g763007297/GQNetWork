//
//  GQRequestResult.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQRequestResult.h"

@interface GQRequestResult()
{
    NSData *_rawResultData;
    NSString *_rawJsonString;
    id _rawResponse;
}
@end

@implementation GQRequestResult

- (instancetype)initWithRawResultData:(NSData *)rawResultData rawJsonString:(NSString *)rawJsonString rawResponse:(id)rawResponse;
{
    if (self) {
        _rawResultData = rawResultData;
        _rawJsonString = rawJsonString;
        _rawResponse = rawResponse;
    }
    return self;
}

- (NSData *)rawResultData {
    return _rawResultData;
}

- (NSString *)rawJsonString {
    return _rawJsonString;
}

- (id)rawResponse {
    return _rawResponse;
}

@end
