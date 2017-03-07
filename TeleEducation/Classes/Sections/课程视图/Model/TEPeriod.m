//
//  TEPeriod.m
//  TeleEducation
//
//  Created by Karl on 2017/3/3.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEPeriod.h"

@implementation TEPeriod

- (instancetype)initWithDictionary:(NSDictionary *)dic currentTime:(NSTimeInterval)time{
//    NSLog(@"%f",time);
    self = [super init];
    if (self) {
        _periodID = [dic[@"id"] integerValue];
        _userID = [dic[@"memberid"]integerValue];
        _periodTime = [dic[@"periodtime"]floatValue];
        _date = dic[@"date"];
        _period = dic[@"period"];
        _status = TEPeriodStatusAvaliable;
        
        if (time > _periodTime) {
            _status = TEPeriodStatusInAvaliable;
        }
        
        if (![dic[@"status"] isEqualToString:@"open"]) {
            _status = TEPeriodStatusLeave;
        }
        
        if (_userID!=0) {
            _status = TEPeriodStatusOrdered;
        }
    
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone{
    TEPeriod *period = [[[self class] allocWithZone:zone] init];
    period.periodID = self.periodID;
    period.userID = self.userID;
    period.periodTime = self.periodTime;
    period.date  =self.date;
    period.period = self.period;
    period.status = self.status;
    return period;
}

@end
