//
//  GQHttpRequestManager.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQHttpRequestManager : NSObject<NSURLSessionDelegate,NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSOperationQueue *connectionQueue;

@property (strong, nonatomic) NSURLSession *session;

+ (GQHttpRequestManager *)sharedHttpRequestManager;

- (void)addOperation:(NSOperation *)operation;

@end
