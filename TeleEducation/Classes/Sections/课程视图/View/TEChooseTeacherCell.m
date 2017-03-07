//
//  TEChooseTeacherCell.m
//  TeleEducation
//
//  Created by Karl on 2017/2/24.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEChooseTeacherCell.h"
#import "UIView+TE.h"

#import "UIImageView+WebCache.h"
#import "TETeacher.h"

@interface TEChooseTeacherCell ()
@property (nonatomic,strong) UIImageView *teacherAvatar;
@property (nonatomic,strong) UILabel *teacherName;
@property (nonatomic,strong) UILabel *lessonTime;
@property (nonatomic,strong) UIView *separatorView;
@end

@implementation TEChooseTeacherCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _teacherAvatar = [UIImageView new];
        [_teacherAvatar setContentMode:UIViewContentModeScaleAspectFill];
        [_teacherAvatar.layer setCornerRadius:29.0];
        [_teacherAvatar.layer setMasksToBounds:YES];
        [_teacherAvatar.layer setBorderColor:UIColorFromRGB(0xc1c1c1).CGColor];
        [_teacherAvatar.layer setBorderWidth:1.0f];
        [_teacherAvatar setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
        [self.contentView addSubview:_teacherAvatar];
        
        _teacherName = [UILabel new];
        [_teacherName setTextColor:UIColorFromRGB(0x1d1d1d)];
        [_teacherName setFont:[UIFont systemFontOfSize:14.0]];
        [self.contentView addSubview:_teacherName];
        
        _lessonTime = [UILabel new];
        [_lessonTime setFont:[UIFont systemFontOfSize:13.0]];
        [_lessonTime setTextColor:UIColorFromRGBA(0x5B5B5B, 1.0)];
        [self.contentView addSubview:_lessonTime];
        
        _separatorView  = [UIView new];
        [_separatorView setBackgroundColor:UIColorFromRGB(0xdbdbdb)];
        [self.contentView addSubview:_separatorView];
    }
    return self;
}

-(void)setData:(id)data{
    _data = data;
    TETeacher *teacher = _data;
    if ([teacher isKindOfClass:[teacher class]]) {
        _teacherName.text = teacher.name;
        [_teacherName sizeToFit];
        _lessonTime.text = [NSString stringWithFormat:@"已授课%ld课时",(long)teacher.times];
        [_lessonTime sizeToFit];
        [_teacherAvatar sd_setImageWithURL:[NSURL URLWithString:teacher.avatar] placeholderImage:nil];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _teacherAvatar.left = 21;
    _teacherAvatar.top = 8;
    _teacherAvatar.width = 58;
    _teacherAvatar.height = 58;
    
    _teacherName.left = _teacherAvatar.right + 9;
    _teacherName.top = (self.contentView.height - _teacherName.height)/2;

    _lessonTime.top = (self.contentView.height - _lessonTime.height)/2;
    _lessonTime.left = self.contentView.width - 19 - _lessonTime.width;
    
    _separatorView.left = 0;
    _separatorView.top = self.contentView.height - 1;
    _separatorView.width = self.contentView.width;
    _separatorView.height =1;
    
}

@end
