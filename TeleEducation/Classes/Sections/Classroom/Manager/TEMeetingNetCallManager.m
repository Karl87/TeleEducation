//
//  TEMeetingNetCallManager.m
//  TeleEducation
//
//  Created by Karl on 2017/3/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEMeetingNetCallManager.h"
#import "TEMeetingRolesManager.h"
#import "NIMAVChat.h"
#import "TEBundleSetting.h"

#define TENetcallManager [NIMSDK sharedSDK].netCallManager

@interface TEMeetingNetCallManager ()<NIMNetCallManagerDelegate>{
    UInt16 _myVolume;
}
@property (nonatomic,strong) NIMNetCallMeeting *meeting;
@property (nonatomic,weak) id<TEMeetingNetCallManagerDelegate> delegate;
@end

@implementation TEMeetingNetCallManager
- (void)joinMeeting:(NSString *)name delegate:(id<TEMeetingNetCallManagerDelegate>)delegate{
    if (_meeting) {
        [self leaveMeeting];
    }
    [TENetcallManager addDelegate:self];
    _meeting = [[NIMNetCallMeeting alloc] init];
    _meeting.name = name;
    _meeting.type = NIMNetCallTypeVideo;
    _meeting.actor = [[[TEMeetingRolesManager sharedService] myRole]isActor];
    [self fillNetCallOption:_meeting];
    
    _delegate = delegate;
    
    __weak typeof(self) wself = self;
    
    [[NIMSDK sharedSDK].netCallManager joinMeeting:_meeting completion:^(NIMNetCallMeeting *meeting, NSError *error) {
        if (error) {
            NSLog(@"Join meeting %@error: %zd.", meeting.name, error.code);
            _meeting = nil;
            if (wself.delegate) {
                [wself.delegate onJoinMeetingFailed:meeting.name error:error];
            }
        }
        else {
            NSLog(@"Join meeting %@ success, ext:%@", meeting.name, meeting.ext);
            _isInMeeting = YES;
            TEMeetingRole *myRole = [TEMeetingRolesManager sharedService].myRole;
            NSLog(@"Reset mute:%d, camera disable:%d",!myRole.audioOn,!myRole.videoOn);
            [TENetcallManager setMute:!myRole.audioOn];
            [TENetcallManager setCameraDisable:!myRole.videoOn];
            
            if (wself.delegate) {
                [wself.delegate onMeetingConntectStatus:YES];
            }
            NSString *myUid = [TEMeetingRolesManager sharedService].myRole.uid;
            NSLog(@"Joined meeting.");
            [[TEMeetingRolesManager sharedService] updateMeetingUser:myUid
                                                               isJoined:YES];
        }
    }];
}
- (void)leaveMeeting
{
    if (_meeting) {
        [TENetcallManager leaveMeeting:_meeting];
        _meeting = nil;
    }
    [TENetcallManager removeDelegate:self];
    _isInMeeting = NO;
}

- (BOOL)setBypassLiveStreaming:(BOOL)enabled
{
    return [TENetcallManager setBypassStreamingEnabled:enabled];
}
#pragma mark - NIMNetCallManagerDelegate
- (void)onUserJoined:(NSString *)uid
             meeting:(NIMNetCallMeeting *)meeting
{
    NSLog(@"user %@ joined meeting", uid);
    if ([meeting.name isEqualToString:_meeting.name]) {
        [[TEMeetingRolesManager sharedService] updateMeetingUser:uid isJoined:YES];
    }
}

- (void)onUserLeft:(NSString *)uid
           meeting:(NIMNetCallMeeting *)meeting
{
    NSLog(@"user %@ left meeting", uid);
    
    if ([meeting.name isEqualToString:_meeting.name]) {
        [[TEMeetingRolesManager sharedService] updateMeetingUser:uid isJoined:NO];
    }
}

- (void)onMeetingError:(NSError *)error
               meeting:(NIMNetCallMeeting *)meeting
{
    NSLog(@"meeting error %zd", error.code);
    _isInMeeting = NO;
    [_delegate onMeetingConntectStatus:NO];
}



- (void)onMyVolumeUpdate:(UInt16)volume
{
    _myVolume = volume;
}

- (void)onSpeakingUsersReport:(nullable NSArray<NIMNetCallUserInfo *> *)report
{
    NSString *myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
    
    NSMutableDictionary *volumes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[self volumeLevel:_myVolume], myUid, nil];
    
    for (NIMNetCallUserInfo *info in report) {
        [volumes setObject:[self volumeLevel:info.volume] forKey:info.uid];
    }
    
    [[TEMeetingRolesManager sharedService] updateVolumes:volumes];
}

- (void)onSetBypassStreamingEnabled:(BOOL)enabled result:(NSError *)result
{
    if (result) {
        if (self.delegate) {
            [self.delegate onSetBypassStreamingEnabled:enabled error:result];
        }
    }
}

- (void)onNetStatus:(NIMNetCallNetStatus)status user:(NSString *)user
{
    NSLog(@"Net status of %@ is %zd", user, status);
}
#pragma mark - private
- (void)fillNetCallOption:(NIMNetCallMeeting *)meeting
{
    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
    
    option.disableVideoCropping = ![[TEBundleSetting sharedConfig] videochatAutoCropping];
    option.autoRotateRemoteVideo = [[TEBundleSetting sharedConfig] videochatAutoRotateRemoteVideo];
    option.serverRecordAudio     = [[TEBundleSetting sharedConfig] serverRecordAudio];
    option.serverRecordVideo     = [[TEBundleSetting sharedConfig] serverRecordVideo];
    option.preferredVideoEncoder = [[TEBundleSetting sharedConfig] perferredVideoEncoder];
    option.preferredVideoDecoder = [[TEBundleSetting sharedConfig] perferredVideoDecoder];
    option.videoMaxEncodeBitrate = [[TEBundleSetting sharedConfig] videoMaxEncodeKbps] * 1000;
    option.startWithBackCamera   = [[TEBundleSetting sharedConfig] startWithBackCamera];
    option.autoDeactivateAudioSession = [[TEBundleSetting sharedConfig] autoDeactivateAudioSession];
    option.audioDenoise = [[TEBundleSetting sharedConfig] audioDenoise];
    option.voiceDetect = [[TEBundleSetting sharedConfig] voiceDetect];
    option.preferredVideoQuality = [[TEBundleSetting sharedConfig] preferredVideoQuality];
    option.bypassStreamingVideoMixMode = [[TEBundleSetting sharedConfig] bypassVideoMixMode];
    
    BOOL isManager = [TEMeetingRolesManager sharedService].myRole.isManager;
    
    //会议的观众这里默认用低清发送视频
    if (option.preferredVideoQuality == NIMNetCallVideoQualityDefault) {
        if (!isManager) {
            option.preferredVideoQuality = NIMNetCallVideoQualityDefault;
        }
    }
    
    option.bypassStreamingUrl = isManager ? [[TEMeetingRolesManager sharedService] livePushUrl] : nil;
    option.enableBypassStreaming = isManager;
    
    _meeting.option = option;
}


-(NSNumber *)volumeLevel:(UInt16)volume
{
    int32_t volumeLevel = 0;
    volume /= 40;
    while (volume > 0) {
        volumeLevel ++;
        volume /= 2;
    }
    if (volumeLevel > 8) volumeLevel = 8;
    
    return @(volumeLevel);
}

@end
