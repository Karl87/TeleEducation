//
//  TEDevice.m
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEDevice.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>

#define NormalImageSize (1280*960)

@interface TEDevice ()
@property (nonatomic,strong) NSDictionary *networkTypes;
@end

@implementation TEDevice

- (instancetype)init{
    if (self = [super init]) {
        [self buildDeviceInfo];
    }
    return self;
}

+(TEDevice *)currentDevice{
    static TEDevice *device = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = [[TEDevice alloc] init];
    });
    return device;
}
- (void)buildDeviceInfo
{
    _networkTypes = @{
                      CTRadioAccessTechnologyGPRS:@(TENetworkType2G),
                      CTRadioAccessTechnologyEdge:@(TENetworkType2G),
                      CTRadioAccessTechnologyWCDMA:@(TENetworkType3G),
                      CTRadioAccessTechnologyHSDPA:@(TENetworkType3G),
                      CTRadioAccessTechnologyHSUPA:@(TENetworkType3G),
                      CTRadioAccessTechnologyCDMA1x:@(TENetworkType3G),
                      CTRadioAccessTechnologyCDMAEVDORev0:@(TENetworkType3G),
                      CTRadioAccessTechnologyCDMAEVDORevA:@(TENetworkType3G),
                      CTRadioAccessTechnologyCDMAEVDORevB:@(TENetworkType3G),
                      CTRadioAccessTechnologyeHRPD:@(TENetworkType3G),
                      CTRadioAccessTechnologyLTE:@(TENetworkType4G),
                      };
}

//图片/音频推荐参数
- (CGFloat)suggestImagePixels{
    return NormalImageSize;
}

- (CGFloat)compressQuality{
    return 0.5;
}

- (BOOL)isUsingWifi{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachability currentReachabilityStatus];
    return status == ReachableViaWiFi;
}

- (BOOL)isInBackground{
    return [[UIApplication sharedApplication] applicationState] != UIApplicationStateActive;
}

- (TENetworkType)currentNetworkType{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachability currentReachabilityStatus];
    switch (status) {
        case ReachableViaWiFi:
            return TENetworkTypeWifi;
        case ReachableViaWWAN:
        {
            CTTelephonyNetworkInfo *telephoneyInfo = [[CTTelephonyNetworkInfo alloc] init];
            NSNumber *number = [_networkTypes objectForKey:telephoneyInfo.currentRadioAccessTechnology];
            return number ? (TENetworkType)[number integerValue] : TENetworkTypeWwan;
        }
        default:
            return TENetworkTypeUnKnown;
    }
}

- (NSInteger)cpuCount{
    size_t size = sizeof(int);
    int results;
    
    int mib[2] = {CTL_HW, HW_NCPU};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (BOOL)isLowDevice{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    return [[NSProcessInfo processInfo] processorCount] <= 1;
#endif
}

- (BOOL)isIPhone{
    NSString *deviceModel = [UIDevice currentDevice].model;
    if ([deviceModel isEqualToString:@"iPhone"]) {
        return YES;
    }else {
        return NO;
    }
}

- (NSString *)machineName{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (CGFloat)statusBarHeight{
    CGFloat height = [UIApplication sharedApplication].statusBarFrame.size.height;
    if (!IOS8 && ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)) {
        height = [UIApplication sharedApplication].statusBarFrame.size.width;
    }
    return height;
}
@end
