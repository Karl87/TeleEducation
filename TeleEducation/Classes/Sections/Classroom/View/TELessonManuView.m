//
//  TELessonManuView.m
//  TeleEducation
//
//  Created by Karl on 2017/4/7.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TELessonManuView.h"
#import "TELessonManuItem.h"
#import "TELessonMenuCell.h"

@interface TELessonManuView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong) NSMutableArray *itemViews;

@property (nonatomic,strong) UIButton *exitBtn;
@property (nonatomic,strong) UICollectionView *manuView;

@end


@implementation TELessonManuView

- (instancetype)initWithItems:(NSArray *)items{
    self = [super init];
    if (self) {
        
        self.backgroundColor = SystemBlueColor;
        self.clipsToBounds = YES;
        
        _items = items;
        _itemViews = [NSMutableArray array];
        
        _exitBtn = [UIButton new];
        [_exitBtn setBackgroundImage:[UIImage imageNamed:@"lessonExit"] forState:UIControlStateNormal];
        [_exitBtn addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_exitBtn];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.itemSize = CGSizeMake(100, 44);
        
        _manuView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _manuView.delegate = self;
        _manuView.dataSource = self;
        _manuView.backgroundColor = [UIColor clearColor];
        [_manuView registerClass:[TELessonMenuCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:_manuView];
        
        [_manuView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _exitBtn.left = 15;
    _exitBtn.top = 5;
    _exitBtn.width = 34;
    _exitBtn.height = 34;
    
    _manuView.left = _exitBtn.right + 20;
    _manuView.top = 0;
    _manuView.height = self.height;
    _manuView.width = self.width - _exitBtn.left*2 - _exitBtn.width ;
    
}

- (void)exitAction:(id)sender{
    [self.delegate lessonManuView:self didSelectedItem:@"exit"];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate lessonManuView:self didSelectedItem:_items[indexPath.item]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TELessonMenuCell * cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = SystemBlueColor;
    cell.info = [NSString stringWithFormat:@"lessonManu%@",_items[indexPath.item]];
    return cell;

}
@end
