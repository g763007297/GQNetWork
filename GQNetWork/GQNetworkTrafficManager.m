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
    BOOL        _isUsing3GNetwork;
    BOOL        _isAlert;
    double      _wifiInBytes;
    double      _wifiOutBytes;
    double      _3gInBytes;
    double      _3gOutBytes;
    double      _2gInBytes;
    double      _2gOutBytes;
    int         _resetDayInMonth;
    int         _max3gMegaBytes;     // this is MB not byte
    
    GGNetworkStatus _networkStatus;
    
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
    _max3gMegaBytes = [[userinfo objectForKey:GQ_NETWORK_TRAFFIC_MAX_3G] intValue];
    if (!_max3gMegaBytes) {
        _wifiInBytes = 0;
        _wifiOutBytes = 0;
        _2gInBytes = 0;
        _2gOutBytes = 0;
        _3gInBytes = 0;
        _3gOutBytes = 0;
        _resetDayInMonth = 1;
        _max3gMegaBytes = 999;
    }
    else {
        _wifiInBytes = [[userinfo objectForKey:GQ_NETWORK_TRAFFIC_WIFI_IN] doubleValue];
        _wifiOutBytes = [[userinfo objectForKey:GQ_NETWORK_TRAFFIC_WIFI_OUT] doubleValue];
        _3gInBytes = [[userinfo objectForKey:GQ_NETWORK_TRAFFIC_GPRS_3G_IN] doubleValue];
        _3gOutBytes = [[userinfo objectForKey:GQ_NETWORK_TRAFFIC_GPRS_3G_OUT] doubleValue];
        _2gInBytes = [[userinfo objectForKey:GQ_NETWORK_TRAFFIC_GPRS_2G_IN] doubleValue];
        _2gOutBytes = [[userinfo objectForKey:GQ_NETWORK_TRAFFIC_GPRS_2G_OUT] doubleValue];
        _resetDayInMonth = [[userinfo objectForKey:GQ_NETWORK_TRAFFIC_RESET_DAY_IN_MONTH] intValue];
        _max3gMegaBytes = [[userinfo objectForKey:GQ_NETWORK_TRAFFIC_MAX_3G] intValue];
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

- (void) updateNetwordStatus:(GGNetworkStatus)status
{
    _isUsing3GNetwork = FALSE;
    switch (status)
    {
        case GGReachableViaWiFi:
            _networkType = @"wifi";
            break;
        case GGReachableVia3G:
            _networkType = @"3g";
            _isUsing3GNetwork = TRUE;
            break;
        case GGReachableVia2G:
            _networkType = @"2g";
            break;
        case GGNotReachable:
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
    _networkStatus = GGReachableViaWiFi;
    _lastAlertTime = nil;
    [self inGQrafficData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateDidChanged:) name:kReachabilityChangedNotification object:nil];
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
    [userinfo setObject:@(_3gInBytes) forKey:GQ_NETWORK_TRAFFIC_GPRS_3G_IN];
    [userinfo setObject:@(_3gOutBytes) forKey:GQ_NETWORK_TRAFFIC_GPRS_3G_OUT];
    [userinfo setObject:@(_2gInBytes) forKey:GQ_NETWORK_TRAFFIC_GPRS_2G_IN];
    [userinfo setObject:@(_2gOutBytes) forKey:GQ_NETWORK_TRAFFIC_GPRS_2G_OUT];
    [userinfo setObject:@(_resetDayInMonth) forKey:GQ_NETWORK_TRAFFIC_RESET_DAY_IN_MONTH];
    [userinfo setObject:@(_max3gMegaBytes) forKey:GQ_NETWORK_TRAFFIC_MAX_3G];
    [userinfo synchronize];
}

// log traffic
- (void)logTrafficIn:(unsigned long long)bytes
{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    switch (_networkStatus) {
        case GGReachableVia2G:
            _2gInBytes = _2gInBytes + bytes;
            [userinfo setObject:@(_2gInBytes) forKey:GQ_NETWORK_TRAFFIC_GPRS_2G_IN];
            [userinfo synchronize];
            if (SHOULD_LOG_TRAFFIC_DATA) {
                GQDINFO(@"2g trafic in :%lf bytes", _2gInBytes);
            }
            break;
        case GGReachableVia3G:
            _3gInBytes = _3gInBytes + bytes;
            [userinfo setObject:@(_3gInBytes) forKey:GQ_NETWORK_TRAFFIC_GPRS_3G_IN];
            [userinfo synchronize];
            if (SHOULD_LOG_TRAFFIC_DATA) {
                GQDINFO(@"3g trafic in :%lf bytes", _3gInBytes);
            }
            break;
        case GGReachableViaWiFi:
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
    if ([self hasExceedMax3GTraffic]) {
        NSDate *now = [NSDate date];
        BOOL shouldShowAlert = NO;
        if (!_lastAlertTime || [now timeIntervalSinceDate:_lastAlertTime]/100 > GQ_NETWORK_TRAFFIC_MAX_3G_ALERT_INTERVAL) {
            shouldShowAlert = YES;
        }
        if (shouldShowAlert) {
            NSString *alertMsg = [NSString stringWithFormat:@"您目前的GPRS/3g流量(%4.2fM)已超过您所设定的上限(%dM)",[self get3GTraffic],[self getMax3GTraffic] ];
            
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
        case GGReachableVia2G:
            _2gOutBytes = _2gOutBytes + bytes;
            [userinfo setObject:@(_2gOutBytes) forKey:GQ_NETWORK_TRAFFIC_GPRS_2G_OUT];
            [userinfo synchronize];
            if (SHOULD_LOG_TRAFFIC_DATA) {
                GQDINFO(@"2g trafic in :%lf bytes", _2gInBytes);
            }
            break;
        case GGReachableVia3G:
            _3gOutBytes = _3gOutBytes + bytes;
            [userinfo setObject:@(_3gOutBytes) forKey:GQ_NETWORK_TRAFFIC_GPRS_3G_OUT];
            [userinfo synchronize];
            if (SHOULD_LOG_TRAFFIC_DATA) {
                GQDINFO(@"3g trafic in :%lf bytes", _3gInBytes);
            }
            break;
        case GGReachableViaWiFi:
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
- (void)setMax3GTraffic:(int)megabyte
{
    _max3gMegaBytes = megabyte;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    [userinfo setObject:@(_max3gMegaBytes) forKey:GQ_NETWORK_TRAFFIC_MAX_3G];
    [userinfo synchronize];
}

- (int)getMax3GTraffic
{
    return _max3gMegaBytes;
}

- (BOOL)hasExceedMax3GTraffic
{
    if (_max3gMegaBytes <= 0 || !_isAlert) {
        return NO;
    }
    else{
        return ([self get3GTraffic] > _max3gMegaBytes) ;
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
    _2gInBytes = 0;
    _2gOutBytes = 0;
    _wifiInBytes = 0;
    _wifiOutBytes = 0;
    _3gOutBytes = 0;
    _3gInBytes = 0;
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:GQ_NETWORK_TRAFFIC_LAST_RESET_DATE];
    [self doSave];
}

// get traffic data, return megabytes
- (double)get3GTrafficIn
{
    return [self getMegabytesFromBytes:_3gInBytes];
}

- (double)get3GTrafficOut
{
    return [self getMegabytesFromBytes:_3gOutBytes];
}

- (double)get3GTraffic
{
    return [self getMegabytesFromBytes:(_3gInBytes + _3gOutBytes)];
}

// get traffic data, return megabytes
- (double)get2GTrafficIn
{
    return [self getMegabytesFromBytes:_2gInBytes];
}

- (double)get2GTrafficOut
{
    return [self getMegabytesFromBytes:_2gOutBytes];
}

- (double)get2GTraffic
{
    return [self getMegabytesFromBytes:(_2gInBytes + _2gOutBytes)];
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
    GQDINFO(@"2g in:%fmb", [self get2GTrafficIn]);
    GQDINFO(@"2g out:%fmb", [self get2GTrafficOut]);
    GQDINFO(@"2g total:%fmb", [self get2GTraffic]);
    GQDINFO(@"3g in:%fmb", [self get3GTrafficIn]);
    GQDINFO(@"3g out:%fmb", [self get3GTrafficOut]);
    GQDINFO(@"3g total:%fmb", [self get3GTraffic]);
    GQDINFO(@"wifi in:%fmb", [self getWifiTrafficIn]);
    GQDINFO(@"wifi out:%fmb", [self getWifiTrafficOut]);
    GQDINFO(@"wifi total:%fmb", [self getWifiTraffic]);
    GQDINFO(@"==================================================\n");
}

@end
