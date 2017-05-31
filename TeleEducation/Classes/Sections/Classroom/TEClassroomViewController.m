//
//  TEClassroomViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/5/12.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEClassroomViewController.h"
#import "TELesson.h"
#import "TELoginManager.h"
#import "TENIMService.h"
#import "TECommonPostTokenApi.h"
#import "NIMNetCallMeeting.h"
#import "TENIMCreatMeetingTask.h"
#import "TEMeetingManager.h"
#import "TEMeetingRolesManager.h"
#import "NIMAVChat.h"
#import "TEMeetingNetCallManager.h"
#import "TELessonManuView.h"

#import "TEWhiteboardViewController.h"
#import "TEChatroomViewController.h"
#import "TEMembersViewController.h"
#import "TELessonVideoView.h"
#import "TESurfaceMessageViewController.h"

#import "UIAlertView+TEBlock.h"
#import "TENetworkConfig.h"

@interface TEClassroomViewController ()<NIMChatroomManagerDelegate,NIMLoginManagerDelegate,TEMeetingRoloseManagerDelegate,TEMeetingNetCallManagerDelegate,NIMInputDelegate,TELessonManuViewDelegate,TELessonVideoViewDelegate>

@property (nonatomic,strong) TELesson *lesson;
@property (nonatomic,strong) NIMChatroom *chatroom;

@property (nonatomic,strong) TEWhiteboardViewController *whitboardViewController;
@property (nonatomic, strong) TEChatroomViewController *chatroomViewController;
@property (nonatomic,strong) TEMembersViewController *membersViewController;
@property (nonatomic,strong) TESurfaceMessageViewController *surfaceViewController;

@property (nonatomic,strong) TELessonVideoView *videoView;
@property (nonatomic,strong) UIButton *quitBtn;
@property (nonatomic,strong) TELessonManuView *manuView;
@property (nonatomic,strong) UIView *contentBg;
@property (nonatomic, assign) BOOL keyboradIsShown;

@property (nonatomic,copy) NSString *currentTag;

@end

@implementation TEClassroomViewController{
    UIView *_contentView;
}


- (instancetype)initWithLesson:(TELesson *)lesson{
    self = [super init];
    if (self) {
        _lesson = lesson;
    }
    return  self;
}

- (void)initClassroom{
    
    TECommonPostTokenApi *api = [[TECommonPostTokenApi alloc] initWithToken:[TELoginManager sharedManager].currentTEUser.token type:TETokenApiTypeGetNIMID userType:[TELoginManager sharedManager].currentTEUser.type lessonID:_lesson.lessonID];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary *content = [request.responseJSONObject objectForKey:@"content"];
        NSString *nimid = [content objectForKey:@"nimid"];
        
        if (nimid.length) {
            
            //存在教室id 进入教室
            NSLog(@"\n----------\n课程nimID为%@，进入教室\n----------",nimid);
            [self enterChatRoom:nimid];
        }else{
            //流程 - 请求教室、预约教室、进入教室
            NSLog(@"\n----------\n课程nimID为空，请求新的教室\n----------");

            [self requestChatroomWithLesson:[TELoginManager sharedManager].currentTEUser.nimAccount lessonID:_lesson.lessonID];
        }

        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self dismiss];
    }];
    
    
    
}

- (void)setupClassroom{
    [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [[TEMeetingRolesManager sharedService] setDelegate:self];
    [[TEMeetingNetCallManager sharedService] joinMeeting:_chatroom.roomId delegate:self];
    
    self.chatroomViewController = [[TEChatroomViewController alloc] initWithChatroom:_chatroom];
    [self addChildViewController:_chatroomViewController];
    [_chatroomViewController didMoveToParentViewController:self];
    [_contentView addSubview:_chatroomViewController.view];
    [_chatroomViewController.view setFrame:CGRectMake(0, 0, _contentView.bounds.size.width, _contentView.bounds.size.height)];
    _chatroomViewController.view.hidden = YES;
    _chatroomViewController.delegate = self;
    
    self.membersViewController = [[TEMembersViewController alloc] initWithChatroom:_chatroom];
    [self addChildViewController:_membersViewController];
    [_membersViewController didMoveToParentViewController:self];
    [_contentView addSubview:_membersViewController.view];
    [_membersViewController.view setFrame:CGRectMake(0, 0, _contentView.bounds.size.width, _contentView.bounds.size.height)];
    _membersViewController.view.hidden = YES;
    
    self.whitboardViewController = [[TEWhiteboardViewController alloc] initWithChatroom:_chatroom];
    self.whitboardViewController.lessonID = _lesson.lessonID;
    self.whitboardViewController.unitID = _lesson.unitID;
    [self addChildViewController:_whitboardViewController];
    [_whitboardViewController didMoveToParentViewController:self];
    [_contentView addSubview:_whitboardViewController.view];
    [_whitboardViewController.view setFrame:CGRectMake(0, 0, _contentView.bounds.size.width, _contentView.bounds.size.height)];
    _whitboardViewController.view.hidden =NO;
    
    self.surfaceViewController = [[TESurfaceMessageViewController alloc] initWithChatroom:_chatroom];
    [self addChildViewController:_surfaceViewController];
    [_surfaceViewController didMoveToParentViewController:self];
    [self.view addSubview:_surfaceViewController.view];
    [_surfaceViewController.view setFrame:CGRectZero];
    [_surfaceViewController.view setUserInteractionEnabled:NO];
    _surfaceViewController.view.alpha = 0;
    _surfaceViewController.autoShow = YES;
    
    [self revertInputView];
}

- (void)dealloc{
    
    if (_chatroom) {
        [[NIMSDK sharedSDK].chatroomManager exitChatroom:_chatroom.roomId completion:nil];
        [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
        [[TEMeetingNetCallManager sharedService] leaveMeeting];
    }
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.view.backgroundColor = SystemBlueColor;
    
    [self.view addSubview:self.videoView];
    
    _manuView = [[TELessonManuView alloc] initWithItems:@[@"Whiteboard",@"Chat",@"Members"]];
    _manuView.delegate = self;
    [self.view addSubview:_manuView];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-self.view.frame.size.height/8*3, self.view.height)];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _contentView.clipsToBounds = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    [_contentView.layer setMasksToBounds:YES];
    [_contentView.layer setCornerRadius:8.0];
    [self.view addSubview:_contentView];
    
    
    [self.view bringSubviewToFront:self.videoView];
    
    [self initClassroom];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.chatroomViewController.delegate = nil;
    [self revertInputView];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _manuView.left = 0;
    _manuView.top = 0;
    _manuView.width = self.view.width - self.view.height/8*3;
    _manuView.height = 44;
    
    
    if (_videoView.fullScreen == NO) {
        _videoView.left = self.view.width-self.view.height/8*3;
        _videoView.top = 0;
        _videoView.width  =self.view.height/8*3;
        _videoView.height = self.view.height;
    }else{
        _videoView.left = 0;
        _videoView.top = 0;
        _videoView.width  =self.view.width;
        _videoView.height = self.view.height;
    }
    
    
    _contentView.top = 44;
    _contentView.left = 5;
    _contentView.width  =self.view.width-self.view.height/8*3 - 10;
    _contentView.height = self.view.height-_contentView.top - 5;
    
    _surfaceViewController.view.top = 44+ _contentView.height/2;
    _surfaceViewController.view.left = 5;
    _surfaceViewController.view.width  =_contentView.width;
    _surfaceViewController.view.height = _contentView.height/2-50;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark 横屏处理
- (BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark - Getter
- (UIButton *)quitBtn{
    if (!_quitBtn) {
        _quitBtn = [UIButton new];
        [_quitBtn setTitle:@"Exit" forState:UIControlStateNormal];
        
    }
    return _quitBtn;
}
- (TELessonVideoView *)videoView{
    if (!self.isViewLoaded) {
        return nil;
    }
    if (!_videoView) {
        _videoView = [[TELessonVideoView alloc] initWithFrame:self.view.bounds];
        _videoView.delegate = self;
    }
    return _videoView;
}
#pragma mark - NIMInputDelegate
- (void)showInputView
{
    self.keyboradIsShown = YES;
}

- (void)hideInputView
{
    self.keyboradIsShown = NO;
}
#pragma mark - VideoViewDelegate
- (void)videoViewFullScreen:(BOOL)fullscreen{
    
    [_chatroomViewController.sessionInputView endEditing:YES];
    
    if (fullscreen) {
        _surfaceViewController.autoShow = YES;
    }else{
        if ([_currentTag isEqualToString:@"Chat"]) {
            _surfaceViewController.autoShow = NO;
            [_surfaceViewController hide];
        }
    }
    
}
#pragma mark - ManuViewDelegate
- (void)lessonManuView:(TELessonManuView *)view didSelectedItem:(NSString *)item{
    
    [_chatroomViewController.sessionInputView endEditing:YES];
    _currentTag = item;
    
    if ([item isEqualToString:@"exit"]) {
        [self onExit:nil];
    }else if ([item isEqualToString:@"Whiteboard"]){
        _chatroomViewController.view.hidden = YES;
        _whitboardViewController.view.hidden = NO;
        _membersViewController.view.hidden = YES;
        _surfaceViewController.autoShow = YES;
    }else if ([item isEqualToString:@"Chat"]){
        [_chatroomViewController.sessionInputView reset];
        _chatroomViewController.view.hidden = NO;
        _whitboardViewController.view.hidden = YES;
        _membersViewController.view.hidden = YES;
        _surfaceViewController.autoShow = NO;
        [_surfaceViewController hide];
    }else if ([item isEqualToString:@"Members"]){
        _chatroomViewController.view.hidden = YES;
        _whitboardViewController.view.hidden = YES;
        _membersViewController.view.hidden = NO;
        _surfaceViewController.autoShow = YES;
    }
}
#pragma mark - Input
- (void)revertInputView
{
    UIView *inputView  = self.chatroomViewController.sessionInputView;
    UIView *revertView;
    revertView = self.chatroomViewController.view;
    CGFloat height = revertView.height;
    [revertView addSubview:inputView];
    inputView.bottom = height;
}
#pragma mark - Create classroom
- (void)requestChatroomWithLesson:(NSString *)lesson lessonID:(NSInteger)lessonID{
    
    [[TENIMService sharedService] requestMeeting:lesson completion:^(NSError *error, NSString *meetingRoomID) {
        if (!error) {
            NSLog(@"\n----------🎉🎉🎉请求创建教室成功🎉🎉🎉\n教室ID:%@\n----------",meetingRoomID);
            [self reserveNetCallMeeting:meetingRoomID];
            [self updateLessonClassroom:meetingRoomID];
            
        }else{
            NSLog(@"创建教室失败");
        }
    }];
}

- (void)updateLessonClassroom:(NSString *)roomId{
    TECommonPostTokenApi *api = [[TECommonPostTokenApi alloc] initWithToken:[TELoginManager sharedManager].currentTEUser.token type:TETokenApiTypeSetNIMID userType:[TELoginManager sharedManager].currentTEUser.type lessonID:_lesson.lessonID nimID:roomId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSDictionary *dic = request.responseJSONObject;
        NSDictionary *content = dic[@"content"];
        NSInteger status = [content[@"status"] integerValue];
        
        if (status == 1) {
            if([roomId isEqualToString:@""]){
                NSLog(@"清空课程教室信息");
                [self dismiss];
            }else{
                NSLog(@"更新课程教室信息成功,教室编号%@",roomId);
            }
        }else{
            NSLog(@"更新课程教室信息失败");
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            dispatch_async(dispatch_get_main_queue(), ^{
        });
    }];
}

- (void)reserveNetCallMeeting:(NSString *)roomId{
    
    NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
    meeting.name = roomId;
    meeting.type = NIMNetCallTypeVideo;
    meeting.ext = @"text extend meetingmessage";
    
    [[NIMSDK sharedSDK].netCallManager reserveMeeting:meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
        if (!error) {
            NSLog(@"\n----------🎉🎉🎉预约教室成功🎉🎉🎉\n教室ID:%@\n----------",meeting.name);
            [self enterChatRoom:meeting.name];
        }else{
            NSLog(@"\n----------❗️❗️❗️预约教室失败❗️❗️❗️\n教室ID:%@\n失败原因:%ld,%@\n----------",meeting.name,(long)error.code,error.description);
            //417重复操作
            if (error.code == NIMRemoteErrorCodeExist) {
                [self enterChatRoom:meeting.name];
            }else{
            
            }
        }
    }];
}
- (void)enterChatRoom:(NSString *)roomId{
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = roomId;
    request.roomNickname = [TELoginManager sharedManager].currentTEUser.name;
    request.roomAvatar = [[TENetworkConfig sharedConfig].baseURL stringByAppendingString:[TELoginManager sharedManager].currentTEUser.avatar];
    
    [[[NIMSDK sharedSDK] chatroomManager] enterChatroom:request completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
        if (!error) {
            NSString *logStr = [NSString stringWithFormat:@"教室编号:%@\n教室创建者:%@\n我的昵称:%@\n我的头像:%@",chatroom.roomId,chatroom.creator,me.roomNickname,me.roomAvatar];
            LogSuccess(@"加入教室成功", logStr);
            
            _chatroom = chatroom;
            
            [[TEMeetingManager sharedService] cacheMyInfo:me roomID:request.roomId];
            [[TEMeetingRolesManager sharedService] startNewMeeting:me withChatroom:chatroom newCreated:[TELoginManager sharedManager].currentTEUser.type == TEUserTypeTeacher?YES:NO];
            
            [self setupClassroom];
            
        }else{
            NSString* errorDes = [NSString stringWithFormat:@"%ld :%@",error.code,error.description];
            LogError(@"加入教室失败", errorDes);
            //404对象不存在
            
            if (error.code ==NIMRemoteErrorCodeNotExist) {
                _lesson.nimID = nil;
                [self requestChatroomWithLesson:[TELoginManager sharedManager].currentTEUser.nimAccount lessonID:_lesson.lessonID];
            }
        }
    }];
    
}
#pragma mark - NIMChatroomManagerDelegate
- (void)chatroom:(NSString *)roomId beKicked:(NIMChatroomKickReason)reason{
    if ([roomId isEqualToString:self.chatroom.roomId]) {
        if ([_chatroom.creator isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
            NSLog(@"课堂已关闭");
        }else{
            NSString *message;
            switch (reason) {
                case NIMChatroomKickReasonByManager:
                    message = @"被教师踢出";
                    break;
                case NIMChatroomKickReasonInvalidRoom:
                    message = @"教师关闭了课堂";
                    break;
                case NIMChatroomKickReasonByConflictLogin:
                    message =  @"你的账号在其他位置登录";
                    break;
                default:
                    message = @"你已被踢出课堂";
                    break;
            }
            //pop viewcontroller
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
            [alert show];
            [self dismiss];
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
//        [self requestCloseChatroom];
        [self updateLessonClassroom:@""];
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
    [self.whitboardViewController checkPermission];
    [self.membersViewController refresh];
}
- (void)meetingVolumesUpdate{
//    [self.membersViewController refresh];
}
- (void)chatroomMembersUpdated:(NSArray *)members entered:(BOOL)entered{
    [self.membersViewController updateMembers:members entered:entered];
}
- (void)meetingMemberRaiseHand{
    
}
- (void)meetingActorBeenEnabled{
    
}
- (void)meetingActorBeenDisabled{
    
}

#pragma mark -Private
- (void)onExit:(id)sender{
//    if ([[[TEMeetingRolesManager sharedService] myRole] isManager]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定离开教室？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert showAlertWithCompletionHandler:^(NSInteger index) {
//            switch (index) {
//                case 1:{
//                    [self requestCloseChatroom];
//                    [self dismiss];
//                    break;
//                }
//                    
//                default:
//                    break;
//            }
//        }];
//    }
//    else
//    {
//        [self dismiss];
//    }
    if (_membersViewController.members.count == 1) {
        [self updateLessonClassroom:@""];
    }else{
        [self dismiss];
    }
}
- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
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
