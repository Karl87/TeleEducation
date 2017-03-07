//
//  UIScrollView+TEDirection.m
//  TeleEducation
//
//  Created by Karl on 2017/2/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "UIScrollView+TEDirection.h"
#import <objc/runtime.h>

@interface UIScrollView ()
@property (assign,nonatomic) TEScrollViewDirection horizontalScrollingDirection;
@property (assign,nonatomic) TEScrollViewDirection verticalScrollingDirection;
@end

static const char horizontalScrollingDirectionKey;
static const char verticalScrollingDirectionKey;

@implementation UIScrollView (TEDirection)

- (void)startObservingDirection
{
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)stopObservingDirection
{
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![keyPath isEqualToString:@"contentOffset"]) return;
    
    CGPoint newContentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
    CGPoint oldContentOffset = [[change valueForKey:NSKeyValueChangeOldKey] CGPointValue];
    
    if (oldContentOffset.x < newContentOffset.x) {
        self.horizontalScrollingDirection = TEScrollViewDirectionRight;
    } else if (oldContentOffset.x > newContentOffset.x) {
        self.horizontalScrollingDirection = TEScrollViewDirectionLeft;
    } else {
        self.horizontalScrollingDirection = TEScrollViewDirectionNone;
    }
    
    if (oldContentOffset.y < newContentOffset.y) {
        self.verticalScrollingDirection = TEScrollViewDirectionDown;
    } else if (oldContentOffset.y > newContentOffset.y) {
        self.verticalScrollingDirection = TEScrollViewDirectionUp;
    } else {
        self.verticalScrollingDirection = TEScrollViewDirectionNone;
    }
}

#pragma mark - Properties
- (TEScrollViewDirection)horizontalScrollingDirection
{
    return [objc_getAssociatedObject(self, (void *)&horizontalScrollingDirectionKey) intValue];
}

- (void)setHorizontalScrollingDirection:(TEScrollViewDirection)horizontalScrollingDirection
{
    objc_setAssociatedObject(self, (void *)&horizontalScrollingDirectionKey, [NSNumber numberWithInt:horizontalScrollingDirection], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TEScrollViewDirection)verticalScrollingDirection
{
    return [objc_getAssociatedObject(self, (void *)&verticalScrollingDirectionKey) intValue];
}

- (void)setVerticalScrollingDirection:(TEScrollViewDirection)verticalScrollingDirection
{
    objc_setAssociatedObject(self, (void *)&verticalScrollingDirectionKey, [NSNumber numberWithInt:verticalScrollingDirection], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
