//
//  TEViewManager.h
//  TeleEducation
//
//  Created by Karl on 2017/3/2.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TELoginManager.h"

@interface TEViewManager : NSObject<TELoginManagerDelegate>

+ (instancetype)sharedManager;

- (void)setupMainTabbarController;
- (void)setupLoginViewController;

@end
