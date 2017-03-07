//
//  TELoginRequest.m
//  TeleEducation
//
//  Created by Karl on 2017/3/1.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TELoginApi.h"

#define URL @"/App/Login/login.html"

@implementation TELoginApi {
    
    NSString *_username;
    NSString *_password;
    TEUserType _type;
}

- (id)initWithUsername:(NSString *)username password:(NSString *)password userType:(TEUserType)type{
    
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
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
             @"phone":_username,
             @"password":_password,
             @"type":@(_type)
             };
}
//- (id)jsonValidator{
//    return @{
//             @"code":[NSNumber class],
//             @"content":@{
//                     @"status":[NSNumber class],
//                     @"token":[NSString class],
//                     @"userInfo":@{
//                             @"name":[NSString class],
//                             @"phone":[NSString class],
//                             @"qq":[NSString class],
//                             @"skype":[NSString class],
//                             @"image_url":[NSString class],
//                             @"vipstartdateline":[NSString class],
//                             @"vipenddateline":[NSString class],
//                             @"classcount":[NSNumber class]
//                             }
//                     }
//             };
//}
@end
