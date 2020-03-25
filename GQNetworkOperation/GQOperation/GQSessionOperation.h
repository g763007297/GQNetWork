//
//  GQSessionOperation.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/10/23.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseOperation.h"

@interface GQSessionOperation : GQBaseOperation<NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSessionDataTask  *operationSessionTask;

@end
