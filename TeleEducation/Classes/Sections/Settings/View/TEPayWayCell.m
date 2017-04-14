//
//  TEPurchaseWayCell.m
//  TeleEducation
//
//  Created by Karl on 2017/3/8.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEPayWayCell.h"

@implementation TEPayWayCell{

    UILabel *_titleLab;
    UIView *_buttomLine;
    UIImageView *_selected;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = view;
        
        _titleLab = [UILabel new];
        [_titleLab setFont:[UIFont systemFontOfSize:16.0]];
        [_titleLab setTextColor:UIColorFromRGB(0x949494)];
        [self addSubview:_titleLab];
        
        _selected = [UIImageView new];
        [_selected.layer setMasksToBounds:YES];
        [_selected.layer setCornerRadius:10.0];
        [_selected.layer setBorderColor:UIColorFromRGB(0xbfbfbf).CGColor];
        [_selected.layer setBorderWidth:1.0f];
        [_selected setImage:nil];
        [_selected setHighlightedImage:[UIImage imageNamed:@"paySelected"]];
        [self addSubview:_selected];
        
        _buttomLine = [UIView new];
        [_buttomLine setBackgroundColor:UIColorFromRGB(0xd6d6d6)];
        [self addSubview:_buttomLine];
    }
    return self;
}
- (void)setPayTitle:(NSString *)payTitle{
    _payTitle = payTitle;
    [_titleLab setText:_payTitle];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    _titleLab.left = 20;
    _titleLab.top = 0;
    _titleLab.width = 100;
    _titleLab.height = self.height;
    
    _buttomLine.left = 13;
    _buttomLine.top =self.height-1;
    _buttomLine.width = self.width-26;
    _buttomLine.height =1;
    
    _selected.width = 20;
    _selected.height = 20;
    _selected.top = (self.height-20)/2;
    _selected.left = self.width - 40;
}

@end
