//
//  TEMeetingManager.h
//  TeleEducation
//
//  Created by Karl on 2017/2/13.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "TEService.h"

@interface TEMeetingManager : TEService
@property (nonatomic,assign) BOOL isMute;
- (NIMChatroomMember *)myInfo:(NSString *)roomID;
- (void)cacheMyInfo:(NIMChatroomMember *)info roomID:(NSString *)roomID;
@end
