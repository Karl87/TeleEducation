//
//  TECourseContentViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/3/7.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TECourseContentViewController.h"
#import "TECourseContentApi.h"
#import "TELoginManager.h"
#import "TECourseContentCell.h"

@interface TECourseContentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIButton *quit;
@end

@implementation TECourseContentViewController

- (void)buildData{
    TECourseContentApi *api = [[TECourseContentApi alloc] initWithToken:[[[TELoginManager sharedManager] currentTEUser] token] unit:_unitID lesson:_lessonID];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseJSONObject);
        NSDictionary *dic = request.responseJSONObject;
        if ([dic[@"code"]integerValue] != 1) {
            return;
        }
        if (![dic[@"content"] isKindOfClass:[NSArray class]]) {
            return;
        }
        NSArray *ary = dic[@"content"];
        [ary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.data addObject:obj[@"url"]];
        }];
        [_collectionView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
- (NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [_collectionView setPagingEnabled:YES];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    
    [_collectionView registerClass:[TECourseContentCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    
    _quit = [UIButton new];
    [_quit setBackgroundImage:[UIImage imageNamed:@"naviBack"] forState:UIControlStateNormal];
    [_quit addTarget:self action:@selector(quitBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_quit];
    
    [self buildData];
}
- (void)quitBtnTouchAction:(id)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.width, self.view.height);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TECourseContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.content = self.data[indexPath.item];
    return cell;
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
    
    _quit.top = 20;
    _quit.left = 20;
    _quit.width = 60;
    _quit.height =14;
}
@end
