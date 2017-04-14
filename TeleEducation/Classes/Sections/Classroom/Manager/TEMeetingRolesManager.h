//
//  TEMeetingRolesManager.h
//  TeleEducation
//
//  Created by Karl on 2017/3/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "TEMeetingRole.h"
#import "TEService.h"

@protocol TEMeetingRoloseManagerDelegate <NSObject>

@required

- (void)meetingRolesUpdate;
- (void)meetingMemberRaiseHand;
- (void)meetingActorBeenEnabled;
- (void)meetingActorBeenDisabled;
- (void)meetingVolumesUpdate;
- (void)chatroomMembersUpdated:(NSArray*)members entered:(BOOL)entered;

@end

@interface TEMeetingRolesManager : TEService

@property (nonatomic,weak) id<TEMeetingRoloseManagerDelegate> delegate;
@property (nonatomic,copy) NSString *livePushUrl;
@property (nonatomic,copy) NSString *livePlayUrl;

- (void)startNewMeeting:(NIMChatroomMember *)me
           withChatroom:(NIMChatroom *)chatroom
             newCreated:(BOOL)newCreated;

- (BOOL)kick:(NSString *)user;

- (TEMeetingRole *)role:(NSString *)user;

- (TEMeetingRole *)memberRole:(NIMChatroomMember *)user;

- (TEMeetingRole *)myRole;

- (void)setMyVideo:(BOOL)on;
- (void)setMyAudio:(BOOL)on;
- (void)setMyWhiteBoard:(BOOL)on;

- (NSArray *)allActorsByName:(BOOL)name;

- (void)changeRaiseHand;
- (void)changeMemberActorRole:(NSString *)user;

- (void)updateMeetingUser:(NSString *)user
                 isJoined:(BOOL)joined;

- (void)updateVolumes:(NSDictionary<NSString *,NSNumber*>*)volumes;

@end
