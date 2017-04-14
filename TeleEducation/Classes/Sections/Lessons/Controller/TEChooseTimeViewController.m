//
//  TEChooseTimeViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/2/27.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEChooseTimeViewController.h"
#import "TEOrderTimeCell.h"
#import "TEOrderTimeHeaderView.h"
#import "UIImage+TEColor.h"
#import "UIView+TE.h"
#import "TETeacher.h"
#import "UIImageView+WebCache.h"
#import "TECommonPostTokenApi.h"
#import "TELoginManager.h"
#import "TEPeriod.h"

#import "TETeacher.h"
#import "TELesson.h"
#import "TEOrderLessonManager.h"

@interface TEChooseTimeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TEOrderLessonManagerDelegate>
@property (nonatomic,copy) NSIndexPath *selectedIndexpath;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSArray *dates;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIImageView *topView;
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *teacherName;
@property (nonatomic,strong) UIImageView *likeView;
@property (nonatomic,strong) UILabel *lessonCountLab;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UILabel *orderLab;
@property (nonatomic,strong) UIButton *orderBtn;

@property (nonatomic,assign) NSTimeInterval currentTime;
@end

@implementation TEChooseTimeViewController

- (void)showDate{
//    NSDate *date = [NSDate date];
////    NSLog(@"当前时间 date = %@",date);
//    NSTimeZone *zone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localDate = [date  dateByAddingTimeInterval: interval];
//    NSLog(@"当前本地时间 localDate = %@",localDate);
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];

    _currentTime = [date timeIntervalSince1970];
    
    //    // 时间转换成时间戳
//    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localDate timeIntervalSince1970]];
//    NSLog(@"Date timeSp : %@", timeSp);
//    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:[timeSp intValue]];
//    NSLog(@"TimeSp Date : %@", currentTime);
//    for (NSString *name in [NSTimeZone knownTimeZoneNames]) {
//        NSLog(@"%@",name);
//    }
//    NSData *later = [localDate lat]
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showDate];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)dealloc{
    [[TEOrderLessonManager sharedManager] removeDelegate:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self buildData];
    
    _topView = [UIImageView new];
    [_topView setImage:[UIImage imageNamed:@"orderHeader"]];
    [_topView setContentMode:UIViewContentModeScaleAspectFill];
    [_topView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.view addSubview:_topView];
    
    _avatar = [UIImageView new];
    [_avatar setContentMode:UIViewContentModeScaleAspectFill];
    [_avatar sd_setImageWithURL:[NSURL URLWithString:[TEOrderLessonManager sharedManager].lesson.teacher.avatar] placeholderImage:nil];
    [_avatar.layer setCornerRadius:30.0];
    [_avatar.layer setMasksToBounds:YES];
    [_avatar setBackgroundColor:[UIColor whiteColor]];
    [_topView addSubview:_avatar];
    
    _teacherName = [UILabel new];
    [_teacherName setText:[TEOrderLessonManager sharedManager].lesson.teacher.name];
    [_teacherName setFont:[UIFont systemFontOfSize:17.0]];
    [_teacherName setTextColor:[UIColor whiteColor]];
    [_topView addSubview:_teacherName];
    
    _likeView = [UIImageView new];
    [_likeView setImage:[UIImage imageNamed:@"orderFire"]];
    [_likeView setBackgroundColor:[UIColor clearColor]];
    [_topView addSubview:_likeView];
    
    _lessonCountLab = [UILabel new];
    [_lessonCountLab setText:[NSString stringWithFormat:@"已授课%ld课时",[TEOrderLessonManager sharedManager].lesson.teacher.times]];
    [_lessonCountLab setTextColor:[UIColor whiteColor]];
    [_lessonCountLab setFont:[UIFont systemFontOfSize:13.0]];
    [_topView addSubview:_lessonCountLab];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionHeadersPinToVisibleBounds = YES;
//    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width/3, 45);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_collectionView setDelegate: self];
    [_collectionView setDataSource:self];
    [_collectionView registerClass:[TEOrderTimeCell class] forCellWithReuseIdentifier:@"timeCell"];
    [_collectionView registerClass:[TEOrderTimeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
//    [_collectionView registerClass:[TEChooseLessonTopHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"topHeaderView"];
    [_collectionView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 50.0f, 0.0f)];
    [self.view addSubview:_collectionView];
    
    _bottomView = [UIView new];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];
    [_bottomView.layer setShadowColor:[UIColor grayColor].CGColor];
    [_bottomView.layer setShadowOffset:CGSizeMake(0, -1)];
    [self.view addSubview:_bottomView];
    
    _orderLab = [UILabel new];
    [_orderLab setTextColor:[UIColor darkGrayColor]];
    [_orderLab setText:@"您还没有预约课程"];
    [_orderLab setFont:[UIFont systemFontOfSize:14.0f]];
    [_orderLab sizeToFit];
    [_bottomView addSubview:_orderLab];
    
    _orderBtn = [UIButton new];
    [_orderBtn setBackgroundImage:[UIImage imageWithColor:SystemBlueColor] forState:UIControlStateNormal];
    [_orderBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateDisabled];
    [_orderBtn setTitle:@"预约课程" forState:UIControlStateNormal];
    [_orderBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_orderBtn addTarget:self action:@selector(orderLessonBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    [_orderBtn setEnabled:NO];
    [_bottomView addSubview:_orderBtn];
    
    [[TEOrderLessonManager sharedManager] addDelegate:self];
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _topView.left = 0;
    _topView.top = 0;
    _topView.width = self.view.width;
    _topView.height = 160.0f;
    
    _avatar.width = 60;
    _avatar.height = 60;
    _avatar.left = 23;
    _avatar.top = _topView.height - _avatar.height - 27;
    
    _teacherName.height = 20.0;
    _teacherName.left = _avatar.right + 20;
    _teacherName.width = _topView.width - 20*3 - _avatar.width;
    _teacherName.top = _topView.height - _teacherName.height - 57;
    
    _likeView.width = 12;
    _likeView.height = 15;
    _likeView.left = _teacherName.left;
    _likeView.top = _teacherName.bottom + 5;
    
    _lessonCountLab.left = _likeView.right + 7;
    _lessonCountLab.top = _teacherName.bottom + 2;
    _lessonCountLab.height = 18;
    _lessonCountLab.width = _topView.width - _lessonCountLab.left - 20;
    
    _collectionView.top = _topView.bottom;
    _collectionView.left = 0;
    _collectionView.width = self.view.width;
    _collectionView.height = self.view.height - _topView.height;
    
    _bottomView.left = 0;
    _bottomView.width = self.view.width;
    _bottomView.height = 50;
    _bottomView.top = self.view.height - 50;
    
    _orderLab.left = 20;
    _orderLab.top = (_bottomView.height - _orderLab.height)/2;
    
    _orderBtn.width = 125;
    _orderBtn.height = _bottomView.height;
    _orderBtn.left = _bottomView.width - 120;
    _orderBtn.top = 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configNav{
    [super configNav];
    
    UIBarButtonItem *clearBtn = [[UIBarButtonItem alloc] initWithTitle:@"清除选择" style:UIBarButtonItemStylePlain target:self action:@selector(clearTimeOrdered:)];
    [self.navigationItem setRightBarButtonItem:clearBtn];
}

- (void)clearTimeOrdered:(id)sender{
    [_collectionView setAllowsSelection:NO];
    _selectedIndexpath = nil;
    [_collectionView setAllowsSelection:YES];
    [_orderLab setText:@"您还没有预约课程"];
    [_orderLab sizeToFit];
    [_orderBtn setEnabled:NO];
}

- (void)buildData{
    
    if (!_data) {
        _data = [NSMutableArray array];
    }
    [_data removeAllObjects];
    
//    if (!_dates) {
//        _dates = [NSMutableArray array];
//    }
//    [_dates removeAllObjects];
//    for (NSInteger i = 9; i<19; i++) {
//        for (NSInteger j=0; j<3; j++) {
//            NSDictionary *dic = @{
//                                  @"time":[NSString stringWithFormat:@"%2ld:00",i],
//                                  @"date":@"",
//                                  @"avaliable":j==i-9?@(NO):@(YES)
//                                  };
//            [_data addObject:dic];
//        }
//    }
    
    
    TECommonPostTokenApi *api = [[TECommonPostTokenApi alloc] initWithToken:[[[TELoginManager sharedManager] currentTEUser] token] type:TETokenApiTypeGetPeriods teacher:[TEOrderLessonManager sharedManager].lesson.teacher.teacherID];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseJSONObject);
        NSDictionary *data = request.responseJSONObject;
        NSInteger apiCode = [data[@"code"] integerValue];
        NSArray *periods = data[@"content"];
        
        NSMutableArray *tempDates = [NSMutableArray array];
        
        if (periods.count ==3) {
            NSArray *aDay = periods[0];
            for (int i = 0; i<[aDay count]; i++) {
                for (int j =0; j<[periods count]; j++) {
                    TEPeriod *period = [[TEPeriod alloc] initWithDictionary:periods[j][i] currentTime:_currentTime];
                    [_data addObject:period];
                    if (i == 0) {
                        [tempDates addObject:[period.date copy]];
                    }
                }
            }
        }
        
        _dates = @[tempDates[0],tempDates[1],tempDates[2]];
        
        [_collectionView reloadData];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}
#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [_collectionView reloadData];
    if (_selectedIndexpath) {
        [_collectionView selectItemAtIndexPath:_selectedIndexpath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    }
}
#pragma mark - Layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.bounds.size.width/3, 50);
}
- (UIEdgeInsets )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    if (section == 0) {
        return UIEdgeInsetsZero;
//    }
//    return  UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    if (section == 0) {
//        return 0;
//    }
    return 0.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    if (section == 0) {
//        return 0;
//    }
    return 0.0f;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return CGSizeMake(self.view.bounds.size.width, 190.0);
//    }
    return CGSizeMake(self.view.bounds.size.width, 50.0);
}
#pragma mark - UICollectionDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 0;
//    }
    return _data.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TEOrderTimeCell * cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"timeCell" forIndexPath:indexPath];
    if (indexPath.item%6 <3) {
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    cell.data = _data[indexPath.item];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        if (indexPath.section == 0) {
            TEOrderTimeHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
            header.dateStrAry = [_dates copy];
            return header;
//        }else{
//            TEChooseLessonHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
//            header.titleStr = [NSString stringWithFormat:@"Section %ld",indexPath.section];
//            return header;
//        }
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectedIndexpath = indexPath;
    
    [_orderLab setText:@"您已经预约了1节课程"];
    [_orderLab sizeToFit];
    [_orderBtn setEnabled:YES];
    
    TEPeriod *period = _data[indexPath.item];
    [TEOrderLessonManager sharedManager].period = [period copy];
    

}
#pragma mark - 

- (void)orderLessonBtnTouchAction:(id)sender{
    
//    [TEOrderLessonManager sharedManager].period.date
    
    NSString *message = [NSString stringWithFormat:@"时间：%@ %@\n教材：%@-%@\n老师：%@", [TEOrderLessonManager sharedManager].period.date, [TEOrderLessonManager sharedManager].period.period, [TEOrderLessonManager sharedManager].lesson.unit, [TEOrderLessonManager sharedManager].lesson.lesson, [TEOrderLessonManager sharedManager].lesson.teacher.name];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认课程" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *orderAction = [UIAlertAction actionWithTitle:@"确认预约" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[TEOrderLessonManager sharedManager] orderLesson];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:orderAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - 
- (void)orderLessonCompleted:(TEOrderLessonStatus)status{
    
    NSString *message = @"预约课程失败！";
    NSString *reson ;
    
    switch (status) {
        case TEOrderLessonStatusFailed:
            reson = @"请您与客服联系！";
            break;
        case TEOrderLessonStatusSuccessed:
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        case TEOrderLessonStatusInvalid:
            reson = @"该时间已无法预约课程！";
            break;
        case TEOrderLessonStatusSelfOrdered:
            reson = @"该时间您已预约其他课程！";
            break;
        case TEOrderLessonStatusOtherOrdered:
            reson = @"您选择的教师和时间已被其他人预约！";
            break;
        case TEOrderLessonStatusBalanceNotEnough:
            reson = @"您的余额不足，请充值！";
            break;
        default:
            break;
    }
    
    UIAlertController *alert  =[UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:[message stringByAppendingString:reson]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)orderLessonFailed{
    
}
@end
