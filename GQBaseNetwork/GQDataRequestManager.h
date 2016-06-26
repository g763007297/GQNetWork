//
//  GQDataRequestManager.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GQBaseDataRequest;

@interface GQDataRequestManager : NSObject
{
    NSMutableArray *_requests;
    NSOperationQueue *_requesQueue;
}

+ (GQDataRequestManager *)sharedManager;

- (void)addRequest:(GQBaseDataRequest*)request;
- (void)removeRequest:(GQBaseDataRequest*)request;

- (void)cancelAllOperation;

@end
