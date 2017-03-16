//
//  TEMeetingMessageHandler.m
//  TeleEducation
//
//  Created by Karl on 2017/3/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEMeetingMessageHandler.h"
#import "TEMeetingControlAttachment.h"
#import "NSDictionary+TEJson.h"
#import "TESessionMsgConverter.h"

@interface TEMeetingMessageHandler ()<NIMChatManagerDelegate,NIMSystemNotificationManagerDelegate>
@property (nonatomic,strong) NIMChatroom *chatroom;
@property (nonatomic,weak) id<TEMeetingMessageHandlerDelegate>delegate;
@end

@implementation TEMeetingMessageHandler

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom delegate:(id<TEMeetingMessageHandlerDelegate>)delegate{
    self = [super init];
    if (self) {
        _chatroom = chatroom;
        _delegate = delegate;
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    }
    return self;
}

- (void)dealloc{
    [[[NIMSDK sharedSDK] chatManager] removeDelegate:self];
    [[[NIMSDK sharedSDK] systemNotificationManager] removeDelegate:self];
}

#pragma mark - NIMChatManagerDelegate
- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    for (NIMMessage *msg  in messages) {
        if (msg.session.sessionType == NIMSessionTypeChatroom) {
            if (msg.messageType == NIMMessageTypeCustom) {
                [self dealCustomMessage:msg];
            }else if (msg.messageType == NIMMessageTypeNotification){
                [self dealNotificationMessage:msg];
            }
        }
    }
}
- (void)dealCustomMessage:(NIMMessage *)message{
    NIMCustomObject *obj = message.messageObject;
    if (![obj.attachment isKindOfClass:[TEMeetingControlAttachment class]]) {
        return;
    }
    TEMeetingControlAttachment *attachment = (TEMeetingControlAttachment *)obj.attachment;
    if ([attachment.roomID isEqualToString:_chatroom.roomId]) {
        [self onMeetingCommand:attachment from:message.from];
    }else{
        NSLog(@"Receive chatroom command from another meeting %@, drop it.", attachment.roomID);
    }
}
- (void)dealNotificationMessage:(NIMMessage *)message{
    NIMNotificationObject *obj = message.messageObject;
    if (obj.notificationType !=NIMNotificationTypeChatroom) {
        return;
    }
    NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)obj.content;
    switch (content.eventType) {
        case NIMChatroomEventTypeEnter:
            [_delegate onMembersEnterRoom:content.targets];
            break;
        case NIMChatroomEventTypeExit:
            [_delegate onMembersExitRoom:content.targets];
            break;
        default:
            break;
    }
}
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
    if (notification.receiver == NIMSessionTypeP2P) {
        NSString *content = notification.content;
        NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
        if (jsonData) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:0 error:nil];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                if ([dic jsonInteger:CMType] == CustomMessageTypeMeetingControl) {
                    NSDictionary *data = [dic jsonDict:CMData];
                    TEMeetingControlAttachment *attachment = [[TEMeetingControlAttachment alloc] init];
                    attachment.roomID = [data jsonString:CMRoomID];
                    attachment.command = [data jsonInteger:CMCommand];
                    attachment.uids = [data jsonArray:CMUIDs];
                    if ([attachment.roomID isEqualToString:_chatroom.roomId]) {
                        [self onMeetingCommand:attachment from:notification.sender];
                    }else{
                        NSLog(@"Receive p2p command from another meeting %@, drop it.", attachment.roomID);
                    }
                }
            }
        }
    }
}

- (void)onMeetingCommand:(TEMeetingControlAttachment *)attachment from:(NSString *)from{
    if (![attachment.roomID isEqualToString:_chatroom.roomId]) {
        return;
    }
    NSLog(@"Receive meeting command from %@, attachment [ %@ ]", from, attachment);
    [_delegate onReceiveMeetingCommand:attachment from:from];
}

- (void)sendMeetingP2PCommand:(TEMeetingControlAttachment *)attachment to:(NSString *)uid{
    attachment.roomID = _chatroom.roomId;
    
    NSLog(@"Send meeting p2p command to %@, attachment [ %@ ]", uid, attachment);
    
    NSString *content = [attachment encodeAttachment];
    
    NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
    notification.sendToOnlineUsersOnly = YES;
    NIMCustomSystemNotificationSetting *setting = [[NIMCustomSystemNotificationSetting alloc] init];
    setting.shouldBeCounted = NO;
    setting.apnsEnabled = NO;
    notification.setting = setting;
    [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification
                                                               toSession:[NIMSession session:uid type:NIMSessionTypeP2P]
                                                              completion:^(NSError *error) {
                                                                  if (error) {
                                                                      NSLog(@"sendMeetingP2PCommand error:%zd",error.code);
                                                                  }
                                                              }];

}
- (void)sendMeetingBroadcastCommand:(TEMeetingControlAttachment *)attachment{
    attachment.roomID = _chatroom.roomId;
    
    NSLog(@"Send meeting broadcast command, attachment [ %@ ]", attachment);
    
    NIMMessage *message = [TESessionMsgConverter msgWithMeetingControlAttachment:attachment];
    
    [[NIMSDK sharedSDK].chatManager sendMessage:message
                                      toSession:[NIMSession session:_chatroom.roomId type:NIMSessionTypeChatroom]
                                          error:nil];
}
@end
