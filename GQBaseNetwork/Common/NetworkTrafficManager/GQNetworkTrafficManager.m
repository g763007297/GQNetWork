//
//  GQNetworkTrafficManager.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQNetworkTrafficManager.h"
#import "GQObjectSingleton.h"
#import "GQNetworkConsts.h"
#import "GQReachability.h"
#import "GQDebugLog.h"

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
#define GQ_SHOULD_LOG_TRAFFIC_DATA @"LOG_TRAFFIC_DATA" //是否打印log信息

@interface GQNetworkTrafficManager()
{
    BOOL        _isUsingGPRSNetwork;
    BOOL        _isAlert;
    BOOL        _shouldLog;
    double      _wifiInBytes;
    double      _wifiOutBytes;
    double      _gprsInBytes;
    double      _gprsOutBytes;
    int         _resetDayInMonth;
    int         _maxgprsMegaBytes;     // this is MB not byte
    
    NSDate      *_lastAlertTime;
    NSDate      *_lastResetDate;
    
    GQReachability *_reachability;
}

- (void)restore;
- (void)inGQrafficData;

- (double)getMegabytesFromBytes:(int)bytes;

@end

@implementation GQNetworkTrafficManager
@synthesize networkStatus = _networkStatus;

GQOBJECT_SINGLETON_BOILERPLATE(GQNetworkTrafficManager, sharedManager)

- (id)init
{
    self = [super init];
    if (self) {
        [self restore];
    }
    return self;
}

#pragma mark - private methods
- (void)inGQrafficData
{
    _maxgprsMegaBytes = [[GQ_USER_DEFAULT objectForKey:GQ_NETWORK_TRAFFIC_MAX_GPRS] intValue];
    if (!_maxgprsMegaBytes) {
        _wifiInBytes = 0;
        _wifiOutBytes = 0;
        _gprsInBytes = 0;
        _gprsOutBytes = 0;
        _resetDayInMonth = 1;
        _maxgprsMegaBytes = 999;
    }
    else {
        _wifiInBytes = [[GQ_USER_DEFAULT objectForKey:GQ_NETWORK_TRAFFIC_WIFI_IN] doubleValue];
        _wifiOutBytes = [[GQ_USER_DEFAULT objectForKey:GQ_NETWORK_TRAFFIC_WIFI_OUT] doubleValue];
        _gprsInBytes = [[GQ_USER_DEFAULT objectForKey:GQ_NETWORK_TRAFFIC_GPRS_IN] doubleValue];
        _gprsOutBytes = [[GQ_USER_DEFAULT objectForKey:GQ_NETWORK_TRAFFIC_GPRS_OUT] doubleValue];
        _resetDayInMonth = [[GQ_USER_DEFAULT objectForKey:GQ_NETWORK_TRAFFIC_RESET_DAY_IN_MONTH] intValue];
        _maxgprsMegaBytes = [[GQ_USER_DEFAULT objectForKey:GQ_NETWORK_TRAFFIC_MAX_GPRS] intValue];
    }
    _lastResetDate =(NSDate*)[GQ_USER_DEFAULT objectForKey:GQ_NETWORK_TRAFFIC_LAST_RESET_DATE];
    _isAlert = [GQ_USER_DEFAULT boolForKey:GQ_NETWORK_TRAFFIC_IS_ALERT];
    _shouldLog = [GQ_USER_DEFAULT boolForKey:GQ_SHOULD_LOG_TRAFFIC_DATA];
    [self checkIsResetDay];
}

- (void) networkStateDidChanged:(NSNotification*)n
{
    [GQDebugLog infoMessage:@"networkStateDidChanged"];
    GQReachability* curReach = [n object];
    NSParameterAssert([curReach isKindOfClass: [GQReachability class]]);
    [self updateNetwordStatus:curReach.currentReachabilityStatus];
}

- (void) updateNetwordStatus:(GQNetworkStatus)status
{
    _networkStatus = status;
    _isUsingGPRSNetwork = FALSE;
    switch (status)
    {
        case GQReachableViaWiFi:
            break;
        case GQReachableViaWWAN:
            _isUsingGPRSNetwork = TRUE;
            break;
        case GQNotReachable:
            break;
        default:
            break;
    }
    [self debugNetworkStatus];
}

- (void)debugNetworkStatus {
    NSString *networkType = @"unknown";
    switch (_networkStatus)
    {
        case GQReachableViaWiFi:
            networkType = @"wifi";
            break;
        case GQReachableViaWWAN:
            networkType = @"gprs";
            _isUsingGPRSNetwork = TRUE;
            break;
        case GQNotReachable:
            networkType = @"unavailable";
            break;
        default:
            break;
    }
    [GQDebugLog infoMessage:[NSString stringWithFormat:@"network status %@", networkType]];
}

- (void)restore
{
    _networkStatus = GQReachableViaWiFi;
    _lastAlertTime = nil;
    [self inGQrafficData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateDidChanged:) name:kGQReachabilityChangedNotification object:nil];
    _reachability = [GQReachability reachabilityForInternetConnection];
    [self updateNetwordStatus:_reachability.currentReachabilityStatus];
    [_reachability startNotifier];
}

-(void)checkIsResetDay
{
    //得到当前的日期
    
    NSDate *date = [NSDate date];
    NSDate *nextResetDate =(NSDate*)[[NSUserDefaults standardUserDefaults] objectForKey:GQ_NETWORK_TRAFFIC_NEXT_RESET_DATE];
    if (!nextResetDate||[nextResetDate timeIntervalSinceNow] < 0) {
        [self resetData];
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitDay fromDate:date];
    NSInteger day = [comps day];
    
    NSInteger nextResetMoth = comps.month;
    NSInteger nextResetYear = comps.year;
    NSInteger nextResetDay = _resetDayInMonth;
    
    if (day>_resetDayInMonth) {
        nextResetMoth +=1;
        if (nextResetMoth>12) {
            nextResetMoth-=12;
            nextResetYear+=1;
        }
    }
    [comps setDay:nextResetDay];
    [comps setMonth:nextResetMoth];
    [comps setYear:nextResetYear];
    
    nextResetDate = [calendar dateFromComponents:comps];
    [GQ_USER_DEFAULT setObject:nextResetDate forKey:GQ_NETWORK_TRAFFIC_NEXT_RESET_DATE];
    [GQ_USER_DEFAULT synchronize];
}

- (double)getMegabytesFromBytes:(int)bytes
{
    return (bytes * 1.0/1000)/1000;
}

#pragma mark - public methods
- (void)doSave
{
    [GQ_USER_DEFAULT setObject:@(_wifiInBytes) forKey:GQ_NETWORK_TRAFFIC_WIFI_IN];
    [GQ_USER_DEFAULT setObject:@(_wifiOutBytes) forKey:GQ_NETWORK_TRAFFIC_WIFI_OUT];
    [GQ_USER_DEFAULT setObject:@(_gprsInBytes) forKey:GQ_NETWORK_TRAFFIC_GPRS_IN];
    [GQ_USER_DEFAULT setObject:@(_gprsOutBytes) forKey:GQ_NETWORK_TRAFFIC_GPRS_OUT];
    [GQ_USER_DEFAULT setObject:@(_resetDayInMonth) forKey:GQ_NETWORK_TRAFFIC_RESET_DAY_IN_MONTH];
    [GQ_USER_DEFAULT setObject:@(_maxgprsMegaBytes) forKey:GQ_NETWORK_TRAFFIC_MAX_GPRS];
    [GQ_USER_DEFAULT synchronize];
}

// log traffic
- (void)logTrafficIn:(unsigned long long)bytes
{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    switch (_networkStatus) {
        case GQReachableViaWWAN:
            _gprsInBytes = _gprsInBytes + bytes;
            [userinfo setObject:@(_gprsInBytes) forKey:GQ_NETWORK_TRAFFIC_GPRS_IN];
            [userinfo synchronize];
            if (_shouldLog) {
                [GQDebugLog infoMessage:[NSString stringWithFormat:@"gprs trafic in :%lf bytes", _gprsInBytes]];
            }
            break;
        case GQReachableViaWiFi:
            _wifiInBytes = _wifiInBytes + bytes;
            [userinfo setObject:@(_wifiInBytes) forKey:GQ_NETWORK_TRAFFIC_WIFI_IN];
            [userinfo synchronize];
            if (_shouldLog) {
                [GQDebugLog infoMessage:[NSString stringWithFormat:@"wifi trafic in :%lf bytes", _wifiInBytes]];
            }
            break;
        default:
            break;
    }
    if ([self hasExceedMaxGPRSTraffic]&&_isAlert) {
        NSDate *now = [NSDate date];
        BOOL shouldShowAlert = NO;
        if (!_lastAlertTime || [now timeIntervalSinceDate:_lastAlertTime]/100 > GQ_NETWORK_TRAFFIC_MAX_GPRS_ALERT_INTERVAL) {
            shouldShowAlert = YES;
        }
        if (shouldShowAlert) {
            NSString *alertMsg = [NSString stringWithFormat:@"您目前的GPRS流量(%4.2fM)已超过您所设定的上限(%dM)",[self getGPRSTraffic],[self getMaxGPRSTraffic]];
            
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"流量提示" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
//                
//            }]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"流量提示"
                                                            message:alertMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil];
            [alert show];
            _lastAlertTime = now;
        }
    }
}

- (void)logTrafficOut:(unsigned long long)bytes
{
    switch (_networkStatus) {
        case GQReachableViaWWAN:
            _gprsOutBytes = _gprsOutBytes + bytes;
            [GQ_USER_DEFAULT setObject:@(_gprsOutBytes) forKey:GQ_NETWORK_TRAFFIC_GPRS_OUT];
            [GQ_USER_DEFAULT synchronize];
            if (_shouldLog) {
                [GQDebugLog infoMessage:[NSString stringWithFormat:@"gprs trafic in :%lf bytes", _gprsInBytes]];
            }
            break;
        case GQReachableViaWiFi:
            _wifiOutBytes = _wifiOutBytes + bytes;
            [GQ_USER_DEFAULT setObject:@(_wifiOutBytes) forKey:GQ_NETWORK_TRAFFIC_WIFI_OUT];
            [GQ_USER_DEFAULT synchronize];
            if (_shouldLog) {
                [GQDebugLog infoMessage:[NSString stringWithFormat:@"wifi trafic in :%lf bytes", _wifiInBytes]];
            }
            break;
        default:
            break;
    }
}

// set /get reset data date
- (void)setTrafficResetDay:(int)dayInMonth
{
    _resetDayInMonth = dayInMonth;
    [GQ_USER_DEFAULT setObject:@(_resetDayInMonth) forKey:GQ_NETWORK_TRAFFIC_RESET_DAY_IN_MONTH];
    [GQ_USER_DEFAULT synchronize];
}

- (int)getTrafficResetDay
{
    return _resetDayInMonth;
}

// alert user
- (void)setMaxGPRSTraffic:(int)megabyte
{
    _maxgprsMegaBytes = megabyte;
    [GQ_USER_DEFAULT setObject:@(_maxgprsMegaBytes) forKey:GQ_NETWORK_TRAFFIC_MAX_GPRS];
    [GQ_USER_DEFAULT synchronize];
}

- (int)getMaxGPRSTraffic
{
    return _maxgprsMegaBytes;
}

- (BOOL)hasExceedMaxGPRSTraffic
{
    if (_maxgprsMegaBytes <= 0 || !_isAlert) {
        return NO;
    }
    else{
        return ([self getGPRSTraffic] > _maxgprsMegaBytes) ;
    }
}

-(void)setAlertStatus:(BOOL)isAlert
{
    [GQ_USER_DEFAULT setBool:isAlert forKey:GQ_NETWORK_TRAFFIC_IS_ALERT];
    [GQ_USER_DEFAULT synchronize];
    _isAlert = isAlert;
}

-(BOOL)getAlertStatus
{
    return _isAlert;
}

- (void)setLogTrafficDataStatus:(BOOL)log
{
    [GQ_USER_DEFAULT setBool:log forKey:GQ_SHOULD_LOG_TRAFFIC_DATA];
    [GQ_USER_DEFAULT synchronize];
    _shouldLog = log;
}

- (BOOL)getLogTrafficDataStatus
{
    return _shouldLog;
}

// reset
- (void)resetData
{
    _wifiInBytes = 0;
    _wifiOutBytes = 0;
    _gprsOutBytes = 0;
    _gprsInBytes = 0;
    [GQ_USER_DEFAULT setObject:[NSDate date] forKey:GQ_NETWORK_TRAFFIC_LAST_RESET_DATE];
    [self doSave];
}

// get traffic data, return megabytes
- (double)getGPRSTrafficIn
{
    return [self getMegabytesFromBytes:_gprsInBytes];
}

- (double)getGPRSTrafficOut
{
    return [self getMegabytesFromBytes:_gprsOutBytes];
}

- (double)getGPRSTraffic
{
    return [self getMegabytesFromBytes:(_gprsInBytes + _gprsOutBytes)];
}

- (double)getWifiTrafficIn
{
    return [self getMegabytesFromBytes:_wifiInBytes];
}

- (double)getWifiTrafficOut
{
    return [self getMegabytesFromBytes:_wifiOutBytes];
}

- (double)getWifiTraffic
{
    return [self getMegabytesFromBytes:(_wifiInBytes + _wifiOutBytes)];
}

// for debug
- (void)consoleDeviceNetworkTrafficInfo
{
    [GQDebugLog infoMessage:@"==============current network traffic=============\n"];
    [GQDebugLog infoMessage:[NSString stringWithFormat:@"gprs in:%fmb", [self getGPRSTrafficIn]]];
    [GQDebugLog infoMessage:[NSString stringWithFormat:@"gprs out:%fmb", [self getGPRSTrafficOut]]];
    [GQDebugLog infoMessage:[NSString stringWithFormat:@"gprs total:%fmb", [self getGPRSTraffic]]];
    [GQDebugLog infoMessage:[NSString stringWithFormat:@"wifi in:%fmb", [self getWifiTrafficIn]]];
    [GQDebugLog infoMessage:[NSString stringWithFormat:@"wifi out:%fmb", [self getWifiTrafficOut]]];
    [GQDebugLog infoMessage:[NSString stringWithFormat:@"wifi total:%fmb", [self getWifiTraffic]]];
    [GQDebugLog infoMessage:@"==================================================\n"];
}

- (GQNetworkStatus)networkStatus {
    return _networkStatus;
}

- (BOOL)isReachability
{
    return _networkStatus != GQNotReachable;
}

- (BOOL)isUseGPRSNetwork
{
    return _networkStatus == GQReachableViaWWAN;
}

- (BOOL)isUseWIFINetwork
{
    return _networkStatus == GQReachableViaWiFi;
}

@end
