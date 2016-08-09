//
//  GQNetworkTrafficManager.m
//  GQNetWorkDemo
//
//  Created by 高旗 on 16/5/27.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQNetworkTrafficManager.h"
#import "GQObjectSingleton.h"
#import "GQReachability.h"
#import "GQDebug.h"

#define SHOULD_LOG_TRAFFIC_DATA YES

@interface GQNetworkTrafficManager()
{
    BOOL        _isUsingGPRSNetwork;
    BOOL        _isAlert;
    double      _wifiInBytes;
    double      _wifiOutBytes;
    double      _gprsInBytes;
    double      _gprsOutBytes;
    int         _resetDayInMonth;
    int         _maxgprsMegaBytes;     // this is MB not byte
    
    GQNetworkStatus _networkStatus;
    
    NSDate      *_lastAlertTime;
    NSDate      *_lastResetDate;
    
    GQReachability *_reachability;
}

- (void)restore;
- (void)inGQrafficData;

- (double)getMegabytesFromBytes:(int)bytes;

@end

@implementation GQNetworkTrafficManager
@synthesize networkType = _networkType;

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
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    _maxgprsMegaBytes = [[userinfo objectForKey:GQ_NETWORK_TRAFFIC_MAX_GPRS] intValue];
    if (!_maxgprsMegaBytes) {
        _wifiInBytes = 0;
        _wifiOutBytes = 0;
        _gprsInBytes = 0;
        _gprsOutBytes = 0;
        _resetDayInMonth = 1;
        _maxgprsMegaBytes = 999;
    }
    else {
        _wifiInBytes = [[userinfo objectForKey:GQ_NETWORK_TRAFFIC_WIFI_IN] doubleValue];
        _wifiOutBytes = [[userinfo objectForKey:GQ_NETWORK_TRAFFIC_WIFI_OUT] doubleValue];
        _gprsInBytes = [[userinfo objectForKey:GQ_NETWORK_TRAFFIC_GPRS_IN] doubleValue];
        _gprsOutBytes = [[userinfo objectForKey:GQ_NETWORK_TRAFFIC_GPRS_OUT] doubleValue];
        _resetDayInMonth = [[userinfo objectForKey:GQ_NETWORK_TRAFFIC_RESET_DAY_IN_MONTH] intValue];
        _maxgprsMegaBytes = [[userinfo objectForKey:GQ_NETWORK_TRAFFIC_MAX_GPRS] intValue];
    }
    _lastResetDate =(NSDate*)[userinfo objectForKey:GQ_NETWORK_TRAFFIC_LAST_RESET_DATE];
    _isAlert = [userinfo boolForKey:GQ_NETWORK_TRAFFIC_IS_ALERT];
    [self checkIsResetDay];
}

- (void) networkStateDidChanged:(NSNotification*)n
{
    GQDINFO(@"networkStateDidChanged");
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
            _networkType = @"wifi";
            break;
        case GQReachableViaWWAN:
            _networkType = @"gprs";
            _isUsingGPRSNetwork = TRUE;
            break;
        case GQNotReachable:
            _networkType = @"unavailable";
            break;
        default:
            _networkType = @"unknown";
            break;
    }
    GQDINFO(@"network status %@", _networkType);
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

- (NSString *)networkType{
    return _networkType;
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
    [[NSUserDefaults standardUserDefaults] setObject:nextResetDate forKey:GQ_NETWORK_TRAFFIC_NEXT_RESET_DATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (double)getMegabytesFromBytes:(int)bytes
{
    return (bytes * 1.0/1000)/1000;
}

#pragma mark - public methods
- (void)doSave
{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    [userinfo setObject:@(_wifiInBytes) forKey:GQ_NETWORK_TRAFFIC_WIFI_IN];
    [userinfo setObject:@(_wifiOutBytes) forKey:GQ_NETWORK_TRAFFIC_WIFI_OUT];
    [userinfo setObject:@(_gprsInBytes) forKey:GQ_NETWORK_TRAFFIC_GPRS_IN];
    [userinfo setObject:@(_gprsOutBytes) forKey:GQ_NETWORK_TRAFFIC_GPRS_OUT];
    [userinfo setObject:@(_resetDayInMonth) forKey:GQ_NETWORK_TRAFFIC_RESET_DAY_IN_MONTH];
    [userinfo setObject:@(_maxgprsMegaBytes) forKey:GQ_NETWORK_TRAFFIC_MAX_GPRS];
    [userinfo synchronize];
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
            if (SHOULD_LOG_TRAFFIC_DATA) {
                GQDINFO(@"gprs trafic in :%lf bytes", _gprsInBytes);
            }
            break;
        case GQReachableViaWiFi:
            _wifiInBytes = _wifiInBytes + bytes;
            [userinfo setObject:@(_wifiInBytes) forKey:GQ_NETWORK_TRAFFIC_WIFI_IN];
            [userinfo synchronize];
            if (SHOULD_LOG_TRAFFIC_DATA) {
                GQDINFO(@"wifi trafic in :%lf bytes", _wifiInBytes);
            }
            break;
        default:
            break;
    }
    if ([self hasExceedMaxGPRSTraffic]) {
        NSDate *now = [NSDate date];
        BOOL shouldShowAlert = NO;
        if (!_lastAlertTime || [now timeIntervalSinceDate:_lastAlertTime]/100 > GQ_NETWORK_TRAFFIC_MAX_GPRS_ALERT_INTERVAL) {
            shouldShowAlert = YES;
        }
        if (shouldShowAlert) {
            NSString *alertMsg = [NSString stringWithFormat:@"您目前的GPRS流量(%4.2fM)已超过您所设定的上限(%dM)",[self getGPRSTraffic],[self getMaxGPRSTraffic] ];
            
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
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    switch (_networkStatus) {
        case GQReachableViaWWAN:
            _gprsOutBytes = _gprsOutBytes + bytes;
            [userinfo setObject:@(_gprsOutBytes) forKey:GQ_NETWORK_TRAFFIC_GPRS_OUT];
            [userinfo synchronize];
            if (SHOULD_LOG_TRAFFIC_DATA) {
                GQDINFO(@"gprs trafic in :%lf bytes", _gprsInBytes);
            }
            break;
        case GQReachableViaWiFi:
            _wifiOutBytes = _wifiOutBytes + bytes;
            [userinfo setObject:@(_wifiOutBytes) forKey:GQ_NETWORK_TRAFFIC_WIFI_OUT];
            [userinfo synchronize];
            if (SHOULD_LOG_TRAFFIC_DATA) {
                GQDINFO(@"wifi trafic in :%lf bytes", _wifiInBytes);
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
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    [userinfo setObject:@(_resetDayInMonth) forKey:GQ_NETWORK_TRAFFIC_RESET_DAY_IN_MONTH];
    [userinfo synchronize];
}

- (int)getTrafficResetDay
{
    return _resetDayInMonth;
}

// alert user
- (void)setMaxGPRSTraffic:(int)megabyte
{
    _maxgprsMegaBytes = megabyte;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    [userinfo setObject:@(_maxgprsMegaBytes) forKey:GQ_NETWORK_TRAFFIC_MAX_GPRS];
    [userinfo synchronize];
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
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    [userinfo setObject: [NSNumber numberWithInt:isAlert] forKey:GQ_NETWORK_TRAFFIC_IS_ALERT];
    [userinfo synchronize];
    _isAlert = isAlert;
}

-(BOOL)getAlertStatus
{
    return _isAlert;
}

// reset
- (void)resetData
{
    _wifiInBytes = 0;
    _wifiOutBytes = 0;
    _gprsOutBytes = 0;
    _gprsInBytes = 0;
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:GQ_NETWORK_TRAFFIC_LAST_RESET_DATE];
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
    GQDINFO(@"==============current network traffic=============\n");
    GQDINFO(@"gprs in:%fmb", [self getGPRSTrafficIn]);
    GQDINFO(@"gprs out:%fmb", [self getGPRSTrafficOut]);
    GQDINFO(@"gprs total:%fmb", [self getGPRSTraffic]);
    GQDINFO(@"wifi in:%fmb", [self getWifiTrafficIn]);
    GQDINFO(@"wifi out:%fmb", [self getWifiTrafficOut]);
    GQDINFO(@"wifi total:%fmb", [self getWifiTraffic]);
    GQDINFO(@"==================================================\n");
}

- (BOOL)isReachability{
    return _networkStatus != GQNotReachable;
}

- (BOOL)isUseGPRSNetwork{
    return _networkStatus == GQReachableViaWWAN;
}

@end
