
//
//  TECommonViewController.h
//  TeleEducation
//
//  Created by Karl on 2017/2/28.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+TEColor.h"
#import "UIView+TE.h"

typedef NS_ENUM(NSInteger,TENaviType) {
    TENaviTypeColor,
    TENaviTypeImage
};

@interface TECommonViewController : UIViewController
- (instancetype)initWithTitle:(NSString *)title statusStyle:(UIStatusBarStyle)statusStyle showNaviBar:(BOOL)show naviType:(TENaviType)naviType naviColor:(UIColor*)naviColor naviBlur:(BOOL)blur orientationMask:(UIInterfaceOrientationMask)mask;
- (void)configNav;
@end
