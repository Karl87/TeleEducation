//
//  TEPurchaseOrder.m
//  TeleEducation
//
//  Created by Karl on 2017/3/7.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEPurchaseOrder.h"

@implementation TEPurchaseOrder
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _orderID = [dic[@"id"] integerValue];
        _title = [dic[@"title"] integerValue];
        _timeStamp = [dic[@"timestamp"]floatValue];
        _status = dic[@"status"];
        
        
        
        NSLog(@"%@",_status);
    }
    return self;
}

@end
