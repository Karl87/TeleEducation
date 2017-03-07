//
//  TEGoods.m
//  TeleEducation
//
//  Created by Karl on 2017/3/7.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEGoods.h"
#import "NSString+TEPrice.h"

@implementation TEGoods
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _goodsID = [dic[@"id"] integerValue];
        _title = dic[@"title"];
        _num = [dic[@"num"] integerValue];
        _price = [dic[@"price"]floatValue];
        _detail = dic[@"description"];
        _priceStr = [NSString addSeparatorForPriceString:[NSString stringWithFormat:@"%.2f",_price/100]];
        NSLog(@"%@",_priceStr);
    }
    return self;
}
@end
