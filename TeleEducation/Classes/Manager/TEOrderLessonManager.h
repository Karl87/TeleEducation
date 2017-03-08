//
//  TEOrderLessonManager.h
//  TeleEducation
//
//  Created by Karl on 2017/3/6.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,TEOrderLessonStatus){
    TEOrderLessonStatusFailed = 0,
    TEOrderLessonStatusSuccessed = 1,
    TEOrderLessonStatusInvalid = 2,
    TEOrderLessonStatusOtherOrdered = 3,
    TEOrderLessonStatusSelfOrdered = 4,
    TEOrderLessonStatusBalanceNotEnough = 5
};

@protocol TEOrderLessonManagerDelegate <NSObject>

@optional
- (void)orderLessonCompleted:(TEOrderLessonStatus)status;
@end



@class TELesson;
@class TEPeriod;
//@class TETeacher;
//@class TEUnit;
//@class TECourse;
//@class TEPeriod;

@interface TEOrderLessonManager : NSObject

@property (nonatomic,strong) TELesson *lesson;
@property (nonatomic,strong) TEPeriod *period;

+(instancetype)sharedManager;
- (void)orderLesson;
-(void)addDelegate:(id<TEOrderLessonManagerDelegate>) delegate;
-(void)removeDelegate:(id<TEOrderLessonManagerDelegate>) delegate;
@end
