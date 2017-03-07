//
//  TEPurchaseCell.m
//  TeleEducation
//
//  Created by Karl on 2017/3/6.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEPurchaseCell.h"

@implementation TEPurchaseCell{
    UILabel *_lab;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _lab.left = 0;
    _lab.top = 0;
    _lab.width = self.width;
    _lab.height = self.height;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    [_lab setText:_title];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _lab = [UILabel new];
        [_lab setTextAlignment:NSTextAlignmentCenter];
        [_lab setTextColor:UIColorFromRGB(0xfe4801)];
        [_lab setHighlightedTextColor:UIColorFromRGB(0xffffff)];
        [_lab setText:@"5节"];
        [_lab setFont:[UIFont systemFontOfSize:13.0]];
        [self addSubview:_lab];
        
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:5.0f];
        [self.layer setBorderColor:UIColorFromRGB(0xfe4801).CGColor];
        [self.layer setBorderWidth:1.0];
        
        UIView * seview= [UIView new];
        [seview setBackgroundColor:UIColorFromRGB(0xfe4801)];
        self.selectedBackgroundView = seview;
    }
    return self;
}
@end
