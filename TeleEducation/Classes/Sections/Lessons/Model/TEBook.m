//
//  TEBook.m
//  TeleEducation
//
//  Created by Karl on 2017/3/3.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEBook.h"
#import "TENetworkConfig.h"

@implementation TEBook
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _title = dic[@"title"];
        _image = [[[TENetworkConfig sharedConfig] baseURL] stringByAppendingString:dic[@"image"]];
    }
    return self;
}
@end
