//
//  NSString+TEPrice.m
//  TeleEducation
//
//  Created by Karl on 2017/3/7.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "NSString+TEPrice.h"

@implementation NSString (TEPrice)
+(NSString *)addSeparatorForPriceString:(NSString *)priceStr{
    NSMutableString *tempStr = priceStr.mutableCopy;
    NSRange range = [priceStr rangeOfString:@"."];
    NSInteger index = 0;
    if (range.length>0) {
        index = range.location;
    }else{
        index = priceStr.length;
    }
    while ((index-3)>0) {
        index-=3;
        [tempStr insertString:@"," atIndex:index];
    }
//    tempStr = [tempStr stringb]
    return tempStr;
}

@end
