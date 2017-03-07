//
//  TEMeetingManager.m
//  TeleEducation
//
//  Created by Karl on 2017/2/13.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEMeetingManager.h"
#import "NSDictionary+TEJson.h"


@interface TEMeetingManager ()<NIMChatManagerDelegate>
@property (nonatomic,strong) NSMutableDictionary *myInfo;
@end

@implementation TEMeetingManager
- (instancetype)init{
    self = [super init];
    if (self) {
        _myInfo = [[NSMutableDictionary alloc] init];
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
}

-(NIMChatroomMember *)myInfo:(NSString *)roomID{
    NIMChatroomMember *member = _myInfo[roomID];
    return member;
}

-(void)cacheMyInfo:(NIMChatroomMember *)info roomID:(NSString *)roomID{
    [_myInfo setObject:info forKey:roomID];
}

#pragma mark - NIMChatManagerDelegate
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    for (NIMMessage *message in messages) {
        if (message.session.sessionType == NIMSessionTypeChatroom &&message.messageType == NIMMessageTypeNotification) {
            [self dealMessage:message];
        }
    }
}

- (void)dealMessage:(NIMMessage *)message{
    NIMNotificationObject *obj = message.messageObject;
    NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent*)obj.content;
    BOOL containMe = NO;
    for (NIMChatroomMember *member  in content.targets) {
        if ([member.userId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
            containMe = YES;
            break;
        }
    }
    if (containMe) {
        NIMChatroomMember *member = self.myInfo[message.session.sessionId];
        switch (content.eventType) {
            case NIMChatroomEventTypeAddManager:
                member.type = NIMChatroomMemberTypeManager;
                break;
            case NIMChatroomEventTypeRemoveManager:
            case NIMChatroomEventTypeAddCommon:
                member.type = NIMChatroomMemberTypeNormal;
                break;
            case NIMChatroomEventTypeAddMute:
                member.type = NIMChatroomMemberTypeLimit;
                member.isMuted = YES;
                break;
            case NIMChatroomEventTypeRemoveCommon:
                member.type = NIMChatroomMemberTypeGuest;
                break;
            case NIMChatroomEventTypeRemoveMute:
                member.type = NIMChatroomMemberTypeGuest;
                member.isMuted = NO;
            default:
                break;
        }
    }
}
@end
