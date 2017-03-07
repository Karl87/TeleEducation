//
//  TECourseContentApi.m
//  TeleEducation
//
//  Created by Karl on 2017/3/7.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TECourseContentApi.h"
#define URL @"/App/Course/GetCourseContent.html"

@implementation TECourseContentApi{
    NSString *_token;
    NSInteger _unit;
    NSInteger _lesson;
}
- (id)initWithToken:(NSString *)token unit:(NSInteger)unit lesson:(NSInteger)lesson{
    self = [super init];
    if (self) {
        _token = token;
        _unit = unit;
        _lesson = lesson;
    }
    return  self;
}

- (NSString *)requestUrl{
    return URL;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (id)requestArgument{
    return @{
             @"token":_token,
             @"lessonid":@(_lesson),
             @"unitid":@(_unit)
             };
}

@end
