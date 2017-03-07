//
//  UIResponder+TEFirstResponder.h
//  TeleEducation
//
//  Created by Karl on 2017/2/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (TEFirstResponder)

+ (instancetype)currentFirstResponder;

+ (instancetype)currentSecondResponder;

@end
