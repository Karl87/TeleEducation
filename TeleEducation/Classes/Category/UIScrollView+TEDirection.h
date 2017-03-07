//
//  UIScrollView+TEDirection.h
//  TeleEducation
//
//  Created by Karl on 2017/2/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,TEScrollViewDirection) {
    TEScrollViewDirectionNone,
    TEScrollViewDirectionRight,
    TEScrollViewDirectionLeft,
    TEScrollViewDirectionUp,
    TEScrollViewDirectionDown
};

@interface UIScrollView (TEDirection)

- (void)startObservingDirection;
- (void)stopObservingDirection;

@property (readonly, nonatomic) TEScrollViewDirection horizontalScrollingDirection;
@property (readonly, nonatomic) TEScrollViewDirection verticalScrollingDirection;

@end
