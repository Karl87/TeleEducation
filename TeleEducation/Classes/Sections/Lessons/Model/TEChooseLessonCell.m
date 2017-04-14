//
//  TEChooseLessonCell.m
//  TeleEducation
//
//  Created by Karl on 2017/2/24.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEChooseLessonCell.h"
#import "UIView+TE.h"
#import "UIImageView+WebCache.h"
#import "TECourse.h"

@interface TEChooseLessonCell ()
@property (nonatomic,strong) UIImageView *lessonImg;
@property (nonatomic,strong) UILabel *characterLab;
@property (nonatomic,strong) UIImageView *completedMark;
@property (nonatomic,strong) UILabel *titleLab;
@end


@implementation TEChooseLessonCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _lessonImg = [UIImageView new];
        [_lessonImg setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [_lessonImg setContentMode:UIViewContentModeScaleAspectFill];
        [_lessonImg setClipsToBounds:YES];
        [self.contentView addSubview:_lessonImg];
        
        _characterLab = [UILabel new];
        [_characterLab setTextAlignment:NSTextAlignmentCenter];
        [_characterLab setFont:[UIFont boldSystemFontOfSize:44.0f]];
        [_characterLab setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_characterLab];
        
        _completedMark = [UIImageView new];
        [_completedMark setImage:[UIImage imageNamed:@"lessonCompletedMark"]];
        [_completedMark setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_completedMark];
        
        _titleLab = [UILabel new];
        [_titleLab setTextAlignment:NSTextAlignmentCenter];
        [_titleLab setTextColor:[UIColor grayColor]];
        [_titleLab setFont:[UIFont systemFontOfSize:13.0]];
        [self.contentView addSubview:_titleLab];
        
    }
    return self;
}
- (void)setData:(id)data{
    _data = data;
    
    TECourse *course = _data;
    if ([course isKindOfClass:[TECourse class]]) {
        [_characterLab setText:course.character];
        [_titleLab setText:course.title];
        [_lessonImg sd_setImageWithURL:[NSURL URLWithString:course.image] placeholderImage:nil];
        switch (course.status) {
            case TECourseStatusNormal:
                
                break;
                
            default:
                break;
        }
    }
    
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _lessonImg.left = 0;
    _lessonImg.top = 0;
    _lessonImg.width = self.contentView.width;
    _lessonImg.height = self.contentView.height - 27;
    
    _characterLab.width = _lessonImg.width;
    _characterLab.height = _lessonImg.height;
    _characterLab.left = _lessonImg.left;
    _characterLab.top = _lessonImg.top;
    
    _titleLab.left = 0;
    _titleLab.top = _lessonImg.bottom + 7;
    _titleLab.width = self.contentView.width;
    _titleLab.height = 20;
    
    _completedMark.width = 17;
    _completedMark.height = 23;
    _completedMark.top = 0;
    _completedMark.left = self.contentView.width - 13 - _completedMark.width;
}

@end
