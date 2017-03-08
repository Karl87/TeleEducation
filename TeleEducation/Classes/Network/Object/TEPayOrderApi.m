//
//  TEPayOrderApi.m
//  TeleEducation
//
//  Created by Karl on 2017/3/8.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEPayOrderApi.h"
#define URL @"/App/Order/ConfirmOrder.html"

@implementation TEPayOrderApi
{
    NSString *_token;
    NSInteger _order;
    NSInteger _status;
}
- (id)initWithToken:(NSString *)token order:(NSInteger)order status:(NSInteger)status{
    self = [super init];
    if (self) {
        _token = token;
        _order = order;
        _status = status;
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
             @"id":@(_order),
             @"status":@(_status)
             };
}

@end
