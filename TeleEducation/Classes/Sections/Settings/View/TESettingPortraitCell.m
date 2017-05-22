//
//  TESettingPortraitCellCell.m
//  TeleEducation
//
//  Created by Karl on 2017/2/21.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TESettingPortraitCell.h"
#import "NIMCommonTableData.h"
#import "UIView+TE.h"
#import "UIImage+TEColor.h"
#import "UIImageView+WebCache.h"
#import "TELoginManager.h"

@interface TESettingPortraitCell()
@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UILabel *userNameLab;
@property (nonatomic,strong) UILabel *balanceLab;
@property (nonatomic,strong) UIButton *rebookBtn;
@property (nonatomic,strong) UIButton *recordBtn;
@end

@implementation TESettingPortraitCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat avatarSize = 55.0f;
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, avatarSize, avatarSize)];
        [_avatarImageView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = _avatarImageView.height/2;
        [self addSubview:_avatarImageView];
        
        _userNameLab  =[[UILabel alloc] initWithFrame:CGRectZero];
        _userNameLab.font = [UIFont boldSystemFontOfSize:18.0f];
        [self addSubview:_userNameLab];
        
        _balanceLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [_balanceLab setFont:[UIFont systemFontOfSize:13.0]];
        [_balanceLab setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_balanceLab];
        
        _rebookBtn = [UIButton new];
        [_rebookBtn setTitle:@"续订课程" forState:UIControlStateNormal];
        [_rebookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rebookBtn setBackgroundImage:[UIImage imageWithColor:SystemBlueColor] forState:UIControlStateNormal];
        [_rebookBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self addSubview:_rebookBtn];
    
        _recordBtn = [UIButton new];
        [_recordBtn setBackgroundColor:[UIColor clearColor]];
        NSMutableAttributedString *recordBtnNormal = [[NSMutableAttributedString alloc] initWithString:@"购买记录"];
        [recordBtnNormal addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor],
                                         NSFontAttributeName : [UIFont systemFontOfSize:13.0],
                                         NSUnderlineStyleAttributeName :[NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                         NSUnderlineColorAttributeName:[UIColor lightGrayColor]
                                         } range:NSMakeRange(0, recordBtnNormal.length)];

        NSMutableAttributedString *recordBtnHighlight = [[NSMutableAttributedString alloc] initWithString:@"购买记录"];
        [recordBtnHighlight addAttributes:@{NSForegroundColorAttributeName : [UIColor groupTableViewBackgroundColor],
                                         NSFontAttributeName : [UIFont systemFontOfSize:13.0],
                                         NSUnderlineStyleAttributeName :[NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                         NSUnderlineColorAttributeName:[UIColor groupTableViewBackgroundColor]
                                         } range:NSMakeRange(0, recordBtnHighlight.length)];
        
        [_recordBtn setAttributedTitle:recordBtnNormal forState:UIControlStateNormal];
        [_recordBtn setAttributedTitle:recordBtnHighlight forState:UIControlStateHighlighted];
        [_recordBtn sizeToFit];
        [self addSubview:_recordBtn];
    }
    return self;
}

- (void)refreshData:(NIMCommonTableRow *)rowData tableView:(UITableView *)tableView{
    self.textLabel.text = rowData.title;
    self.detailTextLabel.text = rowData.detailTitle;
    NSDictionary *cellInfo = rowData.extraInfo;
    
    BOOL isTeacher = [TELoginManager sharedManager].currentTEUser.type == TEUserTypeTeacher;
    
    if ([cellInfo isKindOfClass:[NSDictionary class]]) {
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[cellInfo objectForKey:@"userAvatar"]]];
        [_userNameLab setText:[cellInfo objectForKey:@"userName"]];
        [_userNameLab sizeToFit];
        NSString *balanceCount = [[cellInfo objectForKey:@"balanceCount"] stringValue];
        NSString *balanceStr = [NSString stringWithFormat:@"%@课时：%@节",isTeacher?@"已授":@"剩余",balanceCount];
        NSMutableAttributedString *balanceAttStr = [[NSMutableAttributedString alloc] initWithString:balanceStr];
        [balanceAttStr addAttributes:@{NSForegroundColorAttributeName:SystemBlueColor} range:NSMakeRange(5, balanceCount.length)];
        [_balanceLab setAttributedText:balanceAttStr];
        [_balanceLab sizeToFit];
        [_recordBtn removeTarget:self.viewController action:NULL forControlEvents:UIControlEventTouchUpInside];
        if ([[cellInfo objectForKey:@"recordAction"] length]) {
            SEL sel = NSSelectorFromString([cellInfo objectForKey:@"recordAction"]);
            [_recordBtn addTarget:tableView.viewController action:sel forControlEvents:UIControlEventTouchUpInside];
        }
        if ([[cellInfo objectForKey:@"rebookAction"] length]) {
            SEL sel = NSSelectorFromString([cellInfo objectForKey:@"rebookAction"]);
            [_rebookBtn addTarget:tableView.viewController action:sel forControlEvents:UIControlEventTouchUpInside];
        }
        if(isTeacher){
//            _balanceLab.hidden = YES;
            _recordBtn.hidden = YES;
            _rebookBtn.hidden = YES;
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.avatarImageView.left = 30.0f;
    self.avatarImageView.centerY = self.height*.5f;
    self.userNameLab.left = self.avatarImageView.right + 20.0f;
    self.userNameLab.top = 20.0f;
    self.balanceLab.left = self.userNameLab.left;
    self.balanceLab.top = self.userNameLab.bottom + 10.0f;
    self.rebookBtn.left = self.userNameLab.left;
    self.rebookBtn.top = self.balanceLab.bottom+10.0f;
    self.rebookBtn.height = 20.0f;
    self.rebookBtn.width = 100.0f;
    self.recordBtn.left = self.rebookBtn.right+10.0f;
    self.recordBtn.bottom = self.rebookBtn.bottom;
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
