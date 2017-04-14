//
//  TENavigationViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/2/21.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TENavigationViewController.h"
#import "UIImage+TEColor.h"

@interface TENavigationViewController ()

@end

@implementation TENavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];
    
//    UIImage *backBtnImg = [[UIImage imageNamed:@"naviBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    self.navigationBar.backIndicatorImage = backBtnImg;
//    self.navigationBar.backIndicatorTransitionMaskImage = backBtnImg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    
    return self.topViewController;
    
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item{
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    item.backBarButtonItem = back;
    
    return YES;
    
}
@end
