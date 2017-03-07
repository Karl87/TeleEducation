//
//  TEPurchaseActionViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/3/7.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEPurchaseActionViewController.h"
#import "TEGetPurchaseOrderApi.h"
#import "TELoginManager.h"
#import "TEPurchaseManager.h"
#import "TEGoods.h"
#import "TEPurchaseOrder.h"

@interface TEPurchaseActionViewController ()<UITableViewDelegate,UITableViewDataSource>

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
@end

@implementation TEPurchaseActionViewController

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
    
    _purchaseWayTitle.width = 64;
    _purchaseWayTitle.height = 22;
    _purchaseWayTitle.top = _goodsView.bottom+26;
    _purchaseWayTitle.left = (self.view.width - 64)/2;
    
    _purchaseBtn .left = 0;
    _purchaseBtn .top = self.view.height - 50;
    _purchaseBtn.width = self.view.width;
    _purchaseBtn.height = 50;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
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
    [_purchaseBtn addTarget:self action:@selector(purchaseBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_purchaseBtn];
    
    [self buildData];
}
- (void)purchaseBtnTouchAction:(id)sender{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
