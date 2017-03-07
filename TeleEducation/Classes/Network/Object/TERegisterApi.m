//
//  TERegisterApi.m
//  TeleEducation
//
//  Created by Karl on 2017/3/2.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TERegisterApi.h"

#define URL @"/App/Login/register.html"

@implementation TERegisterApi
{
    
    NSString *_username;
    NSString *_phone;
    NSString *_password;
}

- (id)initWithUsername:(NSString *)username phone:(NSString*)phone password:(NSString *)password{
    
    self = [super init];
    if (self) {
        _username = username;
        _phone = phone;
        _password = password;
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
             @"phone":_phone,
             @"name":_username,
             @"password":_password
             };
}

@end
