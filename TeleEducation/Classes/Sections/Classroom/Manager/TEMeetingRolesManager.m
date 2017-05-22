//
//  TEMeetingRolesManager.m
//  TeleEducation
//
//  Created by Karl on 2017/3/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEMeetingRolesManager.h"

#import "TEMeetingRole.h"
#import "TEMeetingMessageHandler.h"
#import "TESessionMsgConverter.h"
#import "TEMeetingControlAttachment.h"
#import "TETimerHolder.h"

#import "NIMAVChat.h"
#import "NSDictionary+TEJson.h"

#import "TELoginManager.h"

@interface TEMeetingRolesManager ()<TEMeetingMessageHandlerDelegate,TETimeHolderDelegate>

@property (nonatomic,strong) NIMChatroom *chatroom; //所属聊天室
@property (nonatomic,strong) NSMutableDictionary *meetingRoles; //聊天室成员
@property (nonatomic,strong) TEMeetingMessageHandler *messageHandler;
@property (nonatomic,assign) BOOL receivedRolesFromManager; //成员信息是否由管理员处同步
@property (nonatomic,strong) NSMutableArray *pendingJoinUsers;//待批准成员

@end

@implementation TEMeetingRolesManager

- (void)startNewMeeting:(NIMChatroomMember *)me withChatroom:(NIMChatroom *)chatroom newCreated:(BOOL)newCreated{
    
    if(_meetingRoles){
        [_meetingRoles removeAllObjects];
    }else{
        _meetingRoles = [NSMutableDictionary dictionary];//初始化本地角色缓存
    }
    if (_pendingJoinUsers) {
        [_pendingJoinUsers removeAllObjects];
    }else{
        _pendingJoinUsers = [NSMutableArray array];//初始化待加入列表
    }
    _chatroom = chatroom;
    [self parseLiveSteamingUrls];
    [self addNewRole:me asActor:YES];//添加自己
    
    _messageHandler = [[TEMeetingMessageHandler alloc] initWithChatroom:chatroom delegate:self];
    
    //获取其他人角色
    [self sendAskForActors];
}

//踢出用户

- (BOOL)kick:(NSString *)user{
    //用户数据存在
    if ([_meetingRoles objectForKey:user]) {
        //移除数据
        [_meetingRoles removeObjectForKey:user];
        //通知更新
        [self notifyMeetingRolesUpdate];
        return YES;
    }
    return NO;
}

- (TEMeetingRole *)role:(NSString *)user{
    return [_meetingRoles objectForKey:user];
}

- (TEMeetingRole *)memberRole:(NIMChatroomMember *)user{
    TEMeetingRole *role = [self role:user.userId];
    if (!role) {
        role = [self addNewRole:user asActor:YES];
    }
    return role;
}

- (TEMeetingRole *)myRole{
    NSString *myUid = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    return [self role:myUid];
}

- (void)setMyVideo:(BOOL)on{
    TEMeetingRole *role = [self myRole];
    if ([[NIMSDK sharedSDK].netCallManager setCameraDisable:!on]) {
        role.videoOn = on;
    }
    [self notifyMeetingRolesUpdate];
}

- (void)setMyAudio:(BOOL)on{
    TEMeetingRole *role = [self myRole];
    if ([[NIMSDK sharedSDK].netCallManager setMute:!on]) {
        role.audioOn = on;
    }
    
    [self notifyMeetingRolesUpdate];
}

- (void)setMyWhiteBoard:(BOOL)on{
    TEMeetingRole *role = [self myRole];
    role.whiteboardOn = on;
    [self notifyMeetingRolesUpdate];
}

- (NSArray *)allActorsByName:(BOOL)name{
    NSMutableArray *actors;
    for (TEMeetingRole *role in _meetingRoles.allValues) {
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

- (void)changeRaiseHand{
    TEMeetingRole *role = [self myRole];
    role.isRaisingHand = !role.isRaisingHand;
    [self sendRaiseHand:role.isRaisingHand];
    [self notifyMeetingRolesUpdate];
}

- (void)changeMemberActorRole:(NSString *)user{
    if (![self recoverActor:user]) {
        TEMeetingRole *role = [_meetingRoles objectForKey:user];
        
        if (!role.isActor && [self exceedMaxActorsNumber]) {
            NSLog(@"Error setting member %@ to actor: Exceeds max actors number.", user);
            return;
        }
        role.isActor = !role.isActor;
        role.isRaisingHand = NO;
        [self notifyMeetingRolesUpdate];
        [self sendControlActor:role.isActor to:user];
        [self sendActorsListBroadcast];
    }
}

- (void)updateMeetingUser:(NSString *)user isJoined:(BOOL)joined
{
    __block TEMeetingRole *role = [_meetingRoles objectForKey:user];
    
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
    for (NSString *meetingUser in _meetingRoles.allKeys) {
        NSNumber *volumeNumber = [volumes objectForKey:meetingUser];
        UInt16 volume = volumeNumber ? volumeNumber.shortValue : 0;
        TEMeetingRole *role = [self role:meetingUser];
        role.audioVolume = volume;
    }
    [self notifyMeetingVolumesUpdate];
}
#pragma mark - TEMeetingMessageHandlerDelegate
- (void)onMembersEnterRoom:(NSArray *)members{
    [self notifyChatroomMembersUpdate:members entered:YES];
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
//            if ([member.userId isEqualToString:_chatroom.creator]) {
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
    [self notifyChatroomMembersUpdate:members entered:NO];
    
    for (NIMChatroomNotificationMember *member in members) {
        TEMeetingRole *role = [self role:member.userId];
        if (role) {
            [_meetingRoles removeObjectForKey:member.userId];
        }
    }
    
//    if ([self myRole].isManager) {
//        BOOL needNotify = NO;
//        for (NIMChatroomNotificationMember *member in members) {
//            TEMeetingRole *role = [self role:member.userId];
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
//            if ([member.userId isEqualToString:_chatroom.creator]) {
//                [self myRole].isRaisingHand = NO;
//            }
//        }
//    }
    [self notifyMeetingRolesUpdate];
}

- (void)onReceiveMeetingCommand:(TEMeetingControlAttachment *)attachment from:(NSString *)userId{
    switch (attachment.command) {
        case CustomMeetingCommandNotifyActorsList:
//            if (![self myRole].isManager) {
//                [self updateRolesFromManager:attachment.uids];
//            }
            break;
        case CustomMeetingCommandAskForActors:
            [self reportActor:userId];
            break;
        case CustomMeetingCommandActorReply:
//            if ([self myRole].isManager) {
//                [self recoverActor:userId];
//            }
//            else if (!_receivedRolesFromManager) {
                [self recoverActor:userId];
//            }
            break;
            
        case CustomMeetingCommandRaiseHand:
//            if ([self myRole].isManager) {
//                [self dealRaiseHandRequest:YES from:userId];
//            }
            break;
            
        case CustomMeetingCommandCancelRaiseHand:
//            if ([self myRole].isManager) {
//                [self dealRaiseHandRequest:NO from:userId];
//            }
            break;
            
        case CustomMeetingCommandEnableActor:
//            [self changeToActor];
            break;
            
        case CustomMeetingCommandDisableActor:
//            [self changeToViewer:YES];
            break;
            
        default:
            break;
    }
}
#pragma mark - TETimerHolder
- (void)onTETimerFired:(TETimerHolder *)holder
{
    if ([self myRole].isManager) {
        [self sendActorsListBroadcast];
    }
    else if (!_receivedRolesFromManager) {
        [self sendAskForActors];
    }
}
#pragma mark - private

- (TEMeetingRole *)addNewRole:(NIMChatroomMember *)info asActor:(BOOL)actor
{
    NSLog(@"Add new role : %@ (%@), is actor : %@", info.roomNickname, info.userId, actor ? @"YES" : @"NO");
    TEMeetingRole *newRole = [[TEMeetingRole alloc] init];
    
    newRole.uid = info.userId;
    newRole.nickName = info.roomNickname;
    newRole.isManager = [TELoginManager sharedManager].currentTEUser.type == TEUserTypeTeacher;//info.type == NIMChatroomMemberTypeCreator;
    newRole.isActor = YES;//newRole.isManager ? YES : actor; //主持人默认都是actor
    newRole.audioOn = YES;
    newRole.videoOn = YES;
    newRole.whiteboardOn = YES;
    
    if ([self.pendingJoinUsers containsObject:info.userId]) {
        newRole.isJoined = YES;
        NSLog(@"Set pending user %@ joined.", newRole.uid);
        [self.pendingJoinUsers removeObject:info.userId];
    }
    
    [_meetingRoles setObject:newRole forKey:info.userId];
    
    [self notifyMeetingRolesUpdate];
    
    return newRole;
}
- (void)changeToActor
{
    if (![self myRole].isActor) {
        [self notifyMeetingActorBeenEnabled];
        [self myRole].isActor = YES;
        [self myRole].isRaisingHand = NO;
        [self myRole].audioOn = NO;
        [self myRole].videoOn = YES;
        [self myRole].whiteboardOn = YES;
        
        [[NIMSDK sharedSDK].netCallManager setMeetingRole:YES];
        [[NIMSDK sharedSDK].netCallManager setMute:![self myRole].audioOn];
        [[NIMSDK sharedSDK].netCallManager setCameraDisable:![self myRole].videoOn];
        
        [self notifyMeetingRolesUpdate];
    }
}
- (void)changeToViewer:(BOOL)cancelRaiseHand
{
    if ([self myRole].isActor) {
        [[NIMSDK sharedSDK].netCallManager setMeetingRole:NO];
        [self myRole].isActor = NO;
        [self notifyMeetingActorBeenDisabled];
    }
    
    if (cancelRaiseHand) {
        [self myRole].isRaisingHand = NO;
    }
    [self myRole].audioOn = NO;
    [self myRole].videoOn = NO;
    [self myRole].whiteboardOn = NO;
    [self notifyMeetingRolesUpdate];
    
}
- (void)reportActor:(NSString *)user
{
    if ([self myRole].isActor) {
        [self sendReportActor:user];
    }
}

- (void)updateRolesFromManager:(NSArray *)actorsMember
{
    _receivedRolesFromManager = YES;
    
    if ([actorsMember containsObject:[self myRole].uid]) {
        [self changeToActor];
    }
    else {
        [self changeToViewer:NO];
    }
    
    for (TEMeetingRole *role in _meetingRoles.allValues) {
        role.isActor = NO;
    }
    
    NSMutableArray *missingUsers = [NSMutableArray array];
    for (NSString *actorId in actorsMember) {
        TEMeetingRole *role = [_meetingRoles objectForKey:actorId];
        if (!role) {
            [missingUsers addObject:actorId];
        }
        else {
            role.isActor = YES;
        }
    }
    
    if (missingUsers.count) {
        
        __weak typeof(self) wself = self;
        
        NIMChatroomMembersHandler handler = ^(NSError *error, NSArray *members){
            if (error) {
                NSLog(@"Error fetching chatroom members by Ids %@", missingUsers);
            }
            else {
                for (NIMChatroomMember *member in members) {
                    [wself addNewRole:member asActor:YES];
                }
            }
        };
        
        [self fetchChatRoomMembers:missingUsers withCompletion:handler];
    }
    
    [self notifyMeetingRolesUpdate];
}

- (void)fetchChatRoomMembers:(NSArray *)members withCompletion:(NIMChatroomMembersHandler)handler
{
    NIMChatroomMembersByIdsRequest *chatroomMemberReq = [[NIMChatroomMembersByIdsRequest alloc] init];
    chatroomMemberReq.roomId = _chatroom.roomId;
    chatroomMemberReq.userIds = members;
    
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:chatroomMemberReq completion:handler];
}

- (BOOL)recoverActor:(NSString *)user
{
    __block TEMeetingRole *role = [_meetingRoles objectForKey:user];
    
    if (!role) {
        __weak typeof(self) wself = self;
        
        NIMChatroomMembersHandler handler = ^(NSError *error, NSArray *members){
            if (error) {
                NSLog(@"Error fetching chatroom members by Ids %@", user);
            }
            else {
                for (NIMChatroomMember *member in members) {
                    role = [wself addNewRole:member asActor:YES];
                    
                    if (![wself exceedMaxActorsNumber]) {
                        role.isActor = YES;
                        [wself notifyMeetingRolesUpdate];
                    }
                    else {
                        NSLog(@"Error setting member %@ to actor: Exceeds max actors number.", user);
                    }
                }
            }
        };
        
        [self fetchChatRoomMembers:@[user] withCompletion:handler];
        return YES;
    }
    return NO;
}

- (TEMeetingControlAttachment *)actorsListAttachment
{
    TEMeetingControlAttachment *attachment = [[TEMeetingControlAttachment alloc] init];
    attachment.command = CustomMeetingCommandNotifyActorsList;
    attachment.uids = [self allActorsByName:NO];
    return attachment;
}

- (void)dealRaiseHandRequest:(BOOL)raise from:(NSString *)user
{
    __block TEMeetingRole *role = [_meetingRoles objectForKey:user];
    
    if (!role) {
        __weak typeof(self) wself = self;
        
        NIMChatroomMembersHandler handler = ^(NSError *error, NSArray *members){
            if (error) {
                NSLog(@"Error fetching chatroom members by Ids %@", user);
            }
            else {
                for (NIMChatroomMember *member in members) {
                    role = [wself addNewRole:member asActor:NO];
                    role.isRaisingHand = raise;
                    [wself notifyMeetingRolesUpdate];
                    if (raise) {
                        [wself notifyMeetingMemberRaiseHand];
                    }
                }
            }
        };
        
        [self fetchChatRoomMembers:@[user] withCompletion:handler];
    }
    else {
        role.isRaisingHand = raise;
        [self notifyMeetingRolesUpdate];
        if (raise) {
            [self notifyMeetingMemberRaiseHand];
        }
    }
}


- (void)notifyMeetingRolesUpdate
{
    if (self.delegate) {
        [self.delegate meetingRolesUpdate];
    }
}

- (void)notifyMeetingMemberRaiseHand
{
    if (self.delegate) {
        [self.delegate meetingMemberRaiseHand];
    }
}

- (void)notifyMeetingActorBeenDisabled
{
    if (self.delegate) {
        [self.delegate meetingActorBeenDisabled];
    }
}

- (void)notifyMeetingActorBeenEnabled
{
    if (self.delegate) {
        [self.delegate meetingActorBeenEnabled];
    }
}

- (void)notifyMeetingVolumesUpdate
{
    if (self.delegate) {
        [self.delegate meetingVolumesUpdate];
    }
}

- (void)notifyChatroomMembersUpdate:(NSArray *)members entered:(BOOL)entered
{
    if (self.delegate) {
        [self.delegate chatroomMembersUpdated:members entered:entered];
    }
}

- (BOOL)exceedMaxActorsNumber
{
    return [self allActorsByName:NO].count >= 4;
}

#pragma mark - send message
- (void)sendRaiseHand:(BOOL)raiseOrCancel
{
    TEMeetingControlAttachment *attachment = [[TEMeetingControlAttachment alloc] init];
    attachment.command = raiseOrCancel ? CustomMeetingCommandRaiseHand : CustomMeetingCommandCancelRaiseHand;
    
    [_messageHandler sendMeetingP2PCommand:attachment to:_chatroom.creator];
}

- (void)sendControlActor:(BOOL)enable to:(NSString *)uid
{
    TEMeetingControlAttachment *attachment = [[TEMeetingControlAttachment alloc] init];
    attachment.command = enable ? CustomMeetingCommandEnableActor : CustomMeetingCommandDisableActor;
    
    [_messageHandler sendMeetingP2PCommand:attachment to:uid];
}

- (void)sendActorsListBroadcast
{
    [_messageHandler sendMeetingBroadcastCommand:[self actorsListAttachment]];
}

- (void)sendAskForActors
{
    TEMeetingControlAttachment *attachment = [[TEMeetingControlAttachment alloc] init];
    attachment.command = CustomMeetingCommandAskForActors;
    
    [_messageHandler sendMeetingBroadcastCommand:attachment];
}

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
    
    if (!(_chatroom) || !(_chatroom.ext)) {
        return;
    }
    
    NSData *data = [_chatroom.ext dataUsingEncoding:NSUTF8StringEncoding];
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
