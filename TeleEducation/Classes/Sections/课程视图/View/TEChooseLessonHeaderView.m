//
//  TEChooseLessonHeaderView.m
//  TeleEducation
//
//  Created by Karl on 2017/2/24.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEChooseLessonHeaderView.h"
#import "UIView+TE.h"


@interface TEChooseLessonHeaderView ()
@property (nonatomic,strong) UILabel *titleLabel;
@end
@implementation TEChooseLessonHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _titleLabel = [UILabel new];
        [_titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_titleLabel setTextColor:SystemBlueColor];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
        
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [_titleLabel setText:_titleStr];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLabel.left = 0;
    _titleLabel.top = 0;
    _titleLabel.width = self.width;
    _titleLabel.height = self.height;
}
@end
