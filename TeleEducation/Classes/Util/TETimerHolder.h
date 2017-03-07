//
//  TETimerHolder.h
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

//M80TimerHolder，管理某个Timer，功能为
//1.隐藏NSTimer,使得NSTimer只能retain M80TimerHolder
//2.对于非repeats的Timer,执行一次后自动释放Timer
//3.对于repeats的Timer,需要持有M80TimerHolder的对象在析构时调用[M80TimerHolder stopTimer]


#import <Foundation/Foundation.h>

@class TETimerHolder;
@protocol TETimeHolderDelegate <NSObject>

- (void)onTETimerFired:(TETimerHolder *)holder;

@end


@interface TETimerHolder : NSObject

@property (nonatomic,weak) id<TETimeHolderDelegate> delegate;

- (void)startTimer:(NSTimeInterval)seconds
          delegate:(id<TETimeHolderDelegate>)delegate
           repeats:(BOOL)repeats;

- (void)stopTimer;
@end
