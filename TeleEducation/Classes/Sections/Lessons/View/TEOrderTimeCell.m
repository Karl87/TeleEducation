//
//  TEOrderTimeCell.m
//  TeleEducation
//
//  Created by Karl on 2017/2/27.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEOrderTimeCell.h"
#import "UIView+TE.h"
#import "TEPeriod.h"

@interface TEOrderTimeCell ()
@property (nonatomic,strong) UILabel *timeLab;
@end
@implementation TEOrderTimeCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _timeLab = [UILabel new];
        [_timeLab setNumberOfLines:0];
        [_timeLab setTextAlignment:NSTextAlignmentCenter];
        [_timeLab setFont:[UIFont systemFontOfSize:14.0]];
        [_timeLab setTextColor:[UIColor grayColor]];
        [_timeLab setHighlightedTextColor:[UIColor whiteColor]];
//        [_timeLab setShadowColor:[UIColor darkGrayColor]];
        [self addSubview:_timeLab];
        [_timeLab setText:@"00:00"];
        
        UIView *selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:70.0/255.0 blue:24.0/255.0 alpha:1.0];
        self.selectedBackgroundView = selectedBackgroundView;
    }
    return self;
}
- (void)setData:(id)data{
    _data = data;
    if ([_data isKindOfClass:[TEPeriod class]]) {
        TEPeriod *period = _data;
        if ([_timeLab isHighlighted]) {
            [_timeLab setText:[NSString stringWithFormat:@"%@\n已预约",period.period]];
        }else{
            [_timeLab setText:period.period];
        }
        
        if (period.status == TEPeriodStatusAvaliable) {
            [self setUserInteractionEnabled:YES];
            [self.timeLab setBackgroundColor:[UIColor clearColor]];
            [self.timeLab setTextColor:[UIColor darkGrayColor]];
        }else{
            [self setUserInteractionEnabled:NO];
            if (period.status == TEPeriodStatusInAvaliable) {
                [self.timeLab setBackgroundColor:[UIColor clearColor]];
                [self.timeLab setTextColor:[UIColor lightGrayColor]];//UIColorFromRGB(0xaaaaaa)];
            }else{
                [self.timeLab setBackgroundColor:UIColorFromRGB(0x777777)];
                [self.timeLab setTextColor:[UIColor whiteColor]];
                if (period.status == TEPeriodStatusLeave) {
                    [_timeLab setText:[NSString stringWithFormat:@"%@\n已请假",period.period]];
                }else if (period.status == TEPeriodStatusOrdered){
                    [_timeLab setText:[NSString stringWithFormat:@"%@\n已预约",period.period]];
                }
            }
        }
    }
}
- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    if ([_data isKindOfClass:[TEPeriod class]]) {
        TEPeriod *period = _data;
        if (highlighted) {
            [_timeLab setText:[NSString stringWithFormat:@"%@\n预约",period.period]];
        }else{
            [_timeLab setText:period.period];
        }
    }
}
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if ([_data isKindOfClass:[TEPeriod class]]) {
        TEPeriod *period = _data;
        if (selected) {
            [_timeLab setText:[NSString stringWithFormat:@"%@\n预约",period.period]];
        }else{
            [_timeLab setText:period.period];
        }
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _timeLab.left = 0;
    _timeLab.top = 0;
    _timeLab.width = self.width;
    _timeLab.height = self.height;
}

@end
