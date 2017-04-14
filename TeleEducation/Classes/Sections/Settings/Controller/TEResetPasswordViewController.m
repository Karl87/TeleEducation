//
//  TEResetPasswordViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/2/22.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEResetPasswordViewController.h"
#import "NIMCommonTableData.h"
#import "NIMCommonTableDelegate.h"
#import "UIView+TE.h"

@interface TEResetPasswordViewController ()
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) NIMCommonTableDelegate *delegator;
@end

@implementation TEResetPasswordViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configNav];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self configStatusBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"修改密码";
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onTouchSaveUserName:)];
    [self.navigationItem setRightBarButtonItem:saveBtn];
    
    [self buildData];
    __weak typeof(self) wself = self;
    self.delegator = [[NIMCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self.delegator;
    self.tableView.dataSource = self.delegator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configNav{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:SystemBlueColor];
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
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
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -

- (void)buildData{
    NSArray *data = @[
                      @{
                          RowContent :@[
                                  @{
                                      CellClass     : @"TEPasswordCell",
                                      RowHeight     : @(60),
                                      ExtraInfo :@{@"placeHolder":@"旧密码",
                                                   @"showRightView":@(NO),
                                                   @"isSecurty":@(NO)
                                              }
                                      },
                                  @{
                                      CellClass     : @"TEPasswordCell",
                                      RowHeight     : @(60),
                                      ExtraInfo :@{@"placeHolder":@"新密码",
                                                   @"showRightView":@(YES),
                                                   @"isSecurty":@(YES)
                                                   }
                                      }
                                  ]
                          }
                      ];
    self.data = [NIMCommonTableSection sectionsWithData:data];
}

- (void)refreshData{
    [self buildData];
    [self.tableView reloadData];
}
#pragma mark - Action

- (void)onTouchSaveUserName:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onTouchChangeUserName:(id)sender{
    NSLog(@"username");
}

#pragma mark - Private

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.tableView.left = 0;
    self.tableView.top = 0;
    self.tableView.width = self.view.width;
    self.tableView.height = self.view.height;
    [self.tableView reloadData];
}
@end
