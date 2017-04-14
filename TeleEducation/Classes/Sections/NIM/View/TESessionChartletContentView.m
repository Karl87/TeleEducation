//
//  TESessionChartletContentView.m
//  TeleEducation
//
//  Created by Karl on 2017/4/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TESessionChartletContentView.h"
#import "UIView+TE.h"
#import "TEChartletAttachment.h"
#import "TESessionUtil.h"

@interface TESessionChartletContentView ()
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation TESessionChartletContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        _imageView  = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.bubbleImageView.hidden = YES;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data{
    [super refresh:data];
    NIMCustomObject *customObject = (NIMCustomObject*)data.message.messageObject;
    id attachment = customObject.attachment;
    if ([attachment isKindOfClass:[TEChartletAttachment class]]) {
        self.imageView.image = [attachment showCoverImage];
        [self.imageView sizeToFit];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    CGSize contentSize = self.model.contentSize;
    CGRect imageViewFrame = CGRectMake(contentInsets.left, contentInsets.top, contentSize.width, contentSize.height);
    self.imageView.frame  = imageViewFrame;
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = 13.0;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = self.imageView.bounds;
    self.imageView.layer.mask = maskLayer;
}


@end
