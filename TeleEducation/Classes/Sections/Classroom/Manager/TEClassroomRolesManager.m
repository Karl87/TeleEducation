//
//  TEClassroomRolesManager.m
//  TeleEducation
//
//  Created by Karl on 2017/5/19.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEClassroomRolesManager.h"
#import "TEMeetingMessageHandler.h"
#import "TESessionMsgConverter.h"
#import "TEMeetingControlAttachment.h"
#import "TETimerHolder.h"
#import "NIMAVChat.h"
#import "NSDictionary+TEJson.h"
#import "TELoginManager.h"

@interface TEClassroomRolesManager ()<TEMeetingMessageHandlerDelegate,TETimeHolderDelegate>
@property (nonatomic,strong) NIMChatroom *classroom; //所属聊天室
@property (nonatomic,strong) NSMutableDictionary *classroomRoles; //聊天室成员
@property (nonatomic,strong) TEMeetingMessageHandler *messageHandler;
@property (nonatomic,strong) NSMutableArray *pendingJoinUsers;//待批准成员
@end


@implementation TEClassroomRolesManager

- (void)enterClassroom:(NIMChatroom *)classroom user:(NIMChatroomMember *)me{
    
    if(_classroomRoles){
        [_classroomRoles removeAllObjects];
    }else{
        _classroomRoles = [NSMutableDictionary dictionary];//初始化本地角色缓存

    }
    
    if (_pendingJoinUsers) {
        [_pendingJoinUsers removeAllObjects];
    }else{
        _pendingJoinUsers = [NSMutableArray array];//初始化待加入列表

    }
    
    _classroom = classroom;
    
    [self addNewRole:me asActor:YES];//添加自己
    
    _messageHandler = [[TEMeetingMessageHandler alloc] initWithChatroom:classroom delegate:self];
    
    //获取其他人角色
    [self sendAskForActors];
    
}

//踢出用户
- (BOOL)kick:(NSString *)user{
    //用户数据存在
    if ([_classroomRoles objectForKey:user]) {
        //移除数据
        [_classroomRoles removeObjectForKey:user];
        //通知更新
        [self notifyMeetingRolesUpdate];
        return YES;
    }
    return NO;
}

//获取本地缓存中某用户角色
- (TEClassroomRole *)role:(NSString *)user{
    return [_classroomRoles objectForKey:user];
}

//查询某用户角色，如角色尚未加入缓存，则将其加入缓存
- (TEClassroomRole *)memberRole:(NIMChatroomMember *)user{
    TEClassroomRole *role = [self role:user.userId];
    if (!role) {
        role = [self addNewRole:user asActor:YES];
    }
    return role;
}

//我的角色
- (TEClassroomRole *)myRole{
    NSString *myUid = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    return [self role:myUid];
}

//我的视频开关
- (void)setMyVideo:(BOOL)on{
    TEClassroomRole *role = [self myRole];
    if ([[NIMSDK sharedSDK].netCallManager setCameraDisable:!on]) {
        role.videoOn = on;
    }
    [self notifyMeetingRolesUpdate];
}
//我的音频开关
- (void)setMyAudio:(BOOL)on{
    TEClassroomRole *role = [self myRole];
    if ([[NIMSDK sharedSDK].netCallManager setMute:!on]) {
        role.audioOn = on;
    }
    
    [self notifyMeetingRolesUpdate];
}
//我的画板开关
- (void)setMyWhiteBoard:(BOOL)on{
    TEClassroomRole *role = [self myRole];
    role.whiteboardOn = on;
    [self notifyMeetingRolesUpdate];
}

//返回本地缓存中全部Actor用户
- (NSArray *)allActorsByName:(BOOL)name{
    NSMutableArray *actors;
    for (TEClassroomRole *role in _classroomRoles.allValues) {
        NSString *actor = name?role.nickName:role.uid;
        if (role.isActor) {
            if (!actors) {
                actors = [[NSMutableArray alloc] initWithObjects:actors, nil];
            }else{
                [actors addObject:actor];
            }
        }
    }
    return actors;
}
//修改成员是否Actor
- (void)changeMemberActorRole:(NSString *)user isActor:(BOOL)actor{
    if([self recoverActor:user]){
        
    }else{
        
    }
}

- (void)changeMemberActorRole:(NSString *)user{
    if (![self recoverActor:user]) {
        TEClassroomRole *role = [_classroomRoles objectForKey:user];
        
        if (!role.isActor && [self exceedMaxActorsNumber]) {
            NSLog(@"Error setting member %@ to actor: Exceeds max actors number.", user);
            return;
        }
        role.isActor = !role.isActor;
        [self notifyMeetingRolesUpdate];
        [self sendControlActor:role.isActor to:user];
        [self sendActorsListBroadcast];
    }
}

- (void)updateClassroomUser:(NSString *)user isJoined:(BOOL)joined
{
    __block TEClassroomRole *role = [_classroomRoles objectForKey:user];
    
    if (!role) {
        __weak typeof(self) wself = self;
        
        NIMChatroomMembersHandler handler = ^(NSError *error, NSArray *members){
            if (error) {
                if (joined) {
                    [wself.pendingJoinUsers addObject:user];
                }
                else {
                    [wself.pendingJoinUsers removeObject:user];
                }
                NSLog(@"Error fetching chatroom members by Ids %@, code %zd", user, error.code);
            }
            else {
                for (NIMChatroomMember *member in members) {
                    role = [wself addNewRole:member asActor:YES];
                    role.isJoined = joined;
                    NSLog(@"Set user %@ joined:%zd", role.uid, role.isJoined);
                    [wself notifyMeetingRolesUpdate];
                }
            }
        };
        
        [self fetchChatRoomMembers:@[user] withCompletion:handler];
    }
    else {
        if (role.isJoined != joined) {
            role.isJoined = joined;
            NSLog(@"Set user %@ joined:%zd", role.uid, role.isJoined);
            if (!joined) {
                role.isActor = NO;
            }
            [self notifyMeetingRolesUpdate];
        }
    }
}

- (void)updateVolumes:(NSDictionary<NSString *, NSNumber *> *)volumes
{
    for (NSString *meetingUser in _classroomRoles.allKeys) {
        NSNumber *volumeNumber = [volumes objectForKey:meetingUser];
        UInt16 volume = volumeNumber ? volumeNumber.shortValue : 0;
        TEClassroomRole *role = [self role:meetingUser];
        role.audioVolume = volume;
    }
    [self notifyMeetingVolumesUpdate];
}

#pragma mark - TEMeetingMessageHandlerDelegate
- (void)onMembersEnterRoom:(NSArray *)members{
    [self notifyClassroomMembersUpdate:members entered:YES];
//    BOOL sendNotify = NO;
//    BOOL managerEnterRoom = NO;
//    
//    for (NIMChatroomNotificationMember *member in members) {
//        if ([self myRole].isManager) {
//            if (![member.userId isEqualToString:[self myRole].uid]) {
//                [_messageHandler sendMeetingP2PCommand:[self actorsListAttachment] to:member.userId];
//                sendNotify = YES;
//            }
//        }
//        else {
//            if ([member.userId isEqualToString:_classroom.creator]) {
//                managerEnterRoom = YES;
//            }
//        }
//    }
//    if (sendNotify) {
        [self notifyMeetingRolesUpdate];
//    }
//    if (managerEnterRoom && [self myRole].isRaisingHand) {
//        [self sendRaiseHand:YES];
//    }
    
}
- (void)onMembersExitRoom:(NSArray *)members{
    [self notifyClassroomMembersUpdate:members entered:NO];
    
    for (NIMChatroomNotificationMember *member in members) {
        TEClassroomRole *role = [self role:member.userId];
        if (role) {
            [_classroomRoles removeObjectForKey:member.userId];
        }
    }
    
    
//    if ([self myRole].isManager) {
//        BOOL needNotify = NO;
//        for (NIMChatroomNotificationMember *member in members) {
//            TEClassroomRole *role = [self role:member.userId];
//            if (role.isActor) {
//                role.isActor = NO;
//                needNotify = YES;
//            }
//        }
//        if (needNotify) {
//            [self sendActorsListBroadcast];
//        }
//    }
//    else {
//        for (NIMChatroomNotificationMember *member in members) {
//            if ([member.userId isEqualToString:_classroom.creator]) {
////                [self myRole].isRaisingHand = NO;
//            }
//        }
//    }
    [self notifyMeetingRolesUpdate];
}

- (void)onReceiveMeetingCommand:(TEMeetingControlAttachment *)attachment from:(NSString *)userId{
    switch (attachment.command) {
        case CustomMeetingCommandNotifyActorsList:
            break;
        case CustomMeetingCommandAskForActors:
            [self reportActor:userId];
            break;
        case CustomMeetingCommandActorReply:
            [self recoverActor:userId];
            break;
            
        case CustomMeetingCommandRaiseHand:
            
            break;
            
        case CustomMeetingCommandCancelRaiseHand:
            
            break;
            
        case CustomMeetingCommandEnableActor:
            break;
            
        case CustomMeetingCommandDisableActor:
            break;
            
        default:
            break;
    }
}

#pragma mark - TETimerHolder
- (void)onTETimerFired:(TETimerHolder *)holder
{
}

#pragma mark - private

- (TEClassroomRole *)addNewRole:(NIMChatroomMember *)info asActor:(BOOL)actor
{
    NSLog(@"添加新成员 : %@ (%@), Actor : %@", info.roomNickname, info.userId, actor ? @"YES" : @"NO");
    TEClassroomRole *newRole = [[TEClassroomRole alloc] init];
    
    newRole.uid = info.userId;
    newRole.nickName = info.roomNickname;
    //只有教室为Manager
    newRole.isManager = [TELoginManager sharedManager].currentTEUser.type == TEUserTypeTeacher;
    newRole.isActor = YES;
    newRole.audioOn = YES;
    newRole.videoOn = YES;
    newRole.whiteboardOn = YES;
    
    if ([self.pendingJoinUsers containsObject:info.userId]) {
        newRole.isJoined = YES;
        NSLog(@"Set pending user %@ joined.", newRole.uid);
        [self.pendingJoinUsers removeObject:info.userId];
    }
    
    [_classroomRoles setObject:newRole forKey:info.userId];
    
    [self notifyMeetingRolesUpdate];
    
    return newRole;
}

- (void)changeToActor
{
    if (![self myRole].isActor) {
        [self notifyMeetingActorBeenEnabled];
        [self myRole].isActor = YES;
        [self myRole].audioOn = NO;
        [self myRole].videoOn = YES;
        [self myRole].whiteboardOn = YES;
        
        [[NIMSDK sharedSDK].netCallManager setMeetingRole:YES];
        [[NIMSDK sharedSDK].netCallManager setMute:![self myRole].audioOn];
        [[NIMSDK sharedSDK].netCallManager setCameraDisable:![self myRole].videoOn];
        
        [self notifyMeetingRolesUpdate];
    }
}

- (void)reportActor:(NSString *)user
{
    if ([self myRole].isActor) {
        [self sendReportActor:user];
    }
}

- (void)fetchChatRoomMembers:(NSArray *)members withCompletion:(NIMChatroomMembersHandler)handler
{
    NIMChatroomMembersByIdsRequest *chatroomMemberReq = [[NIMChatroomMembersByIdsRequest alloc] init];
    chatroomMemberReq.roomId = _classroom.roomId;
    chatroomMemberReq.userIds = members;
    
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:chatroomMemberReq completion:handler];
}


//是否覆盖成员角色信息
- (BOOL)recoverActor:(NSString *)user
{
    __block TEClassroomRole *role = [_classroomRoles objectForKey:user];
    
    //本地缓存中不存在该成员，覆盖
    if (!role) {
        __weak typeof(self) wself = self;
        
        NIMChatroomMembersHandler handler = ^(NSError *error, NSArray *members){
            if (error) {
                NSLog(@"Error fetching chatroom members by Ids %@", user);
            }
            else {
                for (NIMChatroomMember *member in members) {
                    role = [wself addNewRole:member asActor:YES];
                    [wself notifyMeetingRolesUpdate];
                }
            }
        };
        
        [self fetchChatRoomMembers:@[user] withCompletion:handler];
        return YES;
    }
    
    //本地成员中存在该成员，不覆盖
    return NO;
}

- (TEMeetingControlAttachment *)actorsListAttachment
{
    TEMeetingControlAttachment *attachment = [[TEMeetingControlAttachment alloc] init];
    attachment.command = CustomMeetingCommandNotifyActorsList;
    attachment.uids = [self allActorsByName:NO];
    return attachment;
}



- (void)notifyMeetingRolesUpdate
{
    if (self.delegate) {
        [self.delegate classroomRolesUpdate];
    }
}

- (void)notifyMeetingActorBeenDisabled
{
    if (self.delegate) {
        [self.delegate classroomActorBeenDisabled];
    }
}

- (void)notifyMeetingActorBeenEnabled
{
    if (self.delegate) {
        [self.delegate classroomActorBeenEnabled];
    }
}

- (void)notifyMeetingVolumesUpdate
{
    if (self.delegate) {
        [self.delegate classroomVolumesUpdate];
    }
}

- (void)notifyClassroomMembersUpdate:(NSArray *)members entered:(BOOL)entered
{
    if (self.delegate) {
        [self.delegate classroomMembersUpdated:members entered:entered];
    }
}

- (BOOL)exceedMaxActorsNumber
{
    return [self allActorsByName:NO].count >= 4;
}

#pragma mark - send message


//控制用户是否Actor
- (void)sendControlActor:(BOOL)enable to:(NSString *)uid
{
    TEMeetingControlAttachment *attachment = [[TEMeetingControlAttachment alloc] init];
    attachment.command = enable ? CustomMeetingCommandEnableActor : CustomMeetingCommandDisableActor;
    
    [_messageHandler sendMeetingP2PCommand:attachment to:uid];
}

//发送Actor列表广播
- (void)sendActorsListBroadcast
{
    [_messageHandler sendMeetingBroadcastCommand:[self actorsListAttachment]];
}

//发送获取所有Actors的请求
- (void)sendAskForActors
{
    TEMeetingControlAttachment *attachment = [[TEMeetingControlAttachment alloc] init];
    attachment.command = CustomMeetingCommandAskForActors;
    
    [_messageHandler sendMeetingBroadcastCommand:attachment];
}

//发送自己是Actor的点对点信息
- (void)sendReportActor:(NSString *)user
{
    TEMeetingControlAttachment *attachment = [[TEMeetingControlAttachment alloc] init];
    attachment.command = CustomMeetingCommandActorReply;
    attachment.uids = [NSArray arrayWithObjects:[[NIMSDK sharedSDK].loginManager currentAccount], nil];
    [_messageHandler sendMeetingP2PCommand:attachment to:user];
}

- (void)parseLiveSteamingUrls
{
    _livePushUrl = nil;
    _livePlayUrl = nil;
    
    if (!(_classroom) || !(_classroom.ext)) {
        return;
    }
    
    NSData *data = [_classroom.ext dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            
            _livePlayUrl = [dict jsonString:@"webUrl"];
            
            NSDictionary *liveConfig = [dict jsonDict:@"live"];
            if (liveConfig) {
                _livePushUrl = [liveConfig jsonString:@"pushUrl"];
            }
            NSLog(@"live url: \n push = %@ \n play = %@", _livePushUrl, _livePlayUrl);
        }
    }
}
@end
