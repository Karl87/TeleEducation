//
//  TELessonCell.m
//  TeleEducation
//
//  Created by Karl on 2017/2/23.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TELessonCell.h"
#import "NIMCommonTableData.h"
#import "UIView+TE.h"
#import "UIImage+TEColor.h"
#import "TELesson.h"
#import "TETeacher.h"
#import "TEUser.h"

#import "UIImageView+WebCache.h"

@interface TELessonCell ()

@property (nonatomic,strong) UIImageView *teacherAvatar;
@property (nonatomic,strong) UILabel *teacherName;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *subTitleLab;

@property (nonatomic,strong) UIView *middleBorder;

@property (nonatomic,strong) UIImageView *timeImg;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *stateLab;
@property (nonatomic,strong) UIButton *showContentBtn;
@property (nonatomic,strong) UIButton *startLessonBtn;

@property (nonatomic,strong) UIView *buttomBorder;

@end
@implementation TELessonCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _teacherAvatar = [UIImageView new];
        [_teacherAvatar setContentMode:UIViewContentModeScaleAspectFill];
        [_teacherAvatar setImage:[UIImage imageWithColor:[UIColor groupTableViewBackgroundColor]]];
        [_teacherAvatar.layer setCornerRadius:24.0];
        [_teacherAvatar.layer setMasksToBounds:YES];
        [_teacherAvatar.layer setBorderColor:UIColorFromRGB(0xc1c1c1).CGColor];
        [_teacherAvatar.layer setBorderWidth:1.0f];
        [self addSubview:_teacherAvatar];
        
        _teacherName = [UILabel new];
        [_teacherName setFont:[UIFont systemFontOfSize:13.0]];
        [self addSubview:_teacherName];
        
        _titleLab = [UILabel new];
        [_titleLab setTextColor:[UIColor grayColor]];
        [_titleLab setFont:[UIFont systemFontOfSize:17.0]];
        [self addSubview:_titleLab];
        
        _subTitleLab = [UILabel new];
        [_subTitleLab setTextColor:[UIColor grayColor]];
        [_subTitleLab setFont:[UIFont systemFontOfSize:17.0]];
        [self addSubview:_subTitleLab];
        
        _middleBorder = [UIView new];
        [_middleBorder setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self addSubview:_middleBorder];
        
        _timeImg = [UIImageView new];
        [_timeImg setImage:[UIImage imageNamed:@"lessonClock"]];
        [self addSubview:_timeImg];
        
        _timeLab = [UILabel new];
        [_timeLab setFont:[UIFont systemFontOfSize:17.0]];
        [self addSubview:_timeLab];
        
        _stateLab = [UILabel new];
        [_stateLab setFont:[UIFont systemFontOfSize:17.0]];
        [self addSubview:_stateLab];
        
        _showContentBtn = [UIButton new];
        [_showContentBtn setBackgroundImage:[UIImage imageWithColor:SystemBlueColor] forState:UIControlStateNormal];
        [_showContentBtn setTitle:Babel(@"lesson_prepare") forState:UIControlStateNormal];
        [_showContentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_showContentBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [_showContentBtn addTarget:self action:@selector(showContentAction:) forControlEvents:UIControlEventTouchUpInside];
        [_showContentBtn.layer setCornerRadius:6.0];
        [_showContentBtn.layer setMasksToBounds:YES];
        [self addSubview:_showContentBtn];
        
        _startLessonBtn = [UIButton new];
        [_startLessonBtn setBackgroundImage:[UIImage imageWithColor:SystemBlueColor] forState:UIControlStateNormal];
        [_startLessonBtn setTitle:Babel(@"lesson_enter") forState:UIControlStateNormal];
        [_startLessonBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startLessonBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [_startLessonBtn addTarget:self action:@selector(startLessonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_startLessonBtn.layer setCornerRadius:6.0];
        [_startLessonBtn.layer setMasksToBounds:YES];
        [self addSubview:_startLessonBtn];
        
        _buttomBorder = [UIView new];
        [_buttomBorder setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self addSubview:_buttomBorder];
    }
    return self;
}
- (void)setData:(id)data{
    _data = data;

    if (![_data isKindOfClass:[TELesson class]]) {
        return;
    }
    
    TELesson *lesson = _data;
    
    BOOL isStudent = [TELoginManager sharedManager].currentTEUser.type == TEUserTypeStudent?YES:NO;
    
    [_teacherName setText:isStudent?lesson.teacher.name:lesson.user.name];
    [_teacherAvatar sd_setImageWithURL:[NSURL URLWithString:isStudent?lesson.teacher.avatar:lesson.user.avatar] placeholderImage:nil];
    [_teacherName sizeToFit];
    [_titleLab setText:lesson.book];
    [_subTitleLab setText:[NSString stringWithFormat:@"%@ - %@",lesson.unit,lesson.lesson]];
        
        //        NSString* iconStr = @"/time/";
        //        NSMutableAttributedString *timeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",iconStr,dic[@"startTime"]]];
        //        NSTextAttachment *timeAttchment = [[NSTextAttachment alloc]
        //                                           init];
        //        timeAttchment.image = [UIImage imageNamed:@"clock.png"];
        //        NSAttributedString *iconAttributedString = [NSAttributedString attributedStringWithAttachment:timeAttchment];
        //
        //        [timeStr replaceCharactersInRange:NSMakeRange(0, iconStr.length) withAttributedString:iconAttributedString];
        //        _timeLab.attributedText = timeStr;
        
    [_timeLab setText:lesson.period];
    [_timeLab sizeToFit];
    
        
    switch (lesson.status) {
        case TELessonStatusNormal:
            _stateLab.hidden = YES;
            _showContentBtn.hidden = NO;
            _startLessonBtn.hidden = NO;
            break;
        case TELessonStatusCompleted:
            _stateLab.hidden = NO;
            _showContentBtn.hidden = YES;
            _startLessonBtn.hidden = YES;
            [_stateLab setText:Babel(@"completed")];
            break;
        case TELessonStatusCancel:
            _stateLab.hidden = NO;
            _showContentBtn.hidden = YES;
            _startLessonBtn.hidden = YES;
            [_stateLab setText:Babel(@"canceled")];
        default:
            break;
    }
    [_stateLab sizeToFit];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    _teacherAvatar.top = 10;
    _teacherAvatar.left = 25;
    _teacherAvatar.width = 48;
    _teacherAvatar.height = 48;
    
    _teacherName.top = _teacherAvatar.bottom + 6;
    _teacherName.centerX = _teacherAvatar.centerX;
    
    _titleLab.left = _teacherAvatar.width+25*2;
    _titleLab.top = 16;
    _titleLab.width = self.width - _teacherAvatar.width - 48 - 25*3;
    _titleLab.height = 22;
    
    _subTitleLab.left = _titleLab.left;
    _subTitleLab.top = _titleLab.bottom;
    _subTitleLab.width = _titleLab.width;
    _subTitleLab.height = 22;
    
    _middleBorder.left = 0;
    _middleBorder.width = self.width;
    _middleBorder.top = _teacherName.bottom +4;
    _middleBorder.height = 1;
    
    _timeImg.left = 20;
    _timeImg.top = self.height - 18 - 16;
    _timeImg.width = 16;
    _timeImg.height = 16;
    
    _timeLab.left = _timeImg.right + 8;
    _timeLab.width = 100;
    _timeLab.height = 20;
    _timeLab.top = self.height - 17 - 20;

    _startLessonBtn.top = self.height - 30 - 13;
    _startLessonBtn.width = 100;
    _startLessonBtn.height = 30;
    _startLessonBtn.left = self.width - 30 - _startLessonBtn.width;
    
    _showContentBtn.top = _startLessonBtn.top;
    _showContentBtn.width = 100;
    _showContentBtn.height = 30;
    _showContentBtn.left = self.width - 20*2 - _startLessonBtn.width - _showContentBtn.width;
    
    _stateLab.left = self.width - 20 - _stateLab.width;
    _stateLab.centerY = _timeLab.centerY;
    
    _buttomBorder.left = 0;
    _buttomBorder.top = self.contentView.height - 1;
    _buttomBorder.width = self.contentView.width;
    _buttomBorder.height = 1;
}

#pragma mark - Private

- (void)showContentAction:(id)sender{

    if (self.delegate && [self.delegate respondsToSelector:@selector(lessonActionWith:andIndexPath:)]) {
        [self.delegate lessonActionWith:TELessonCellActionTypeShowContent andIndexPath:_indexPath];
    }
}

- (void)startLessonAction:(id)sender{

    if (self.delegate && [self.delegate respondsToSelector:@selector(lessonActionWith:andIndexPath:)]) {
        [self.delegate lessonActionWith:TELessonCellActionTypeStartClass andIndexPath:_indexPath];
    }
}

@end
