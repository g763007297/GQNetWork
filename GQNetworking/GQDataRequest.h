//
//  GQDataRequest.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseDataRequest.h"
#import "GQHTTPRequest.h"
#import "GQBaseDataRequest+GQBlockCategory.h"
#import "GQBaseDataRequest+GQDelegateCategory.h"

@interface GQDataRequest : GQBaseDataRequest

@property (nonatomic, strong) GQHTTPRequest *httpRequest;

@end
