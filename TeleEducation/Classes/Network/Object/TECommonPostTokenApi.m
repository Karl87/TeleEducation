//
//  TECommonPostTokenApi.m
//  TeleEducation
//
//  Created by Karl on 2017/3/3.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TECommonPostTokenApi.h"

#define GETReservedLessonsURL @"/App/Course/GetReservedLessons.html"
#define GETCoursesURL @"/App/Course/GetCourses.html"
#define GETTeacheresURL @"/App/Course/GetTeacheres.html"
#define GETPeriodsURL @"/App/Course/GetPeriods.html"
#define OrderLessonURL @"/App/Course/OrderLesson.html"
#define GetLessonsBeReservedURL @"/App/Course/GetLessonsBeReserved.html"
#define SetLessonNIMIDURL @"/App/Course/SetLessonNIMID.html"

@implementation TECommonPostTokenApi{
    NSString *_token;
    TETokenApiType _type;
    NSInteger _unit;
    NSInteger _course;
    NSInteger _teacher;
    NSInteger _periodID;
    NSString *_date;
    NSString *_period;
    NSTimeInterval _timeStamp;
    
    TEUserType _userType;
    NSInteger _lessonID;
    NSString *_nimID;
}

- (id)initWithToken:(NSString *)token type:(TETokenApiType)type userType:(TEUserType)userType lessonID:(NSInteger)lessonID nimID:(NSString *)nimID{
    self = [super init];
    if (self) {
        _token = token;
        _type = type;
        _userType = userType;
        _lessonID = lessonID;
        _nimID = nimID;
    }
    return self;
}

- (id)initWithToken:(NSString *)token type:(TETokenApiType)type{
    
    self = [super init];
    if (self) {
        _token = token;
        _type = type;
    }
    return  self;
}

- (id)initWithToken:(NSString *)token type:(TETokenApiType)type unit:(NSInteger)unit course:(NSInteger)course{
    
    self = [super init];
    if (self) {
        _token = token;
        _type = type;
        _unit = unit;
        _course = course;
    }
    return  self;
}

- (id)initWithToken:(NSString *)token type:(TETokenApiType)type teacher:(NSInteger)teacher{
    self = [super init];
    if (self) {
        _token = token;
        _type = type;
        _teacher = teacher;
    }
    return  self;
}

- (id)initWithToken:(NSString *)token type:(TETokenApiType)type unit:(NSInteger)unit course:(NSInteger)course pid:(NSInteger)pid teacher:(NSInteger)teacher date:(NSString *)date period:(NSString *)period timeStamp:(NSTimeInterval)stamp{
    self = [super init];
    if (self) {
        _token = token;
        _type = type;
        _unit = unit;
        _course = course;
        _periodID = pid;
        _teacher = teacher;
        _date = date;
        _period = period;
        _timeStamp = stamp;
    }
    return self;
}

- (NSString *)requestUrl{
    
    switch (_type) {
        case TETokenApiTypeGetReservedLessons:
            return GETReservedLessonsURL;
        case TETokenApiTypeGetCourses:
            return GETCoursesURL;
        case TETokenApiTypeGetTeacheres:
            return GETTeacheresURL;
        case TETokenApiTypeGetPeriods:
            return GETPeriodsURL;
        case TETokenApiTypeOrderLesson:
            return OrderLessonURL;
        case TETokenApiTypeGetLessonsBeReserved:
            return GetLessonsBeReservedURL;
        case TETokenApiTypeSetNIMID:
            return SetLessonNIMIDURL;
    }
    return nil;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (id)requestArgument{
    
    
    switch (_type) {
        case TETokenApiTypeGetTeacheres:
             return @{
                            @"token":_token,
                            @"unitid":@(_unit),
                            @"lessonid":@(_course)
                            };
        case TETokenApiTypeGetPeriods:
            return @{
                     @"token":_token,
                     @"teacherid":@(_teacher)
                     };
        case TETokenApiTypeOrderLesson:
            return @{
                     @"token":_token,
                     @"teacherid":@(_teacher),
                     @"date":_date,
                     @"period":_period,
                     @"periodtime":@(_timeStamp),
                     @"unitid":@(_unit),
                     @"lessonid":@(_course),
                     @"id":@(_periodID)
                     };
        case TETokenApiTypeSetNIMID:
            return @{
                     @"token":_token,
                     @"type":@(_userType),
                     @"id":@(_lessonID),
                     @"nimid":_nimID
                     };
        default:
            return @{
                     @"token":_token
                     };
    }
}


@end
