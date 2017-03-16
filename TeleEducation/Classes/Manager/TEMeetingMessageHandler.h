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

- (void)onMembersEnterRoom:(NSArray *)members;
- (void)onMembersExitRoom:(NSArray *)members;
- (void)onReceiveMeetingCommand:(TEMeetingControlAttachment *)attachment from:(NSString *)userId;

@end

@interface TEMeetingMessageHandler : NSObject

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom
                        delegate:(id<TEMeetingMessageHandlerDelegate>)delegate;

- (void)sendMeetingP2PCommand:(TEMeetingControlAttachment *)attachment
                           to:(NSString *)uid;

- (void)sendMeetingBroadcastCommand:(TEMeetingControlAttachment *)attachment;

@end
