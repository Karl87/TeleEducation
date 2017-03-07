//
//  TEOrderLessonManager.m
//  TeleEducation
//
//  Created by Karl on 2017/3/6.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEOrderLessonManager.h"
#import "TELesson.h"
#import "TEPeriod.h"
#import "TETeacher.h"
#import "TECommonPostTokenApi.h"
#import "TELoginManager.h"
@implementation TEOrderLessonManager{
    NSPointerArray* _delegates; // the array of observing delegates
}


+ (instancetype)sharedManager{
    static TEOrderLessonManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TEOrderLessonManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if (self) {
        self = [super init];
        _delegates = [NSPointerArray weakObjectsPointerArray];
        _lesson = [[TELesson alloc] init];
    }
    return self;
}

- (void)orderLesson{
    TECommonPostTokenApi *api = [[TECommonPostTokenApi alloc] initWithToken:[[TELoginManager sharedManager] currentTEUser].token
                                                                       type:TETokenApiTypeOrderLesson
                                                                       unit:_lesson.unitID
                                                                     course:_lesson.lessonID
                                                                        pid:_period.periodID
                                                                    teacher:_lesson.teacher.teacherID
                                                                       date:_period.date
                                                                     period:_period.period
                                                                  timeStamp:_period.periodTime];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseJSONObject);
        NSDictionary *dic = request.responseJSONObject;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            for (id<TEOrderLessonManagerDelegate> delegate in _delegates) {
                [delegate orderLessonCompleted:[dic[@"status"]integerValue]];
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
#pragma mark - add/remove delegate
-(void)dealloc
{
}

-(void)addDelegate:(id<TEOrderLessonManagerDelegate>) delegate
{
    __weak typeof(id<TEOrderLessonManagerDelegate>) weakDelegate = delegate;
    
    [_delegates addPointer:(__bridge void *)(weakDelegate)];
}

-(void)removeDelegate:(id<TEOrderLessonManagerDelegate>) delegate
{
    int rIndex = -1;
    
    for (int index = 0; index < [_delegates count]; index++) {
        
        id<TEOrderLessonManagerDelegate> pDelegate = [_delegates pointerAtIndex:index];
        
        if (pDelegate == nil) {
            
            rIndex = index;
            break;
            
        }
    }
    
    if (rIndex > -1) {
        [_delegates removePointerAtIndex:rIndex];
    }
    
}

@end
