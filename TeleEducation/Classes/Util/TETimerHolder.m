//
//  TETimerHolder.m
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TETimerHolder.h"

@interface TETimerHolder (){
    NSTimer *_timer;
    BOOL _repeats;
}
- (void)onTimer:(NSTimer *)timer;
@end

@implementation TETimerHolder

- (void)dealloc{
    [self stopTimer];
}
- (void)startTimer:(NSTimeInterval)seconds delegate:(id<TETimeHolderDelegate>)delegate repeats:(BOOL)repeats{
    _delegate =  delegate;
    _repeats = repeats;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(onTimer:) userInfo:nil repeats:repeats];
}


- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
    _delegate = nil;
}

- (void)onTimer:(NSTimer *)timer{
    if (!_repeats) {
        _timer = nil;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(onTETimerFired:)]) {
        [_delegate onTETimerFired:self];
    }
}
@end
