//
//  TECommonPostTokenApi.h
//  TeleEducation
//
//  Created by Karl on 2017/3/3.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

typedef NS_ENUM(NSInteger,TETokenApiType) {
    TETokenApiTypeGetReservedLessons,
    TETokenApiTypeGetCourses,
    TETokenApiTypeGetTeacheres,
    TETokenApiTypeGetPeriods,
    TETokenApiTypeOrderLesson
};

@interface TECommonPostTokenApi : YTKRequest
- (id)initWithToken:(NSString *)token type:(TETokenApiType)type;
- (id)initWithToken:(NSString *)token type:(TETokenApiType)type unit:(NSInteger)unit course:(NSInteger)course;
- (id)initWithToken:(NSString *)token type:(TETokenApiType)type teacher:(NSInteger)teacher;
- (id)initWithToken:(NSString *)token type:(TETokenApiType)type unit:(NSInteger)unit course:(NSInteger)course pid:(NSInteger)pid teacher:(NSInteger)teacher date:(NSString*)date period:(NSString *)period timeStamp:(NSTimeInterval)stamp;
@end
