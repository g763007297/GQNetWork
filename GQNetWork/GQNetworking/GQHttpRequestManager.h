//
//  GQHttpRequestManager.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GQUrlConnectionOperation.h"

@interface GQHttpRequestManager : NSObject

@property (nonatomic,strong) NSOperationQueue *connectionQueue;

+ (GQHttpRequestManager *)sharedHttpRequestManager;

- (void)addOperation:(GQUrlConnectionOperation *)operation;

@end
