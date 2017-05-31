//
//  TEUserCenterViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/2/21.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TESettingViewController.h"
#import "NIMCommonTableData.h"
#import "NIMCommonTableDelegate.h"
#import "UIView+TE.h"

#import "TENavigationViewController.h"
#import "TEUserInfoViewController.h"
#import "TEResetPasswordViewController.h"
#import "TEBuyClassViewController.h"

#import "TELoginManager.h"
#import "TENetworkConfig.h"

@interface TESettingViewController ()<TELoginManagerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) NIMCommonTableDelegate *delegator;
@end

@implementation TESettingViewController

#pragma mark -

- (void)userInfoRefreshed{
    [self refreshData];
}
#pragma mark -
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[TELoginManager sharedManager] refreshUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self buildData];
    __weak typeof(self) wself = self;
    self.delegator = [[NIMCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self.delegator;
    self.tableView.dataSource = self.delegator;
    
    [[TELoginManager sharedManager] addDelegate:self];
}
- (void)dealloc{
    [[TELoginManager sharedManager] removeDelegate:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void)buildData{
    NSArray *data = @[
                      @{
                          HeaderHeight:@(0),
                          RowContent :@[
                                  @{
                                      ForbidSelect  :@(YES),
                                      ExtraInfo     : @{@"userID":@"000001",
                                                        @"userName":[[[TELoginManager sharedManager] currentTEUser] name],
                                                        @"userAvatar":[[TENetworkConfig sharedConfig].baseURL stringByAppendingString:[[[TELoginManager sharedManager] currentTEUser] avatar]],
                                                        @"balanceCount":@([[[TELoginManager sharedManager] currentTEUser] classCount]),
                                                        @"rebookAction":@"onActionTouchRebook:",
                                                        @"recordAction":@"onActionTouchRecord:"
                                                        },
                                      CellClass     : @"TESettingPortraitCell",
                                      RowHeight     : @(120),
                                      CellAction    : @"onActionTouchPortrait:"
                                      },
                                  @{
                                      Title      :Babel(@"edit_profile"),
                                      CellAction :@"onTouchChangeUserInfo:",
                                      ShowAccessory : @(YES),
                                      RowHeight     : @(60)
                                      },
                                  @{
                                      Title        : Babel(@"class_notification"),
                                      CellClass    : @"TESettingSwitchCell",
                                      CellAction   : @"onActionNeedNotifyValueChange:",
                                      ExtraInfo    : @(YES),
                                      Disable      : @(NO),
                                      ForbidSelect : @(YES),
                                      RowHeight     : @(60)
                                      }
//                                  ,
//                                  @{
//                                      Title      :@"修改密码",
//                                      CellAction :@"onTouchResetPassword:",
//                                      ShowAccessory : @(YES),
//                                      RowHeight     : @(60)
//                                      }
                                  ],
                          FooterHeight:@(0)
                          },
                      @{
                          HeaderHeight:@(0),
                          RowContent :@[
                                  @{
                                      Title      :Babel(@"logout"),
                                      CellAction :@"onActionTouchLogout:",
                                      ShowAccessory : @(NO),
                                      RowHeight     : @(60)
                                      }
                                  ],
                          FooterHeight:@(0)

                          }];
    self.data = [NIMCommonTableSection sectionsWithData:data];
}

- (void)refreshData{
    
    if ([[TELoginManager sharedManager] currentTEUser]) {
        [self buildData];
        [self.tableView reloadData];
    }
    
}
#pragma mark - Action
- (void)onActionTouchLogout:(id)sender{
    [[TELoginManager sharedManager] logout];
}
- (void)onActionTouchPortrait:(id)sender{
    
}
- (void)onActionTouchRebook:(id)sender{
    TENavigationViewController *navi = [[TENavigationViewController alloc] initWithRootViewController:[[TEBuyClassViewController alloc] initWithTitle:@"购买课程" statusStyle:UIStatusBarStyleLightContent showNaviBar:YES naviType:TENaviTypeImage naviColor:SystemBlueColor naviBlur:NO orientationMask:UIInterfaceOrientationMaskPortrait]];
    [self presentViewController:navi animated:YES completion:nil];
}
- (void)onActionTouchRecord:(id)sender{
    
}
- (void)onActionNeedNotifyValueChange:(id)sender{
    UISwitch *switcher = sender;
    if (switcher.on) {
        NSLog(@"switch on");
    }else{
        NSLog(@"switch off");
    }
}
- (void)onTouchChangeUserInfo:(id)sender{
    [self setHidesBottomBarWhenPushed:YES];
    TEUserInfoViewController *vc = [[TEUserInfoViewController alloc] initWithTitle:Babel(@"edit_profile") statusStyle:UIStatusBarStyleLightContent showNaviBar:YES naviType:TENaviTypeImage naviColor:SystemBlueColor naviBlur:YES orientationMask:UIInterfaceOrientationMaskPortrait];
    [self.navigationController pushViewController:vc animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}
- (void)onTouchResetPassword:(id)sender{
    [self setHidesBottomBarWhenPushed:YES];
    TEResetPasswordViewController *vc = [[TEResetPasswordViewController alloc] initWithTitle:Babel(@"edit_password") statusStyle:UIStatusBarStyleLightContent showNaviBar:YES naviType:TENaviTypeImage naviColor:SystemBlueColor naviBlur:YES orientationMask:UIInterfaceOrientationMaskPortrait];
    [self.navigationController pushViewController:vc animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}
#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    }

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.left = 0;
    self.tableView.top = 0;
    self.tableView.width = self.view.width;
    self.tableView.height = self.view.height;
    [self.tableView reloadData];

}

@end
