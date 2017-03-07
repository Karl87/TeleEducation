//
//  TENetworkConfig.m
//  TeleEducation
//
//  Created by Karl on 2017/3/1.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TENetworkConfig.h"

@implementation TENetworkConfig

+ (instancetype)sharedConfig{
    static TENetworkConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[TENetworkConfig alloc] init];
    });
    return config;
}

- (instancetype)init{
    if (self  =[super init]) {
        _baseURL = @"http://study.mysmartedu.com.cn";
        _cdnURL = @"";
    }
    return self;
}

- (NSString *)baseURL{
    return _baseURL;
}

- (NSString *)cdnURL{
    return _cdnURL;
}
@end
