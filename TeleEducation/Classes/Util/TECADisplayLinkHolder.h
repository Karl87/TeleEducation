//
//  TECADisplayLinkHolder.h
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//CADisplayLink是一个能让我们以和屏幕刷新率相同的频率将内容画到屏幕上的定时器。
//创建一个新的 CADisplayLink 对象，把它添加到一个runloop中，并给它提供一个 target 和selector 在屏幕刷新的时候调用。

@class TECADisplayLinkHolder;
@protocol TECADisplayLinkHolderDelegate <NSObject>

- (void)onDisplayLinkFire:(TECADisplayLinkHolder *)holder
                 duration:(NSTimeInterval)duration
              displayLink:(CADisplayLink *)displayLink;

@end

@interface TECADisplayLinkHolder : NSObject

@property (nonatomic,weak) id<TECADisplayLinkHolderDelegate> delegate;
@property (nonatomic,assign) NSInteger frameInterval;

- (void)startCADisplayLinkWithDelegate:(id<TECADisplayLinkHolderDelegate>)delegate;
- (void)stop;

@end
