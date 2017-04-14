//
//  TEMeetingNetCallManager.h
//  TeleEducation
//
//  Created by Karl on 2017/3/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEService.h"
#import <Foundation/Foundation.h>

@protocol TEMeetingNetCallManagerDelegate <NSObject>

@required
- (void)onJoinMeetingFailed:(NSString *)name error:(NSError *)error;
- (void)onMeetingConntectStatus:(BOOL)connected;
- (void)onSetBypassStreamingEnabled:(BOOL)enabled error:(NSError *)error;
@end

@interface TEMeetingNetCallManager : TEService
@property (nonatomic,readonly) BOOL isInMeeting;
- (void)joinMeeting:(NSString *)name delegate:(id<TEMeetingNetCallManagerDelegate>)delegate;
- (void)leaveMeeting;
- (BOOL)setBypassLiveSteaming:(BOOL)enabled;
@end
