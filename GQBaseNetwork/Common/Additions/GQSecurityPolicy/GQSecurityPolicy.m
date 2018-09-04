//
//  GQSecurityPolicy.m
//  GQNetWorkDemo
//
//  Created by tusm on 16/6/24.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQSecurityPolicy.h"
#import <AssertMacros.h>

static BOOL GQServerTrustIsValid(SecTrustRef serverTrust) {
    BOOL isValid = NO;
    SecTrustResultType result;
    __Require_noErr_Quiet(SecTrustEvaluate(serverTrust, &result), _out);
    
    isValid = (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
    
_out:
    return isValid;
}

@implementation GQSecurityPolicy

+ (NSArray *)defaultPinnedCertificates {
    static NSArray *_defaultPinnedCertificates = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSArray *paths = [bundle pathsForResourcesOfType:@"cer" inDirectory:@"."];
        
        NSMutableArray *certificates = [NSMutableArray arrayWithCapacity:[paths count]];
        for (NSString *path in paths) {
            NSData *certificateData = [NSData dataWithContentsOfFile:path];
            [certificates addObject:certificateData];
        }
        _defaultPinnedCertificates = [[NSArray alloc] initWithArray:certificates];
    });
    return _defaultPinnedCertificates;
}

- (instancetype)initWithURLCredential:(NSURLCredential *)credential;
{
    if (!credential) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.credential = credential;
    }
    return self;
}

+ (GQSecurityPolicy *)defaultServerTrust:(NSURLAuthenticationChallenge *)challenge
{
    return [self defaultSecurityPolicy:nil withChallenge:challenge];
}

+ (GQSecurityPolicy *)defaultSecurityPolicy:(NSData *)cerData withChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSURLCredential *credential;
    if (cerData) {
        SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(cerData));
        NSArray *trustedCertificates = @[CFBridgingRelease(certificate)];
        
        SecTrustRef trust = challenge.protectionSpace.serverTrust;
        SecTrustResultType result;
        SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef)trustedCertificates);
        //设置证书信任
        SecTrustSetAnchorCertificatesOnly(trust,YES);
        OSStatus status = SecTrustEvaluate(trust, &result);
        if (status == errSecSuccess &&
            (result == kSecTrustResultProceed ||
             result == kSecTrustResultUnspecified||
             result == kSecTrustResultRecoverableTrustFailure))
        {
            credential = [NSURLCredential credentialForTrust:trust];
        }
    }else {
        SecTrustRef trust = challenge.protectionSpace.serverTrust;
        NSMutableArray *policies = [NSMutableArray array];
        if (!GQServerTrustIsValid(trust)) {
            [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)challenge.protectionSpace.host)];
            SecTrustSetPolicies(trust, (__bridge CFArrayRef)policies);
            credential = [NSURLCredential credentialForTrust:trust];
        }
        if (!GQServerTrustIsValid(trust)) {
            return nil;
        }
    }
    return [[[self class] alloc] initWithURLCredential:credential];
}

@end
