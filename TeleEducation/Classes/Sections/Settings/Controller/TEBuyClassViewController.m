//
//  TEBuyClassViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/2/28.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEBuyClassViewController.h"
#import "ViewController.h"
#import "UIImage+TEColor.h"
#import "TEPurchaseManager.h"
#import "TEPayViewController.h"

@interface TEBuyClassViewController ()<UITableViewDelegate,UITableViewDataSource,TEPurchaseManagerDelegate>
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic,strong) UIView *purchaseBg;
@property (nonatomic,strong) UIButton *purchaseBtn;
@property (nonatomic,strong) UIView *purchaseView;
@property (nonatomic,strong) UIWindow *purchaseWindow;
@end

@implementation TEBuyClassViewController

- (void)quit{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _purchaseBtn .left = 0;
    _purchaseBtn .top = self.view.height - 50;
    _purchaseBtn.width = self.view.width;
    _purchaseBtn.height = 50;
}
- (void)dealloc{
    [[TEPurchaseManager sharedManager] removeDelegate:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[TEPurchaseManager sharedManager] addDelegate:self];
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem * dismiss = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"naviBack"] style:UIBarButtonItemStylePlain target:self action:@selector(quit)];
    [self.navigationItem setLeftBarButtonItem:dismiss];
    
//    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [_tableView setDelegate: self];
//    [_tableView setDataSource:self];
//    [self.view addSubview:_tableView];
    
    _purchaseBtn = [UIButton new];
    [_purchaseBtn setBackgroundImage:[UIImage imageWithColor:SystemBlueColor] forState:UIControlStateNormal];
    [_purchaseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_purchaseBtn setTitle:@"购买" forState:UIControlStateNormal];
    [_purchaseBtn addTarget:self action:@selector(callPurchase) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_purchaseBtn];
    
//    _purchaseBg = [[UIView alloc] initWithFrame:self.view.bounds];
//    [_purchaseBg setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6]];
//    [self.view addSubview:_purchaseBg];
}
- (void)callPurchase{
    [[TEPurchaseManager sharedManager] showPurchaseView];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
}
- (void)creatOrderWithGoods:(NSInteger)goods{
    NSLog(@"%ld",goods);

    TEPayViewController *vc = [[TEPayViewController alloc] initWithTitle:@"在线支付" statusStyle:UIStatusBarStyleLightContent showNaviBar:YES naviType:TENaviTypeImage naviColor:SystemBlueColor naviBlur:NO orientationMask:UIInterfaceOrientationMaskPortrait];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
