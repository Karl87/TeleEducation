//
//  TEMeetingRolesManager.h
//  TeleEducation
//
//  Created by Karl on 2017/3/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "TEMeetingRole.h"
#import "TEService.h"

@protocol TEMeetingRoloseManagerDelegate <NSObject>

@required
//更新教室成员角色
- (void)meetingRolesUpdate;
//成员举手
- (void)meetingMemberRaiseHand;
//允许成员互动
- (void)meetingActorBeenEnabled;
//禁止成员互动
- (void)meetingActorBeenDisabled;
//更新成员音量
- (void)meetingVolumesUpdate;
//教室成员列表更新
- (void)chatroomMembersUpdated:(NSArray*)members entered:(BOOL)entered;

@end

@interface TEMeetingRolesManager : TEService

@property (nonatomic,weak) id<TEMeetingRoloseManagerDelegate> delegate;
@property (nonatomic,copy) NSString *livePushUrl;
@property (nonatomic,copy) NSString *livePlayUrl;

//加入成员
- (void)startNewMeeting:(NIMChatroomMember *)me
           withChatroom:(NIMChatroom *)chatroom
             newCreated:(BOOL)newCreated;
//踢出
- (BOOL)kick:(NSString *)user;
//成员身份
- (TEMeetingRole *)role:(NSString *)user;
//成员身份
- (TEMeetingRole *)memberRole:(NIMChatroomMember *)user;
//我的身份
- (TEMeetingRole *)myRole;
//功能开关
- (void)setMyVideo:(BOOL)on;
- (void)setMyAudio:(BOOL)on;
- (void)setMyWhiteBoard:(BOOL)on;
//全部成员
- (NSArray *)allActorsByName:(BOOL)name;
//举手
- (void)changeRaiseHand;
//更改成员身份
- (void)changeMemberActorRole:(NSString *)user;
//更新信息
- (void)updateMeetingUser:(NSString *)user
                 isJoined:(BOOL)joined;
//更新音量
- (void)updateVolumes:(NSDictionary<NSString *,NSNumber*>*)volumes;

@end
