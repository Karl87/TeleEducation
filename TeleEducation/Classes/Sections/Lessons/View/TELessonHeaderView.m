//
//  TELessonHeaderView.m
//  TeleEducation
//
//  Created by Karl on 2017/2/27.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TELessonHeaderView.h"
#import "UIView+TE.h"
#import "NSString+TEDate.h"

@interface TELessonHeaderView ()
@property (nonatomic,strong) UILabel *titleLab;
@end
@implementation TELessonHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        _titleLab = [UILabel new];
        [_titleLab setTextColor:SystemBlueColor];
        [_titleLab setFont:[UIFont systemFontOfSize:13.0]];
        [_titleLab setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLab];
    }
    return self;
}

- (void)setHeaderStr:(NSString *)headerStr{
    _headerStr = headerStr;
    [_titleLab setText:[NSString stringWithFormat:@"%@ %@",[NSString stringWithDateString:_headerStr],_headerStr]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLab.top = 0;
    _titleLab.left = 0;
    _titleLab.width = self.width;
    _titleLab.height = self.height;
}
@end
