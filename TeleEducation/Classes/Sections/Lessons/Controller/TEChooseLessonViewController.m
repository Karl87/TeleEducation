//
//  TEChooseLessonViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/2/24.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEChooseLessonViewController.h"
#import "TEChooseLessonCell.h"
#import "TEChooseLessonHeaderView.h"
#import "TEChooseLessonTopHeaderView.h"
#import "TEChooseTeacherViewController.h"
#import "TECommonPostTokenApi.h"
#import "TELoginManager.h"

#import "TEOrderLessonManager.h"
#import "TELesson.h"
#import "TEBook.h"
#import "TEUnit.h"
#import "TECourse.h"

@interface TEChooseLessonViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) TEBook *book;
@end

@implementation TEChooseLessonViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionHeadersPinToVisibleBounds = YES;
    flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width-80)/3, 180);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView setDelegate: self];
    [_collectionView setDataSource:self];
    [_collectionView registerClass:[TEChooseLessonCell class] forCellWithReuseIdentifier:@"lessonCell"];
    [_collectionView registerClass:[TEChooseLessonHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    [_collectionView registerClass:[TEChooseLessonTopHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"topHeaderView"];
    [self.view addSubview:_collectionView];
    
    [self buildData];
}

- (NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)buildData{
    TECommonPostTokenApi * api = [[TECommonPostTokenApi alloc] initWithToken:[[[TELoginManager sharedManager] currentTEUser] token]type:TETokenApiTypeGetCourses];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseJSONObject);
        if (![request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSInteger apiCode = [request.responseJSONObject[@"code"] integerValue];
        if (apiCode != 1) {
            return;
        }
        if (![request.responseJSONObject[@"content"] isKindOfClass:[NSDictionary class]]) {
            return;
        }
        NSDictionary *content = request.responseJSONObject[@"content"];
        _book = nil;
        _book = [[TEBook alloc] initWithDictionary:content];
        
        [self.data removeAllObjects];
        
        NSArray * allData = content[@"unit"];
        
        [allData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TEUnit *unit = [[TEUnit alloc] initWithDictionary:obj];
            [_data addObject:unit];
        }];
        NSLog(@"%ld",_data.count);
        [self.collectionView reloadData];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Layout
- (UIEdgeInsets )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsZero;
    }
    return  UIEdgeInsetsMake(12, 20, 16, 20);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 20.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 12.0f;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(self.view.bounds.size.width, 144.0);
    }
    return CGSizeMake(self.view.bounds.size.width, 44.0);
}
#pragma mark - UICollectionDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.data.count+1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    TEUnit *unit = self.data[section-1];
    if (unit) {
        return unit.courses.count;
    }
    
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TEChooseLessonCell * cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"lessonCell" forIndexPath:indexPath];
    TEUnit *unit =_data[indexPath.section-1];
    if (unit) {
        TECourse *course = unit.courses[indexPath.item];
        if (course) {
            cell.data = course;
        }
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            TEChooseLessonTopHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"topHeaderView" forIndexPath:indexPath];
            if (_book) {
                header.titleStr = _book.title;
                header.imageStr = _book.image;
            }
            return header;
        }else{
            TEChooseLessonHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
            TEUnit *unit = _data[indexPath.section-1];
            if (unit) {
                header.titleStr =unit.title;
            }
            return header;
        }
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TEChooseTeacherViewController *vc = [[TEChooseTeacherViewController alloc] initWithTitle:Babel(@"select_teacher") statusStyle:UIStatusBarStyleLightContent showNaviBar:YES naviType:TENaviTypeImage naviColor:SystemBlueColor naviBlur:NO orientationMask:UIInterfaceOrientationMaskPortrait];
    TEUnit *unit = _data[indexPath.section-1];
    [TEOrderLessonManager sharedManager].lesson.unitID = unit.unitID;
    [TEOrderLessonManager sharedManager].lesson.unit = unit.title;
    TECourse *course = unit.courses[indexPath.item];
    [TEOrderLessonManager sharedManager].lesson.lessonID = course.courseID;
    [TEOrderLessonManager sharedManager].lesson.lesson = course.title;
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [_collectionView reloadData];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _collectionView.top = 0;
    _collectionView.left = 0;
    _collectionView.width = self.view.width;
    _collectionView.height = self.view.height;
}
@end
