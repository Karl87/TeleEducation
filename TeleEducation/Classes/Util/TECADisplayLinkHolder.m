//
//  TECADisplayLinkHolder.m
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TECADisplayLinkHolder.h"

@implementation TECADisplayLinkHolder {
    CADisplayLink *_displayLink;
}

- (instancetype) init{
    if (self = [super init]) {
        _frameInterval = 1;
    }
    return self;
}

- (void)dealloc{
    [self stop];
    _delegate = nil;
}

- (void)startCADisplayLinkWithDelegate:(id<TECADisplayLinkHolderDelegate>)delegate{
    _delegate  =delegate;
    [self stop];
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)];
    [_displayLink setFrameInterval:_frameInterval];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stop{
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)onDisplayLink:(CADisplayLink *)displayLink{
    if (_delegate && [_delegate respondsToSelector:@selector(onDisplayLinkFire:duration:displayLink:)]) {
        
        [_delegate onDisplayLinkFire:self duration:displayLink.duration displayLink:displayLink];
    }
}
@end
