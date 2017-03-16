//
//  TEUser.m
//  TeleEducation
//
//  Created by Karl on 2017/2/23.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEUser.h"
#import "TENetworkConfig.h"

@implementation TEUser
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _userID = [dic[@"id"] integerValue];
        _name = dic[@"name"];
        _avatar = [[[TENetworkConfig sharedConfig] baseURL] stringByAppendingString:dic[@"imageurl"]];
    }
    return self;
}
@end
