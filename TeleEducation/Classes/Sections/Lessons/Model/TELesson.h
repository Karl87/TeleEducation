//
//  TELesson.h
//  TeleEducation
//
//  Created by Karl on 2017/2/23.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TELoginManager.h"

@class TETeacher;
@class TEUser;

typedef NS_ENUM(NSInteger,TELessonStatus){
    TELessonStatusNormal,
    TELessonStatusCompleted,
    TELessonStatusCancel
};


@interface TELesson : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dic userType:(TEUserType)usertype;

@property (nonatomic,copy) NSString *book;
@property (nonatomic,copy) NSString *unit;
@property (nonatomic,copy) NSString *lesson;

@property (nonatomic,assign) NSInteger lessonID;
@property (nonatomic,assign) NSInteger unitID;

@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *period;
@property (nonatomic,assign) NSInteger periodTime;

@property (nonatomic,assign) TELessonStatus status;

@property (nonatomic,strong) TETeacher *teacher;
@property (nonatomic,strong) TEUser *user;

@property (nonatomic,copy) NSString *nimID;
@end
