//
//  TECourseContentCell.m
//  TeleEducation
//
//  Created by Karl on 2017/3/7.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TECourseContentCell.h"
#import "UIImageView+WebCache.h"
#import "TENetworkConfig.h"
@implementation TECourseContentCell{
    UIImageView *_imageView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _imageView = [UIImageView new];
        [_imageView setClipsToBounds:YES];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:_imageView];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _imageView.left = 0;
    _imageView.top = 0;
    _imageView.width = self.contentView.width;
    _imageView.height = self.contentView.height;
}
- (void)setContent:(NSString *)content{
    _content = content;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[[[TENetworkConfig sharedConfig] baseURL] stringByAppendingString:_content]] placeholderImage:nil];
}
@end
