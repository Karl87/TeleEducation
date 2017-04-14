//
//  TECommonViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/2/28.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TECommonViewController.h"


#define NaviHeight 44.0f
#define StatusHeight 20.0f

@interface TECommonViewController ()
@property (nonatomic,assign) BOOL isPortrait;
@property (nonatomic,assign) BOOL showNavigationBar;
@property (nonatomic,assign) BOOL naviBlur;
@property (nonatomic,assign) TENaviType naviType;
@property (nonatomic,strong) UIColor *naviColor;
@property (nonatomic,assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic,strong) UIView *navigationBarView;
@property (nonatomic,assign) UIInterfaceOrientationMask orientationMask;
@end

@implementation TECommonViewController

#pragma mark - init
- (instancetype)initWithTitle:(NSString *)title statusStyle:(UIStatusBarStyle)statusStyle showNaviBar:(BOOL)show naviType:(TENaviType)naviType naviColor:(UIColor*)naviColor naviBlur:(BOOL)blur orientationMask:(UIInterfaceOrientationMask)mask{
    self = [super init];
    if (self) {
        if (title.length) {
            self.title = title;
        }
        _statusBarStyle = statusStyle;
        _showNavigationBar = show;
        _naviType = naviType;
        _naviColor = naviColor;
        _naviBlur = blur ? blur : NO;
        _orientationMask = mask;
        
        if (_showNavigationBar) {
            _navigationBarView = [UIView new];
            //            if (_naviBlur) {
            //                UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            //                UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            //
            //                effectView.backgroundColor =  SystemBlueColor;
            //                _navigationBarView = effectView;
            //            }else{
            [_navigationBarView setBackgroundColor:SystemBlueColor];
            //            }
            [self.view addSubview:_navigationBarView];
        }
    }
    return self;
}
#pragma mark - lifeCycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configNav];
    [self configStatusBar];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *backButtonImage = [[UIImage imageNamed:@"naviBack"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (_showNavigationBar && _navigationBarView) {
        _navigationBarView.top = 0;
        _navigationBarView.left = 0;
        _navigationBarView.width = self.view.width;
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
            _navigationBarView.height = NaviHeight + StatusHeight;
        }else{
            _navigationBarView.height = NaviHeight;
        }
    }
}
#pragma mark - Common
- (void)configNav{
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //    [self.navigationController.navigationBar setBarTintColor:_naviColor];
    
    if (_showNavigationBar && _navigationBarView) {
        [self.view bringSubviewToFront:_navigationBarView];
    }
    
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dict =@{NSForegroundColorAttributeName:color,
                          NSFontAttributeName:[UIFont systemFontOfSize:19.0]};
    // [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)configStatusBar{
    [self setNeedsStatusBarAppearanceUpdate];
    UIStatusBarStyle style = [self preferredStatusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:style
                                                animated:YES];
}

#pragma mark - Private

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return _orientationMask;
}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait|UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight;
//}
#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    
}
#pragma mark - Other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


