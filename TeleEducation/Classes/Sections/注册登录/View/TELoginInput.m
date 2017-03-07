//
//  TELoginInput.m
//  TeleEducation
//
//  Created by Karl on 2017/3/2.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TELoginInput.h"

@implementation TELoginInput{
    UIImageView *_icon;
    UIView *_buttomBorder;
}

- (instancetype)initWithPlaceHolder:(NSString *)placeholder image:(UIImage *)image isSecureTextEntry:(BOOL)isSecureTextEntry{
    self = [super init];
    if (self) {
        [self setPlaceholder:placeholder];
        [self setBorderStyle:UITextBorderStyleNone];
        [self setClearButtonMode:UITextFieldViewModeWhileEditing];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
        [_icon setImage:image];
        [_icon setContentMode:UIViewContentModeCenter];
        [self setLeftView:_icon];
        
        [self setLeftViewMode:UITextFieldViewModeAlways];
        
        [self setSecureTextEntry:isSecureTextEntry];
        
        _buttomBorder = [UIView new];
        [_buttomBorder setBackgroundColor:UIColorFromRGB(0xdbdbdb)];
        [self addSubview:_buttomBorder];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _buttomBorder.left = 0;
    _buttomBorder.width = self.width;
    _buttomBorder.height = 1;
    _buttomBorder.top = self.height - _buttomBorder.height;
}
@end
