//
//  TELessonMenuCell.m
//  TeleEducation
//
//  Created by Karl on 2017/4/7.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TELessonMenuCell.h"

@implementation TELessonMenuCell{
    UIImageView *_bg;
    UIImageView *_icon;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        _bg = [UIImageView new];
        [_bg setImage:[UIImage imageNamed:@"lessonManuItemBg"]];
        [_bg setHidden:!self.selected];
        [self addSubview:_bg];
        
        _icon = [UIImageView new];
        [_icon setTintColor:self.selected?SystemBlueColor:[UIColor whiteColor]];
        [self addSubview:_icon];
        
        
        
//        UIImageView *selectedBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lessonMenuItemBg"]];
//        [selectedBg setContentMode:UIViewContentModeScaleAspectFit];
//        self.selectedBackgroundView = selectedBg;
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _bg.width = self.width*0.75;
    _bg.centerX = self.width/2;
    _bg.height = 30;
    _bg.bottom = self.height;
    
    _icon.width = 20;
    _icon.height = 20;
    _icon.centerX = self.width/2;
    _icon.bottom = self.height - 5;
    
}
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [_bg setHidden:!selected];
    [_icon setTintColor:selected?SystemBlueColor:[UIColor whiteColor]];
}

- (void)setInfo:(NSString *)info{
    _info = info;
    [_icon setImage:[[UIImage imageNamed:_info] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
//    [_icon setTintColor:self.selected?SystemBlueColor:[UIColor whiteColor]];
}
@end
