//
//  TELessonViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/3/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TELessonViewController.h"
#import "TEMeetingRolesManager.h"
#import "TEMeetingNetCallManager.h"
#import "TELessonVideoView.h"
#import "TENIMService.h"
#import "UIAlertView+TEBlock.h"

@interface TELessonViewController ()<NIMChatroomManagerDelegate,NIMLoginManagerDelegate,TEMeetingRoloseManagerDelegate,TEMeetingNetCallManagerDelegate>
@property (nonatomic,copy) NIMChatroom *chatroom;
@property (nonatomic,strong) TELessonVideoView *videoView;
@property (nonatomic,strong) UIButton *quitBtn;
@end



@implementation TELessonViewController

- (instancetype)initWithNIMChatroom:(NIMChatroom *)room{
    self = [super init];
    if (self) {
        _chatroom = room;
    }
    return self;
}
- (void)dealloc{
    [[[NIMSDK sharedSDK] chatroomManager] exitChatroom:_chatroom.roomId completion:nil];
    [[[NIMSDK sharedSDK] chatroomManager] removeDelegate:self];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[TEMeetingNetCallManager sharedService] leaveMeeting];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    [[[NIMSDK sharedSDK] chatroomManager] addDelegate:self];
    [[TEMeetingRolesManager sharedService] setDelegate:self];
    [[TEMeetingNetCallManager sharedService] joinMeeting:_chatroom.roomId delegate:self];
    
    [self.view addSubview:self.videoView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIButton *)quitBtn{
    if (!_quitBtn) {
        _quitBtn = [UIButton new];
        [_quitBtn setTitle:@"Exit" forState:UIControlStateNormal];
        
    }
    return _quitBtn;
}
- (void)onExit:(id)sender{
    if ([[[TEMeetingRolesManager sharedService] myRole] isManager]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定结束会议？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert showAlertWithCompletionHandler:^(NSInteger index) {
            switch (index) {
                case 1:{
                    [self requestCloseChatroom];
                    [self dismiss];
                    break;
                }
                    
                default:
                    break;
            }
        }];
    }
    else
    {
        [self dismiss];
    }

}
- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (TELessonVideoView *)videoView{
    if (!self.isViewLoaded) {
        return nil;
    }
    if (!_videoView) {
        _videoView = [[TELessonVideoView alloc] initWithFrame:self.view.bounds];
    }
    return _videoView;
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _videoView.left = 0;
    _videoView.top = 0;
    _videoView.width  =self.view.width;
    _videoView.height = self.view.height;
}

#pragma mark - NIMChatroomManagerDelegate
- (void)chatroom:(NSString *)roomId beKicked:(NIMChatroomKickReason)reason{
    if ([roomId isEqualToString:self.chatroom.roomId]) {
        if ([_chatroom.creator isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
            NSLog(@"课堂已关闭");
        }else{
            switch (reason) {
                case NIMChatroomKickReasonByManager:
                    NSLog(@"被教师踢出");
                    break;
                case NIMChatroomKickReasonInvalidRoom:
                    NSLog(@"教师关闭了课堂");
                    break;
                case NIMChatroomKickReasonByConflictLogin:
                    NSLog(@"你的账号在其他位置登录");
                    break;
                default:
                    NSLog(@"你已被踢出课堂");
                    break;
            }
            //pop viewcontroller
        }
    }
}

- (void)onLogin:(NIMLoginStep)step{
    if (step == NIMLoginStepLoginOK) {
        if (![[TEMeetingNetCallManager sharedService] isInMeeting]) {
            NSLog(@"重新登录成功，回到课堂");
            [[TEMeetingNetCallManager sharedService] joinMeeting:_chatroom.roomId delegate:self];
        }
    }
}

- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state{
    NSLog(@"chatroom connectionStateChanged roomId : %@  state:%zd",roomId,state);

}

#pragma mark - TEMeetingNetCallManagerDelegate
- (void)onJoinMeetingFailed:(NSString *)name error:(NSError *)error{
    if ([[TEMeetingRolesManager sharedService].myRole isManager]) {
        [self requestCloseChatroom];
    }
}
- (void)onMeetingConntectStatus:(BOOL)connected{
    NSLog(@"Meeting %@ ...", connected ? @"connected" : @"disconnected");
    if (connected) {
    }
    else {
        [self.videoView stopLocalPreview];
    }
}
- (void)onSetBypassStreamingEnabled:(BOOL)enabled error:(NSError*)error{
    NSLog(@"Set bypass enabled %d error %zd", enabled, error.code);
    
}
#pragma mark - TEMeetingRolesManagerDelegate
- (void)meetingRolesUpdate{
    [self.videoView updateActors];
}
- (void)meetingVolumesUpdate{
    
}
- (void)chatroomMembersUpdated:(NSArray *)members entered:(BOOL)entered{
    
}
- (void)meetingMemberRaiseHand{
    
}
- (void)meetingActorBeenEnabled{
    
}
- (void)meetingActorBeenDisabled{
    
}
#pragma mark - Private
- (void)requestCloseChatroom{
    [[TENIMService sharedService] closeMeeting:_chatroom.roomId creator:_chatroom.creator completion:^(NSError *error, NSString *roomId) {
        if (error) {
            NSLog(@"关闭课堂失败");
        }else{
            NSLog(@"关闭课堂成功");
        }
    }];
}
@end
