//
//  TEAppConfig.m
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEAppConfig.h"

@implementation TEAppConfig

+ (instancetype)sharedConfig{
    static TEAppConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[TEAppConfig alloc] init];
    });
    return config;
}

- (instancetype)init{
    if (self  =[super init]) {
        _NIMAppKey = @"1ee5a51b7d008254cd73b1d4369a9494";
        _NIMCerName = @"ENTERPRISE";
    }
    return self;
}

- (NSString *)NIMAppKey{
    return _NIMAppKey;
}

- (NSString *)NIMCerName{
    return _NIMCerName;
}

@end
