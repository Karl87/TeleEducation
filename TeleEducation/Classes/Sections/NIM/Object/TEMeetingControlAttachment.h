//
//  TEMeetingControlAttachment.h
//  TeleEducation
//
//  Created by Karl on 2017/3/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TECustomAttachmentDefines.h"

typedef NS_ENUM(NSInteger, CustomMeetingCommand) {
    CustomMeetingCommandNotifyActorsList     = 1,//主持人通知所有有权限发言的用户列表，聊天室消息，需要携带uids
    CustomMeetingCommandAskForActors         = 2,//参与者询问其他人是否有权限发言，聊天室消息
    CustomMeetingCommandActorReply           = 3,//有发言权限的人反馈，点对点消息，需要携带uids
    CustomMeetingCommandRaiseHand            = 10,//参与者向主持人申请发言权限，点对点消息
    CustomMeetingCommandEnableActor          = 11,//主持人开启参与者的发言请求，点对点消息
    CustomMeetingCommandDisableActor         = 12,//主持人关闭某人发言权限，点对点消息
    CustomMeetingCommandCancelRaiseHand      = 13,//参与者向主持人取消申请发言权限，点对点消息
    
    CustomMeetingCommandEnableCamera         = 20,
    CustomMeetingCommandDisableCamera        = 21,
    CustomMeetingCommandEnableMicrophone     = 22,
    CustomMeetingCommandDisableMicrophone    = 23,
    CustomMeetingCommandEnableWhiteboard     = 24,
    CustomMeetingCommandDisableWhiteboard    = 25,
    
};

@interface TEMeetingControlAttachment : NSObject<NIMCustomAttachment>

@property (nonatomic,copy) NSString *roomID;
@property (nonatomic,assign) CustomMeetingCommand command;
@property (nonatomic,strong) NSArray *uids;

@end
