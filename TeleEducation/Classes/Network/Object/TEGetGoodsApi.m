//
//  TEGetGoodsApi.m
//  TeleEducation
//
//  Created by Karl on 2017/3/7.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEGetGoodsApi.h"
#define URL @"/App/Order/GetGoods.html"

@implementation TEGetGoodsApi{
    NSString *_token;
}
- (id)initWithToken:(NSString *)token{
    self = [super init];
    if (self) {
        _token = token;
        
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
             @"token":_token
             };
}


@end
