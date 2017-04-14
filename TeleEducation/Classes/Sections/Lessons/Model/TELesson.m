//
//  TELesson.m
//  TeleEducation
//
//  Created by Karl on 2017/2/23.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TELesson.h"
#import "TETeacher.h"
#import "TEUser.h"

@implementation TELesson
- (instancetype)initWithDictionary:(NSDictionary *)dic userType:(TEUserType)usertype{
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
        
        _nimID = dic[@"nimid"];
        
        _status = TELessonStatusNormal;
        if (![dic[@"status"] isEqualToString:@"open"]) {
            _status = TELessonStatusCancel;
        }
        
        if (usertype == TEUserTypeStudent) {
            _teacher = [[TETeacher alloc] initWithDictionary:dic[@"teacherinfo"]];
        }else if (usertype == TEUserTypeTeacher){
            _user = [[TEUser alloc] initWithDictionary:dic[@"memberinfo"]];
        }
    }
    return self;
}
@end
