//
//  UIViewController+TE.m
//  TeleEducation
//
//  Created by Karl on 2017/2/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "UIViewController+TE.h"

@implementation UIViewController (TE)
- (void)useDefaultNavigationBar
{
    [self setNavigationBarBackgroundImage:nil];
}

- (void)setNavigationBarBackgroundImage:(UIImage *)image
{
    SEL sel = NSSelectorFromString(@"swizzling_changeNavigationBarBackgroundImage:");
    if ([self respondsToSelector:sel]) {
        SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:image]);
    }
}

@end
