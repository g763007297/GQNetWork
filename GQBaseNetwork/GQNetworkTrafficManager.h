//
//  GQNetworkTrafficManager.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQNetworkTrafficManager : NSObject

@property (nonatomic, readonly) NSString *networkType;

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

- (BOOL)isReachability;
//
- (BOOL)isUseGPRSNetwork;

@end
