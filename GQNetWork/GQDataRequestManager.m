//
//  GQDataRequestManager.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQDataRequestManager.h"
#import "GQObjectSingleton.h"
#import "GQBaseDataRequest.h"

@interface GQDataRequestManager()
- (void)restore;
@end

@implementation GQDataRequestManager

GQOBJECT_SINGLETON_BOILERPLATE(GQDataRequestManager, sharedManager)

- (id)init
{
    self = [super init];
    if(self){
        [self restore];
    }
    return self;
}

#pragma mark - private methods
- (void)restore
{
    _requests = [[NSMutableArray alloc] init];
}

#pragma mark - public methods
- (void)addRequest:(GQBaseDataRequest*)request
{
    [_requests addObject:request];
}

- (void)removeRequest:(GQBaseDataRequest*)request
{
    [_requests removeObject:request];
    request = nil;
}

@end
