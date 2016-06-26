//
//  GQQueryStringPair.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * GQQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding);
extern NSArray * GQQueryStringPairsFromDictionary(NSDictionary *dictionary);
extern NSArray * GQQueryStringPairsFromKeyAndValue(NSString *key, id value);

@interface GQQueryStringPair : NSObject

@property (strong, nonatomic) id field;
@property (strong, nonatomic) id value;

- (id)initWithField:(id)field value:(id)value;

- (NSString *)urlEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding;

@end
