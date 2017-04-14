//
//  TEPurchaseDetailViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/3/6.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEPurchaseDetailViewController.h"
#import "UIImage+TEColor.h"
#import "TEPurchaseManager.h"
#import "TEPurchaseCell.h"
#import "TEPurchaseHeaderView.h"
#import "TEGetGoodsApi.h"
#import "TELoginManager.h"
#import "TEGoods.h"

@interface TEPurchaseDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UIVisualEffectView *blurView;
@property (nonatomic,strong) UIButton *purchaseBtn;
@property (nonatomic,strong) UIView *purchaseBg;
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *priceLab;
@property (nonatomic,strong) UIView *mid;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,assign) NSInteger selectedIndex;
@end

@implementation TEPurchaseDetailViewController
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _blurView.left = 0;
    _blurView.top = 0;
    _blurView.width = self.view.width;
    _blurView.height = self.view.height;
    
    _purchaseBg.left = 0;
    _purchaseBg.width = self.view.width;
    _purchaseBg.height = 282+50;
    _purchaseBg.top = self.view.height - _purchaseBg.height;
    
    _purchaseBtn .left = 0;
    _purchaseBtn .top = _purchaseBg.height - 50;
    _purchaseBtn.width = self.view.width;
    _purchaseBtn.height = 50;
    
    _avatar.top = -20;
    _avatar.left = 22;
    _avatar.width = 136;
    _avatar.height = 103;
    
    _titleLab.left = _avatar.right + 15;
    _titleLab.top = 14;
    _titleLab.width = 150;
    _titleLab.height = 22;
    
    _priceLab.left = _titleLab.left;
    _priceLab.top = _titleLab.bottom + 6;
    _priceLab.width = 100;
    _priceLab.height = 25;
    
    _mid.left = 0;
    _mid.top = _avatar.bottom + 7;
    _mid.width = self.view.width;
    _mid.height =1;
    
    _collectionView.left = 0;
    _collectionView.top = _mid.bottom;
    _collectionView.width = self.view.width;
    _collectionView.height = _purchaseBg.height - _mid.bottom - 50;
}
- (void)buildData{
    TEGetGoodsApi *api = [[TEGetGoodsApi alloc] initWithToken:[[[TELoginManager sharedManager] currentTEUser] token]];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseJSONObject);
        
        if (![request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        NSDictionary *dic = request.responseJSONObject;
        if ([dic[@"code"] integerValue] != 1) {
            return;
        }
        
        NSArray *ary = dic[@"content"];
        [ary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TEGoods *goods = [[TEGoods alloc] initWithDictionary:obj];
            [self.data addObject:goods];
        }];
        
        [_collectionView reloadData];
        TEGoods *goods = _data.firstObject;
        [_priceLab setText:[NSString stringWithFormat:@"￥ %@",goods.priceStr]];

        _selectedIndex = 0;
        
        [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    
    _data = [NSMutableArray array];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _blurView=  [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self.view addSubview:_blurView];
    
    _purchaseBg = [UIView new];
    [_purchaseBg setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_purchaseBg];
    
    _purchaseBtn = [UIButton new];
    [_purchaseBtn setBackgroundImage:[UIImage imageWithColor:SystemBlueColor] forState:UIControlStateNormal];
    [_purchaseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_purchaseBtn setTitle:@"购买" forState:UIControlStateNormal];
    [_purchaseBtn addTarget:self action:@selector(purchaseBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    [_purchaseBg addSubview:_purchaseBtn];
    
    _avatar = [UIImageView new];
    [_avatar setImage:[UIImage imageNamed:@"purchaseImage"]];
    [_avatar setContentMode:UIViewContentModeScaleAspectFill];
    [_avatar.layer setMasksToBounds:YES];
    [_avatar.layer setCornerRadius:9.0f];
    [_avatar.layer setBorderWidth:3.0f];
    [_avatar.layer setBorderColor:UIColorFromRGB(0xffffff).CGColor];
    [_purchaseBg addSubview:_avatar];
    
    _titleLab = [UILabel new];
    [_titleLab setFont:[UIFont systemFontOfSize:16.0]];
    [_titleLab setTextColor:UIColorFromRGB(0x7b7b7b)];
    [_titleLab setText:@"TOEIC考试精品课程"];
    [_purchaseBg addSubview:_titleLab];
    
    _priceLab = [UILabel new];
    [_priceLab setFont:[UIFont systemFontOfSize:18.0]];
    [_priceLab setTextColor:UIColorFromRGB(0xfb4304)];
    [_priceLab setText:@"￥"];
    [_purchaseBg addSubview:_priceLab];
    
    _mid = [UIView new];
    [_mid setBackgroundColor:UIColorFromRGB(0xefefef)];
    [_purchaseBg addSubview:_mid];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView setDelegate: self];
    [_collectionView setDataSource:self];
    [_collectionView registerClass:[TEPurchaseCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[TEPurchaseHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_purchaseBg addSubview:_collectionView];
    
    
    [self buildData];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[TEPurchaseManager sharedManager] hidePurchaseView];

}
- (void)purchaseBtnTouchAction:(id)sender{
    if (_data.count == 0) {
        return;
    }
    TEGoods *goods = _data[_selectedIndex];
    NSLog(@"%ld",goods.goodsID);
    [[TEPurchaseManager sharedManager] creatOrderWithGoods:goods.goodsID];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15.0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    TEGoods *goods =_data[indexPath.item];
    if (goods.num == 1) {
        return CGSizeMake(86.0, 25.0);
        
    }else{
        return CGSizeMake(63.0, 25.0);
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.width, 30.0);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    TEPurchaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    TEGoods *goods = _data[indexPath.item];
    if (goods.num == 1) {
        cell.title = [NSString stringWithFormat:@"%ld节-免费",goods.num];

    }else{
        cell.title = [NSString stringWithFormat:@"%ld节",goods.num];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TEPurchaseHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        return header;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TEGoods *goods = _data[indexPath.item];
    [_priceLab setText:[NSString stringWithFormat:@"￥ %@",goods.priceStr]];
    _selectedIndex = indexPath.item;
}
@end
