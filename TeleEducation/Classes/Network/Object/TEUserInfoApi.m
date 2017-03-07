//
//  TEUserInfoApi.m
//  TeleEducation
//
//  Created by Karl on 2017/3/6.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEUserInfoApi.h"
#define URL @"/App/Login/GetUserInfo.html"

@implementation TEUserInfoApi{
    
    NSString *_token;
    TEUserType _type;
}

- (id)initWithToken:(NSString *)token type:(TEUserType)type{
    
    self = [super init];
    if (self) {
        _token = token;
        _type = type;
    }
    return  self;
}

- (NSString *)requestUrl{
    return URL;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (id)requestArgument{
    return @{
             @"token":_token,
             @"type":@(_type)
             };
}

@end
