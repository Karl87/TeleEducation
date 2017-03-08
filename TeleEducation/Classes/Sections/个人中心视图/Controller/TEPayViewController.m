//
//  TEPurchaseActionViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/3/7.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEPayViewController.h"
#import "TEGetPurchaseOrderApi.h"
#import "TELoginManager.h"
#import "TEPurchaseManager.h"
#import "TEGoods.h"
#import "TEPurchaseOrder.h"
#import "TEPayWayCell.h"
#import "TEPayOrderApi.h"
#import "TELoginManager.h"

@interface TEPayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) TEGoods *goods;
@property (nonatomic,strong) TEPurchaseOrder *order;

@property (nonatomic,strong) UIView *header;
@property (nonatomic,strong) UILabel *orderNum;
@property (nonatomic,strong) UILabel *orderTime;

@property (nonatomic,strong) UIView *goodsView;
@property (nonatomic,strong) UIImageView *goodImage;
@property (nonatomic,strong) UILabel *goodTitle;
@property (nonatomic,strong) UILabel *goodDetail;
@property (nonatomic,strong) UILabel *goodPrice;
@property (nonatomic,strong) UILabel *goodNum;
@property (nonatomic,strong) UILabel *purchaseWayTitle;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *purchaseBtn;

@property (nonatomic,strong) NSArray *payWays;
@end

@implementation TEPayViewController

- (void)buildData{
    
    TEGetPurchaseOrderApi *api = [[TEGetPurchaseOrderApi alloc] initWithToken:[[[TELoginManager sharedManager] currentTEUser] token] good:[[TEPurchaseManager sharedManager] purchaseGoods]];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseJSONObject);
        
        NSDictionary *dic = request.responseJSONObject;
        NSInteger code = [dic[@"code"] integerValue];
        if (code!=1) {
            return ;
        }
        _order = [[TEPurchaseOrder alloc] initWithDictionary:dic[@"content"]];
        _goods = [[TEGoods alloc] initWithDictionary:dic[@"content"][@"good"]];
        
        [_orderNum setText:[NSString stringWithFormat:@"订单号：%ld",_order.title]];
        [_orderTime setText:[NSString stringWithFormat:@"创建时间：%@",[self timeWithTimeIntervalString:_order.timeStamp]]];
        
        [_goodTitle setText:_goods.title];
        [_goodDetail setText:_goods.detail];
        
        [_goodPrice setText:[NSString stringWithFormat:@"￥ %@",_goods.priceStr]];
        [_goodNum setText:[NSString stringWithFormat:@"%ld节",_goods.num]];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
- (NSString *)timeWithTimeIntervalString:(float)timeStamp
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //    NSTimeZone *zone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];

    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%f",timeStamp] doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _header.top = 64;
    _header.left = 0;
    _header.width = self.view.width;
    _header.height = 40;
    
    _orderNum.left = 15;
    _orderNum.top = 0;
    _orderNum.height = _header.height;
    _orderNum.width  =_header.width - 30;
    
    _orderTime.left = 15;
    _orderTime.top = 0;
    _orderTime.height = _header.height;
    _orderTime.width  =_header.width - 30;
    
    _goodsView.left = 0;
    _goodsView.top = _header.height+64;
    _goodsView.width = _header.width;
    _goodsView.height  = 127;
    
    _goodImage.top = 11;
    _goodImage.left  = 14;
    _goodImage.width = 105;
    _goodImage.height = 105;
    
    _goodTitle.left = _goodImage.right + 19;
    _goodTitle.top = 17;
    _goodTitle.height = 25;
    _goodTitle.width = 200;
    
    _goodDetail.left = _goodTitle.left;
    _goodDetail.top = _goodTitle.bottom+4;
    _goodDetail.height = 34;
    _goodDetail.width  = 222;
    
    _goodPrice.left = _goodTitle.left;
    _goodPrice.top = _goodDetail.bottom+6;
    _goodPrice.height = 25;
    _goodPrice.width = 100;
    
    _goodNum.top = _goodDetail.bottom + 10;
    _goodNum.left = _goodsView.width - 118;
    _goodNum.height = 20;
    _goodNum.width = 100;
    
    _purchaseWayTitle.width = self.view.width;
    _purchaseWayTitle.height = 22;
    _purchaseWayTitle.top = _goodsView.bottom+26;
    _purchaseWayTitle.left =0;
    
    _tableView.left = 0;
    _tableView.top = _purchaseWayTitle.bottom+26;
    _tableView.width = self.view.width;
    _tableView.height = 100;
    
    _purchaseBtn .left = 0;
    _purchaseBtn .top = self.view.height - 50;
    _purchaseBtn.width = self.view.width;
    _purchaseBtn.height = 50;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _payWays = @[@"微信支付",@"支付宝"];
    
    _header = [UIView new];
    [_header setBackgroundColor:UIColorFromRGB(0xffffff)];
    [self.view addSubview:_header];
    
    _orderNum = [UILabel new];
    [_orderNum setText:@"订单号："];
    [_orderNum setFont:[UIFont systemFontOfSize:13.0]];
    [_orderNum setTextColor:UIColorFromRGB(0x696969)];
    [_header addSubview:_orderNum];
    
    _orderTime = [UILabel new];
    [_orderTime setText:@"创建时间："];
    [_orderTime setTextAlignment:NSTextAlignmentRight];
    [_orderTime setFont:[UIFont systemFontOfSize:13.0]];
    [_orderTime setTextColor:UIColorFromRGB(0x696969)];
    [_header addSubview:_orderTime];
    
    _goodsView = [UIView new];
    [_goodsView setBackgroundColor:UIColorFromRGB(0xf5f3f4)];
    [_goodsView.layer setBorderColor:UIColorFromRGB(0xdfdfdf).CGColor];
    [_goodsView.layer setBorderWidth:1.0];
    [self.view addSubview:_goodsView];
    
    _goodImage = [UIImageView new];
    [_goodImage setBackgroundColor:UIColorFromRGB(0xd8d8d8)];
    [_goodsView addSubview:_goodImage];
    
    _goodTitle = [UILabel new];
    [_goodTitle setText:@""];
    [_goodTitle setFont:[UIFont systemFontOfSize:18.0]];
    [_goodTitle setTextColor:UIColorFromRGB(0x5c5c5c)];
    [_goodsView addSubview:_goodTitle];
    
    _goodDetail = [UILabel new];
    [_goodDetail setText:@""];
    [_goodDetail setFont:[UIFont systemFontOfSize:12.0]];
    [_goodDetail setTextColor:UIColorFromRGB(0xa1a1a1)];
    [_goodsView addSubview:_goodDetail];
    
    _goodPrice = [UILabel new];
    [_goodPrice setText:@"￥"];
    [_goodPrice setFont:[UIFont systemFontOfSize:18.0]];
    [_goodPrice setTextColor:UIColorFromRGB(0xfb4304)];
    [_goodsView addSubview:_goodPrice];
    
    _goodNum = [UILabel new];
    [_goodNum setText:@"0节"];
    [_goodNum setFont:[UIFont systemFontOfSize:14.0]];
    [_goodNum setTextColor:UIColorFromRGB(0x757373)];
    [_goodsView addSubview:_goodNum];

    _purchaseWayTitle = [UILabel new];
    [_purchaseWayTitle setText:@"支付方式"];
    [_purchaseWayTitle setTextAlignment:NSTextAlignmentCenter];
    [_purchaseWayTitle setFont:[UIFont systemFontOfSize:16.0]];
    [_purchaseWayTitle setTextColor:UIColorFromRGB(0x949494)];
    [_goodsView addSubview:_purchaseWayTitle];
    
    _purchaseBtn = [UIButton new];
    [_purchaseBtn setBackgroundImage:[UIImage imageWithColor:SystemBlueColor] forState:UIControlStateNormal];
    [_purchaseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_purchaseBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [_purchaseBtn addTarget:self action:@selector(payBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_purchaseBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [_tableView registerClass:[TEPayWayCell class] forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self buildData];
}
- (void)payBtnTouchAction:(id)sender{
    TEPayOrderApi *api = [[TEPayOrderApi alloc] initWithToken:[[[TELoginManager sharedManager] currentTEUser] token] order:_order.orderID status:1];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseJSONObject);
        NSDictionary *dic = request.responseJSONObject;
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return;
        }
        NSInteger code = [dic[@"code"] integerValue];
        if (code !=1) {
            return;
        }
        
        if ([dic[@"status"] integerValue] == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"充值失败，请联系客服！" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _payWays.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TEPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.payTitle = _payWays[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
