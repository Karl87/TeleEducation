//
//  TETeacher.m
//  TeleEducation
//
//  Created by Karl on 2017/3/3.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TETeacher.h"
#import "TENetworkConfig.h"

@implementation TETeacher
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _teacherID = [dic[@"id"] integerValue];
        _name = dic[@"name"];
        _avatar = [[[TENetworkConfig sharedConfig] baseURL] stringByAppendingString:dic[@"imageurl"]];
        _times = [dic[@"count"] integerValue];
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone{
    TETeacher *teacher = [[[self class] allocWithZone:zone] init];
    teacher.teacherID = self.teacherID;
    teacher.name = self.name;
    teacher.avatar = self.avatar;
    teacher.times = self.times;
    return teacher;
}

@end
