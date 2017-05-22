//
//  TEClassroomRolesManager.h
//  TeleEducation
//
//  Created by Karl on 2017/5/19.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEService.h"
#import "TEClassroomRole.h"

@protocol TEClassroomRoloseManagerDelegate <NSObject>

@required
//更新教室成员角色
- (void)classroomRolesUpdate;
//允许成员互动
- (void)classroomActorBeenEnabled;
//禁止成员互动
- (void)classroomActorBeenDisabled;
//更新成员音量
- (void)classroomVolumesUpdate;
//教室成员列表更新
- (void)classroomMembersUpdated:(NSArray*)members entered:(BOOL)entered;

@end

@interface TEClassroomRolesManager : TEService
@property (nonatomic,weak) id<TEClassroomRoloseManagerDelegate> delegate;
@property (nonatomic,copy) NSString *livePushUrl;
@property (nonatomic,copy) NSString *livePlayUrl;

//加入成员
- (void)startNewMeeting:(NIMChatroomMember *)me
           withChatroom:(NIMChatroom *)chatroom
             newCreated:(BOOL)newCreated;

- (void)enterClassroom:(NIMChatroom *)classroom user:(NIMChatroomMember *)me;

//踢出
- (BOOL)kick:(NSString *)user;
//成员身份
- (TEClassroomRole *)role:(NSString *)user;
//成员身份
- (TEClassroomRole *)memberRole:(NIMChatroomMember *)user;
//我的身份
- (TEClassroomRole *)myRole;
//功能开关
- (void)setMyVideo:(BOOL)on;
- (void)setMyAudio:(BOOL)on;
- (void)setMyWhiteBoard:(BOOL)on;
//全部成员
- (NSArray *)allActorsByName:(BOOL)name;
//更改成员身份
- (void)changeMemberActorRole:(NSString *)user;
//更新信息
- (void)updateClassroomUser:(NSString *)user
                 isJoined:(BOOL)joined;
//更新音量
- (void)updateVolumes:(NSDictionary<NSString *,NSNumber*>*)volumes;

@end
