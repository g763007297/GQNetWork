//
//  GQNetworkTrafficManager.h
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GQ_NETWORK_TRAFFIC_GPRS_OUT @"gprsOut"
#define GQ_NETWORK_TRAFFIC_GPRS_IN @"gprsIn"
#define GQ_NETWORK_TRAFFIC_WIFI_OUT @"wifiOut"
#define GQ_NETWORK_TRAFFIC_WIFI_IN @"wifiIn"
#define GQ_NETWORK_TRAFFIC_RESET_DAY_IN_MONTH @"resetDate"    //数据归零日
#define GQ_NETWORK_TRAFFIC_LAST_RESET_DATE @"lastResetData"// 上次数据归零时间
#define GQ_NETWORK_TRAFFIC_NEXT_RESET_DATE @"nextResetData"// 上次数据归零时间
#define GQ_NETWORK_TRAFFIC_MAX_GPRS @"maxgprsTraffic"
#define GQ_NETWORK_TRAFFIC_MAX_GPRS_ALERT_INTERVAL 10 * 60      //流量提示间隔时间
#define GQ_NETWORK_TRAFFIC_IS_ALERT @"trafficIsAlert" // 是否提醒流量

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

- (BOOL)isReachability;
//
- (BOOL)isUseGPRSNetwork;

@end
