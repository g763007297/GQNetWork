//
//  GQRequestParameter.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/31.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQDataCacheManager.h"

@class GQObjectMapping;

@interface GQRequestParameter : NSObject

@property (nonatomic, copy) NSString *subRequestUrl;

@property (nonatomic, copy) NSString *keyPath;

@property (nonatomic, strong) GQObjectMapping *mapping;

@property (nonatomic, copy) NSDictionary *parameters;

@property (nonatomic, strong) UIView *indicatorView;

@property (nonatomic, copy) NSString *loadingMessage;

@property (nonatomic, copy) NSString *cancelSubject;

@property (nonatomic, copy) NSString *cacheKey;

@property (nonatomic, assign) GQDataCacheManagerType cacheType;

@property (nonatomic, copy) NSString *localFilePath;

@end
