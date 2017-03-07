//
//  TEDevice.h
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,TENetworkType) {
    TENetworkTypeUnKnown,
    TENetworkTypeWifi,
    TENetworkTypeWwan,
    TENetworkType2G,
    TENetworkType3G,
    TENetworkType4G
};

@interface TEDevice : NSObject

+(TEDevice *)currentDevice;
- (CGFloat)suggestImagePixels;
- (CGFloat)compressQuality;

- (BOOL)isUsingWifi;
- (BOOL)isInBackground;
- (TENetworkType)currentNetworkType;

- (NSInteger)cpuCount;

- (BOOL)isLowDevice;
- (BOOL)isIPhone;
- (NSString *)machineName;

- (CGFloat)statusBarHeight;
@end
