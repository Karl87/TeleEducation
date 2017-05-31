//
//  TEClassroomSurfaceCell.m
//  TeleEducation
//
//  Created by Karl on 2017/5/24.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEClassroomSurfaceCell.h"

@implementation TEClassroomSurfaceCell{
    UILabel *_contentLab;
    UIView *_contentBg;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _contentBg = [UIView new];
        [self addSubview:_contentBg];
        _contentLab = [UILabel new];
        [_contentLab setTextColor:[UIColor whiteColor]];
        [_contentLab setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_contentLab];
    }
    return self;
}
- (void)setContent:(id)content{
    _content = content;
    
    [_contentLab setText:(NSString*)_content];
    [_contentLab sizeToFit];
    
}

- (void)setCellAlpha:(float)cellAlpha{
    _cellAlpha = cellAlpha;
    _contentBg.alpha = _cellAlpha;
    _contentLab.alpha = _cellAlpha;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _contentLab.left = 15;
    _contentLab.centerY = self.height/2;
    
    _contentBg.left = 5;
    _contentBg.width = _contentLab.width + 25;
    _contentBg.height = _contentLab.height + 16;
    _contentBg.centerY = self.height/2;

    
    [_contentBg.layer setMasksToBounds:YES];
    [_contentBg.layer setCornerRadius:_contentBg.height/2];
    _contentBg.backgroundColor = SystemBlueColor;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
