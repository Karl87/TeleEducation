//
//  TECourse.m
//  TeleEducation
//
//  Created by Karl on 2017/3/3.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TECourse.h"
#import "TENetworkConfig.h"

@implementation TECourse
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _title = dic[@"title"];
        _image = [[[TENetworkConfig sharedConfig] baseURL] stringByAppendingString:dic[@"image"]];
        _courseID = [dic[@"id"] integerValue];
        _status = [dic[@"status"] integerValue];
    }
    return self;
}
@end
