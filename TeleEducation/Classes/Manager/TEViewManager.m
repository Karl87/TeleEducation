//
//  TEViewManager.m
//  TeleEducation
//
//  Created by Karl on 2017/3/2.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEViewManager.h"
#import "TENavigationViewController.h"
#import "TELoginViewController.h"
#import "TEMainTabBarViewController.h"
#import "TEClassListViewController.h"
#import "TESettingViewController.h"
#import "TEMessagesViewController.h"

@implementation TEViewManager

+ (instancetype)sharedManager{
    static TEViewManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TEViewManager alloc] init];
    });
    return manager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[TELoginManager sharedManager] addDelegate:self];
    }
    return self;
}

- (void)dealloc{
    [[TELoginManager sharedManager] removeDelegate:self];
}

- (void)setupLoginViewController{
    TENavigationViewController *navi = [[TENavigationViewController alloc] initWithRootViewController:[[TELoginViewController alloc] initWithTitle:@"" statusStyle:UIStatusBarStyleDefault showNaviBar:NO naviType:TENaviTypeImage naviColor:[UIColor whiteColor] naviBlur:NO orientationMask:UIInterfaceOrientationMaskPortrait]];
    [UIApplication sharedApplication].keyWindow.rootViewController = navi;
    
    
}

- (void)setupMainTabbarController{
        TEMainTabBarViewController *mainTab = [[TEMainTabBarViewController alloc] init];
        TENavigationViewController *classList = [[TENavigationViewController alloc] initWithRootViewController:[[TEClassListViewController alloc] initWithTitle:@"课程" statusStyle:UIStatusBarStyleLightContent showNaviBar:YES naviType:TENaviTypeImage naviColor:SystemBlueColor naviBlur:YES orientationMask:UIInterfaceOrientationMaskAll]];
        TENavigationViewController *userCenter = [[TENavigationViewController alloc] initWithRootViewController:[[TESettingViewController alloc] initWithTitle:@"我" statusStyle:UIStatusBarStyleLightContent showNaviBar:YES naviType:TENaviTypeImage naviColor:SystemBlueColor naviBlur:YES orientationMask:UIInterfaceOrientationMaskPortrait]];
    
        TENavigationViewController *messages =[[TENavigationViewController alloc] initWithRootViewController:[[TEMessagesViewController alloc] initWithTitle:@"消息" statusStyle:UIStatusBarStyleLightContent showNaviBar:YES naviType:TENaviTypeImage naviColor:SystemBlueColor naviBlur:YES orientationMask:UIInterfaceOrientationMaskPortrait]];
        mainTab.viewControllers = @[classList,messages,userCenter];
        [mainTab.tabBar setTintColor:SystemBlueColor];
        NSArray *titles = @[@"课程",@"消息",@"我"];
        NSArray *images = @[@"tabbarLesson",@"tabbarMessage",@"tabbarSetting"];
        for (int i = 0; i<mainTab.viewControllers.count; i++) {
            UITabBarItem *item = [mainTab.tabBar.items objectAtIndex:i];
            item.title = titles[i];
            [item setImage:[[UIImage imageNamed:images[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    //        [item setSelectedImage:[UIImage imageNamed:images[i]]];
        }
        [UIApplication sharedApplication].keyWindow.rootViewController = mainTab;
}

- (void)loginSuccessed{
    [self setupMainTabbarController];
}
- (void)logout{
    [self setupLoginViewController];
}
- (void)loginFailed{
    
}
@end
