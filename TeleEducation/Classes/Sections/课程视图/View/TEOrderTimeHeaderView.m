//
//  TEOrderTimeHeaderView.m
//  TeleEducation
//
//  Created by Karl on 2017/2/27.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEOrderTimeHeaderView.h"
#import "UIView+TE.h"

@interface TEOrderTimeHeaderView ()
@property (nonatomic,strong) NSMutableArray *dateLabAry;
@end

@implementation TEOrderTimeHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        if (!_dateLabAry) {
            _dateLabAry = [NSMutableArray array];
        }
//        if (!_dateStrAry) {
//            _dateStrAry = [NSMutableArray array];
//        }
        for (int i = 0; i<3; i++) {
            UILabel *lab = [UILabel new];
            [lab setNumberOfLines:0];
            [lab setFont:[UIFont boldSystemFontOfSize:14.0]];
            [lab setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:lab];
            [_dateLabAry addObject:lab];
        }
    }
    return self;
}

- (void)setDateStrAry:(NSArray *)dateStrAry{
    
    _dateStrAry= dateStrAry;
    
//    [_dateStrAry removeAllObjects];
//    [_dateStrAry addObjectsFromArray:dateStrAry];
    [_dateLabAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lab = obj;
        [lab setText:_dateStrAry[idx]];
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (int i = 0 ; i<_dateLabAry.count; i++) {
        UIView *view = _dateLabAry[i];
        view.top = 0;
        view.left = i*(self.width/3);
        view.width = self.width/3;
        view.height = self.height;
    }
}

@end
