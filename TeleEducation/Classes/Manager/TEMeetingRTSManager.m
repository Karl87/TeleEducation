//
//  TEMeetingRTSManager.m
//  TeleEducation
//
//  Created by Karl on 2017/3/15.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEMeetingRTSManager.h"
#import "NIMAVChat.h"
#import "TEBundleSetting.h"

#define TERTSConferenceManager [NIMSDK sharedSDK].rtsConferenceManager

@interface  TEMeetingRTSManager ()<NIMRTSConferenceManagerDelegate>
@property (nonatomic,strong) NIMRTSConference *currentConference;
@end

@implementation TEMeetingRTSManager

- (instancetype)init{
    self = [super init];
    if (self) {
        [TERTSConferenceManager addDelegate:self];
    }
    return self;
}

- (void)dealloc{
    [self leaveCurrentConference];
    [TERTSConferenceManager removeDelegate:self];
}

- (NSError *)reserveConference:(NSString *)name
{
    NIMRTSConference *conference = [[NIMRTSConference alloc] init];
    conference.name = name;
    conference.ext = @"test extend rts conference messge";
    return [TERTSConferenceManager reserveConference:conference];
}

- (void)leaveCurrentConference
{
    if (_currentConference) {
        NSError *result = [TERTSConferenceManager leaveConference:_currentConference];
        NSLog(@"leave current conference %@ result %@", _currentConference.name, result);
        _currentConference = nil;
    }
}


- (NSError *)joinConference:(NSString *)name
{
    [self leaveCurrentConference];
    
    NIMRTSConference *conference = [[NIMRTSConference alloc] init];
    conference.name = name;
    conference.serverRecording = [[TEBundleSetting sharedConfig] serverRecordWhiteboardData];
    __weak typeof (self) wself = self;
    conference.dataHandler = ^(NIMRTSConferenceData *data) {
        [wself handleReceivedData:data];
    };
    NSError *result = [TERTSConferenceManager joinConference:conference];
    
    return result;
}

- (BOOL)sendRTSData:(NSData *)data toUser:(NSString *)uid
{
    BOOL accepted;
    
    if (_currentConference) {
        NIMRTSConferenceData *conferenceData = [[NIMRTSConferenceData alloc] init];
        conferenceData.conference = _currentConference;
        conferenceData.data = data;
        conferenceData.uid = uid;
        accepted = [TERTSConferenceManager sendRTSData:conferenceData];
    }
    
    return accepted;
}

- (BOOL)isJoined
{
    return _currentConference != nil;
}


- (void)handleReceivedData:(NIMRTSConferenceData *)data
{
    if (_dataHandler) {
        [_dataHandler handleReceivedData:data.data sender:data.uid];
    }
}

#pragma mark - NIMRTSConferenceManagerDelegate

- (void)onReserveConference:(NIMRTSConference *)conference
                     result:(NSError *)result
{
    NSLog(@"Reserve conference %@ result:%@", conference.name, result);
    
    //本demo使用聊天室id作为了多人实时会话的名称，保证了其唯一性，如果分配时发现已经存在了，认为是该聊天室的主播之前分配的，可以直接使用
    if (result.code == NIMRemoteErrorCodeExist) {
        result = nil;
    }
    
    if (_delegate) {
        [_delegate onReserve:conference.name result:result];
    }
    
}

- (void)onJoinConference:(NIMRTSConference *)conference
                  result:(NSError *)result
{
    NSLog(@"Join conference %@ result:%@", conference.name, result);
    
    if (nil == result || nil == _currentConference) {
        _currentConference = conference;
    }
    
    if (_delegate) {
        [_delegate onJoin:conference.name result:result];
    }
    
}

- (void)onLeftConference:(NIMRTSConference *)conference
                   error:(NSError *)error
{
    NSLog(@"Left conference %@ error:%@", conference.name, error);
    if ([_currentConference.name isEqualToString:conference.name]) {
        _currentConference = nil;
        
        if (_delegate) {
            [_delegate onLeft:conference.name error:error];
        }
    }
}

- (void)onUserJoined:(NSString *)uid
          conference:(NIMRTSConference *)conference
{
    NSLog(@"User %@ joined conference %@", uid, conference.name);
    if ([_currentConference.name isEqualToString:conference.name]) {
        
        if (_delegate) {
            [_delegate onUserJoined:uid conference:conference.name];
        }
    }
    
}

- (void)onUserLeft:(NSString *)uid
        conference:(NIMRTSConference *)conference
            reason:(NIMRTSConferenceUserLeaveReason)reason
{
    NSLog(@"User %@ left conference %@ for %zd", uid, conference.name, reason);
    
    if ([_currentConference.name isEqualToString:conference.name]) {
        if (_delegate) {
            [_delegate onUserLeft:uid conference:conference.name];
        }
    }
}

@end
