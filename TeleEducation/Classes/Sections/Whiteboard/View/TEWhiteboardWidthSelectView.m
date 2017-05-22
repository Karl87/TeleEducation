//
//  TEWhiteboardWidthSelectView.m
//  TeleEducation
//
//  Created by Karl on 2017/5/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEWhiteboardWidthSelectView.h"


@interface TEWhiteboardWidthSelectView ()
@property (nonatomic,strong) NSArray *widths;
@property (nonatomic,strong) NSMutableArray <UIButton*> *selectButtons;
@property (nonatomic,weak) id<TEWhiteboardWidthSelectViewDelegate>delegate;

@end

@implementation TEWhiteboardWidthSelectView

- (instancetype)initWithFrame:(CGRect)frame widths:(NSArray *)widths delegate:(id<TEWhiteboardWidthSelectViewDelegate>)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        _widths = widths;
        _delegate = delegate;
        _selectButtons = [NSMutableArray array];
        for (int i = 0; i<_widths.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
            [button setBackgroundColor:SystemBlueColor];
            [button.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
            [button setTitle:[NSString stringWithFormat:@"%.1f",[_widths[i] floatValue]] forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(onWidthPressed:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)onWidthPressed:(id)sender{
    UIButton *btn = sender;
    if (_delegate) {
        [_delegate onWidthSelected:[_widths[btn.tag] floatValue]];
    }
}


@end
