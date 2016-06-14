//
//  GQHttpRequestManager.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQHttpRequestManager.h"
#import "GQObjectSingleton.h"

@implementation GQHttpRequestManager

GQOBJECT_SINGLETON_BOILERPLATE(GQHttpRequestManager, sharedHttpRequestManager)

- (id)init
{
    self = [super init];
    if (self) {
        self.connectionQueue  = [[NSOperationQueue alloc] init];
        [self.connectionQueue setMaxConcurrentOperationCount:4];
//        [self.connectionQueue waitUntilAllOperationsAreFinished];
    }
    return self;
}

- (void)addOperation:(NSOperation *)operation{
    [self.connectionQueue addOperation:operation];
}

@end
