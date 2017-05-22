//
//  TEMeetingMessageHandler.h
//  TeleEducation
//
//  Created by Karl on 2017/3/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TEMeetingControlAttachment;
@protocol TEMeetingMessageHandlerDelegate <NSObject>

/**
 用户进入房间时
 **/
- (void)onMembersEnterRoom:(NSArray *)members;
/**
 用户离开房间时
 **/
- (void)onMembersExitRoom:(NSArray *)members;
/**
 接收到其他用户发送的教室命令
 **/
- (void)onReceiveMeetingCommand:(TEMeetingControlAttachment *)attachment from:(NSString *)userId;

@end

//教室信息处理机
@interface TEMeetingMessageHandler : NSObject

//初始化
- (instancetype)initWithChatroom:(NIMChatroom *)chatroom
                        delegate:(id<TEMeetingMessageHandlerDelegate>)delegate;
//发送p2p教室命令
- (void)sendMeetingP2PCommand:(TEMeetingControlAttachment *)attachment
                           to:(NSString *)uid;
//发送广播教室命令
- (void)sendMeetingBroadcastCommand:(TEMeetingControlAttachment *)attachment;

@end
