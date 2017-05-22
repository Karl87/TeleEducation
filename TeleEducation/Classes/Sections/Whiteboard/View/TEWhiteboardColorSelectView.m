//
//  TEWhiteboardColorSelectView.m
//  TeleEducation
//
//  Created by Karl on 2017/5/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEWhiteboardColorSelectView.h"

@interface TEWhiteboardColorSelectView ()
@property (nonatomic,strong) NSArray *colors;
@property (nonatomic,strong) NSMutableArray <UIButton*> *selectButtons;
@property (nonatomic,weak) id<TEWhiteboardColorSelectViewDelegate>delegate;
@end

@implementation TEWhiteboardColorSelectView

- (instancetype)initWithFrame:(CGRect)frame colors:(NSArray *)colors delegate:(id<TEWhiteboardColorSelectViewDelegate>)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        _colors = colors;
        _delegate = delegate;
        _selectButtons = [NSMutableArray array];
        for (int i = 0; i<_colors.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
            [button setBackgroundColor:UIColorFromRGB([_colors[i] unsignedIntValue])];
            button.tag = i;
            [button addTarget:self action:@selector(onColorPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_selectButtons addObject:button];
            [self addSubview:button];
        }
    }
    return self;
}

- (void)layoutSubviews{
    CGFloat space = self.height / _selectButtons.count;
    for (int i = 0; i<_selectButtons.count; i++) {
        UIButton *btn = _selectButtons[i];
        btn.height  = 27.f;
        btn.width = btn.height;
        btn.centerX = self.width /2.f;
        btn.centerY =  space/2.f+space*i;
        btn.layer.cornerRadius = btn.height/2.f;
    }
}

- (void)onColorPressed:(id)sender{
    UIButton *btn = sender;
    if (_delegate) {
        [_delegate onColorSelected:[_colors[btn.tag] unsignedIntValue]];
    }
}

@end
