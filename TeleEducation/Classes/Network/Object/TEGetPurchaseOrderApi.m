//
//  TEGetPurchaseOrderApi.m
//  TeleEducation
//
//  Created by Karl on 2017/3/7.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEGetPurchaseOrderApi.h"
#define URL @"/App/Order/GetPurchaseOrder.html"

@implementation TEGetPurchaseOrderApi{
    NSString *_token;
    NSInteger _good;
}
- (id)initWithToken:(NSString *)token good:(NSInteger)good{
    self = [super init];
    if (self) {
        _token = token;
        _good = good;
        NSLog(@"%ld",_good);
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
             @"goodid":@(_good)
             };
}


@end
