//
//  TEChooseLessonTopHeaderView.m
//  TeleEducation
//
//  Created by Karl on 2017/2/24.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEChooseLessonTopHeaderView.h"
#import "UIView+TE.h"
#import "UIImageView+WebCache.h"

@interface TEChooseLessonTopHeaderView()
@property (nonatomic,strong) UIImageView *cellImage;
@property (nonatomic,strong) UILabel *titleLabel;
@end
@implementation TEChooseLessonTopHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _cellImage = [UIImageView new];
        [_cellImage setContentMode:UIViewContentModeScaleAspectFill];
        [_cellImage setClipsToBounds:YES];
        [_cellImage setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self addSubview:_cellImage];
        
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        [_titleLabel setTextColor:[UIColor darkGrayColor]];
//        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
        
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [_titleLabel setText:_titleStr];
    
}

- (void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
    [_cellImage sd_setImageWithURL:[NSURL URLWithString:_imageStr] placeholderImage:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _cellImage.top = 23;
    _cellImage.left = 30;
    _cellImage.width = 83;
    _cellImage.height = 97;
    
    _titleLabel.left = _cellImage.right + 28;
    _titleLabel.top = 39;
    _titleLabel.width = self.width - 140 - 72;
    _titleLabel.height = 50;
}

@end
