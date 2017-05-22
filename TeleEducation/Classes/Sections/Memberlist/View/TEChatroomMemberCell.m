//
//  TEChatroomMemberCell.m
//  TeleEducation
//
//  Created by Karl on 2017/4/13.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEChatroomMemberCell.h"
#import "UIImageView+WebCache.h"
#import "TEDataManager.h"
#import "TEMeetingRolesManager.h"
#import "UIAlertView+TEBlock.h"
#import "TENetworkConfig.h"

@interface TEChatroomMemberCell ()

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UIImageView *roleImageView;
@property (nonatomic,strong) UIButton *selfAudioButton;
@property (nonatomic,strong) UIButton *selfVideoButton;
@property (nonatomic,strong) UIButton *selfWhiteboardButton;
@property (nonatomic,strong) UIButton *meetingRoleButton;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) UIImageView *volumeImageView;
@property (nonatomic,strong) UILabel *meetingRoleLabel;

@end

@implementation TEChatroomMemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.avatarImageView];
        [self addSubview:self.volumeImageView];
        [self addSubview:self.roleImageView];
        [self addSubview:self.meetingRoleButton];
        [self addSubview:self.meetingRoleLabel];
    }
    return self;
}

- (void)refresh:(NIMChatroomMember *)member{
    
    NSLog(@"%@\n%@\n%@\n%@",member.userId,member.roomNickname,member.roomAvatar,member.roomExt);
    
    NSString *avater = member.roomAvatar;
    
    if ([member.roomAvatar hasPrefix:@"https://"]) {
        avater = [member.roomAvatar stringByReplacingOccurrencesOfString:@"https://" withString:@"http://"];
    }
    
    self.userId = member.userId;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avater] placeholderImage:[TEDataManager sharedManager].defaultUserAvatar];
    self.textLabel.text = member.roomNickname;
    [self.textLabel sizeToFit];
    [self refreshRole:member];
}

- (void)refreshRole:(NIMChatroomMember *)member{
    TEMeetingRole *role = [[TEMeetingRolesManager sharedService] memberRole:member];
    self.textLabel.textColor = role.isJoined?[UIColor blackColor]:[UIColor grayColor];
    switch (member.type) {
        case NIMChatroomMemberTypeCreator:
            self.roleImageView.hidden = NO;
            [self.roleImageView setImage:[UIImage imageNamed:@"meeting_manager"]];
            break;
        case NIMChatroomMemberTypeManager:
            self.roleImageView.hidden = NO;
            [self.roleImageView setImage:[UIImage imageNamed:@"meeting_manager"]];
            break;
        case NIMChatroomMemberTypeNormal:
            self.roleImageView.hidden = YES;
            break;
        default:
            self.roleImageView.hidden = YES;
            break;
    }
    BOOL selfIsManager = [TEMeetingRolesManager sharedService].myRole.isManager;
    if ([member.userId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]] &&selfIsManager) {
        [self.meetingRoleLabel setHidden:YES];
        [self.meetingRoleButton setHidden:YES];
    }else{
        if (selfIsManager) {
            TEMeetingRole * mRole = [[TEMeetingRolesManager sharedService] role:member.userId];
            [self.meetingRoleLabel setHidden:YES];
            if (mRole.isActor) {
                self.meetingRoleButton.hidden = NO;
                self.meetingRoleButton.backgroundColor = UIColorFromRGB(0x1e77f9);
                [self.meetingRoleButton setTitle:@"结束互动" forState:UIControlStateNormal];
            }
            else if (mRole.isRaisingHand) {
                self.meetingRoleButton.hidden = NO;
                self.meetingRoleButton.backgroundColor = UIColorFromRGB(0x7dd21f);
                [self.meetingRoleButton setTitle:@"允许互动" forState:UIControlStateNormal];
                
            }
            else {
                self.meetingRoleButton.hidden = YES;
            }

        }else{
            TEMeetingRole *sRole = [[TEMeetingRolesManager sharedService] role:member.userId];
            self.meetingRoleButton.hidden = YES;
            if (sRole.isActor) {
                
                self.meetingRoleLabel.hidden = NO;
                [self.meetingRoleLabel setText:@"互动中"];
            }
            else {
                self.meetingRoleLabel.hidden = YES;
                
            }
        }
    }
    NSString *volumeImageName = [NSString stringWithFormat:@"volume%@", @(role.audioVolume)];
    
    [self.volumeImageView setImage:[UIImage imageNamed:volumeImageName]];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat spacing = 10.f;
    self.roleImageView.left      = spacing;
    self.roleImageView.centerY   = self.height * .5f;
    self.roleImageView.width     = 20;
    self.roleImageView.height    = 20;
    
    self.avatarImageView.left    = self.roleImageView.right + spacing;
    self.avatarImageView.centerY = self.height * .5f;
    self.volumeImageView.center = self.avatarImageView.center;
    self.textLabel.left          = self.avatarImageView.right + spacing;
    self.textLabel.centerY       = self.height * .5f;
    
    spacing = 15.f;
    
    self.meetingRoleButton.right   = self.right - spacing;
    self.meetingRoleButton.centerY   = self.height * .5f;
    
    self.meetingRoleLabel.right   = self.right - spacing;
    self.meetingRoleLabel.centerY   = self.height * .5f;
}
#pragma mark - Get
- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        [_avatarImageView.layer setMasksToBounds:YES];
        [_avatarImageView.layer setCornerRadius:_avatarImageView.height/2];
    }
    return _avatarImageView;
}

- (UIImageView *)volumeImageView
{
    if (!_volumeImageView) {
        _volumeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        [_volumeImageView setImage:[UIImage imageNamed:@"volume5"]];
    }
    return _volumeImageView;
}

- (UIImageView *)roleImageView
{
    if (!_roleImageView) {
        _roleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _roleImageView;
}

- (UIButton *)selfAudioButton
{
    if (!_selfAudioButton) {
        _selfAudioButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_selfAudioButton addTarget:self action:@selector(onSelfAudioPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selfAudioButton;
}

- (UIButton *)selfVideoButton
{
    if (!_selfVideoButton) {
        _selfVideoButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_selfVideoButton addTarget:self action:@selector(onSelfVideoPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selfVideoButton;
}

- (UIButton *)selfWhiteboardButton
{
    if (!_selfWhiteboardButton) {
        _selfWhiteboardButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_selfWhiteboardButton addTarget:self action:@selector(onSelfWhiteboardPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selfWhiteboardButton;
}


- (UIButton *)meetingRoleButton
{
    if (!_meetingRoleButton) {
        _meetingRoleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75.f, 30.f)];
        _meetingRoleButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _meetingRoleButton.titleLabel.textColor = UIColorFromRGB(0xffffff);
        [_meetingRoleButton addTarget:self action:@selector(onMeetingRolePressed:) forControlEvents:UIControlEventTouchUpInside];
        _meetingRoleButton.layer.cornerRadius = 5.f;
    }
    return _meetingRoleButton;
}

-(UILabel *)meetingRoleLabel
{
    if (!_meetingRoleLabel) {
        _meetingRoleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 75.f, 30.f)];
        _meetingRoleLabel.font = [UIFont systemFontOfSize:13];
        _meetingRoleLabel.textAlignment = NSTextAlignmentCenter;
        _meetingRoleLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _meetingRoleLabel;
    
}
- (void)onSelfVideoPressed:(id)sender
{
    BOOL videoIsOn = [TEMeetingRolesManager sharedService].myRole.videoOn;
    
    [[TEMeetingRolesManager sharedService] setMyVideo:!videoIsOn];
}

- (void)onSelfAudioPressed:(id)sender
{
    BOOL audioIsOn = [TEMeetingRolesManager sharedService].myRole.audioOn;
    
    [[TEMeetingRolesManager sharedService] setMyAudio:!audioIsOn];
}

- (void)onSelfWhiteboardPressed:(id)sender
{
    BOOL whiteboardIsOn = [TEMeetingRolesManager sharedService].myRole.whiteboardOn;
    
    [[TEMeetingRolesManager sharedService] setMyWhiteBoard:!whiteboardIsOn];
    
}

- (void)onMeetingRolePressed:(id)sender
{
    TEMeetingRole *role = [[TEMeetingRolesManager sharedService] role:_userId];
    if (role.isActor) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定撤销该用户的互动权限？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert showAlertWithCompletionHandler:^(NSInteger index) {
            switch (index) {
                case 1:{
                    [[TEMeetingRolesManager sharedService] changeMemberActorRole:_userId];
                    break;
                }
                default:
                    break;
            }
        }];
    }
    else {
        [[TEMeetingRolesManager sharedService] changeMemberActorRole:_userId];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
