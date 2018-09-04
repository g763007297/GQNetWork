//
//  GQNetworkTrafficManager.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GQNetworkConsts.h"

#define kGQNetWorkChangedNotification @"kGQReachabilityChangedNotification"

@interface GQNetworkTrafficManager : NSObject

@property (nonatomic, readonly) GQNetworkStatus networkStatus;

+ (GQNetworkTrafficManager *)sharedManager;

// log traffic
- (void)logTrafficIn:(unsigned long long)bytes;
- (void)logTrafficOut:(unsigned long long)bytes;

// set /get reset data date
- (void)setTrafficResetDay:(int)dayInMonth;
- (int)getTrafficResetDay;

// alert user
- (void)setMaxGPRSTraffic:(int)megabyte;
- (int)getMaxGPRSTraffic;
- (BOOL)hasExceedMaxGPRSTraffic;

// reset
-(void)resetData;
-(void)checkIsResetDay;

//network traffic，Company for MB
- (double)getGPRSTrafficIn;
- (double)getGPRSTrafficOut;
- (double)getGPRSTraffic;

- (double)getWifiTrafficIn;
- (double)getWifiTrafficOut;
- (double)getWifiTraffic;

// for debug
- (void)consoleDeviceNetworkTrafficInfo;

-(void)setAlertStatus:(BOOL)isAlert;
-(BOOL)getAlertStatus;

- (void)setLogTrafficDataStatus:(BOOL)log;
- (BOOL)getLogTrafficDataStatus;

//是否联网
- (BOOL)isReachability;

//是否使用蜂窝网络
- (BOOL)isUseGPRSNetwork;

//是否使用wifi网络
- (BOOL)isUseWIFINetwork;

@end
