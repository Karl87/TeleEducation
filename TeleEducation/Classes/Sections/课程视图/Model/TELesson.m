//
//  TELesson.m
//  TeleEducation
//
//  Created by Karl on 2017/2/23.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TELesson.h"
#import "TETeacher.h"

@implementation TELesson
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _book = dic[@"book"];
        _unit = dic[@"unit"];
        _lesson = dic[@"lesson"];
        
        _lessonID = [dic[@"id"] integerValue];
        _unitID = [dic[@"unitid"] integerValue];
        
        _date = dic[@"date"];
        _period = dic[@"period"];
        _periodTime = [dic[@"periodtime"] integerValue];
        
        _status = TELessonStatusNormal;
        if (![dic[@"status"] isEqualToString:@"open"]) {
            _status = TELessonStatusCancel;
        }
        
        _teacher = [[TETeacher alloc] initWithDictionary:dic[@"teacherinfo"]];
    }
    return self;
}
@end
