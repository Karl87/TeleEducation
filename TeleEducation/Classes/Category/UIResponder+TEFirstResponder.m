//
//  UIResponder+TEFirstResponder.m
//  TeleEducation
//
//  Created by Karl on 2017/2/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "UIResponder+TEFirstResponder.h"
static __weak id currentFirstResponder;
static __weak id currentSecodResponder;
@implementation UIResponder (TEFirstResponder)

+ (instancetype)currentFirstResponder {
    currentFirstResponder = nil;
    currentSecodResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

+ (instancetype)currentSecondResponder{
    currentFirstResponder = nil;
    currentSecodResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentSecodResponder;
}

- (void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
    [self.nextResponder findSecondResponder:sender];
}


- (void)findSecondResponder:(id)sender{
    currentSecodResponder = self;
}


@end
