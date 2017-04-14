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

#import "TELessonManuView.h"

#import "TEWhiteboardViewController.h"
#import "TEChatroomViewController.h"
#import "TEMembersViewController.h"

@interface TELessonViewController ()<NIMChatroomManagerDelegate,NIMLoginManagerDelegate,TEMeetingRoloseManagerDelegate,TEMeetingNetCallManagerDelegate,TELessonManuViewDelegate,NIMInputDelegate>
@property (nonatomic,copy) NIMChatroom *chatroom;
@property (nonatomic,strong) TEWhiteboardViewController *whitboardViewController;
@property (nonatomic, strong) TEChatroomViewController *chatroomViewController;
@property (nonatomic,strong) TEMembersViewController *membersViewController;

@property (nonatomic,strong) TELessonVideoView *videoView;
@property (nonatomic,strong) UIButton *quitBtn;
@property (nonatomic,strong) TELessonManuView *manuView;
@property (nonatomic,strong) UIView *contentBg;
@end



@implementation TELessonViewController{
    UIView *_contentView;
}

- (void)lessonManuView:(TELessonManuView *)view didSelectedItem:(NSString *)item{
    if ([item isEqualToString:@"exit"]) {
        [self onExit:nil];
    }else if ([item isEqualToString:@"Whiteboard"]){
        _chatroomViewController.view.hidden = YES;
        _whitboardViewController.view.hidden = NO;
        _membersViewController.view.hidden = YES;
    }else if ([item isEqualToString:@"Chat"]){
        _chatroomViewController.view.hidden = NO;
        _whitboardViewController.view.hidden = YES;
        _membersViewController.view.hidden = YES;
    }else if ([item isEqualToString:@"Members"]){
        _chatroomViewController.view.hidden = YES;
        _whitboardViewController.view.hidden = YES;
        _membersViewController.view.hidden = NO;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == self.videoView && [keyPath isEqualToString:@"fullScreen"]) {
        NSLog(@"change");
//        [self.view setNeedsLayout];
    }
}

#pragma mark 横屏处理
//- (BOOL) shouldAutorotateToInterfaceOrientation:
//(UIInterfaceOrientation)toInterfaceOrientation {
//    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
//}
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
    [self.videoView removeObserver:self forKeyPath:@"fullScreen"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.chatroomViewController.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.chatroomViewController.delegate = nil;
    [self revertInputView];
}
- (void)revertInputView
{
    UIView *inputView  = self.chatroomViewController.sessionInputView;
    UIView *revertView;
//    if ([self.currentChildViewController isKindOfClass:[NTESChatroomViewController class]]) {
//        revertView = self.view;
//    }else{
        revertView = self.chatroomViewController.view;
//    }
    CGFloat height = revertView.height;
    [revertView addSubview:inputView];
    inputView.bottom = height;
}
#pragma mark - NIMInputDelegate
- (void)showInputView
{
//    self.keyboradIsShown = YES;
}

- (void)hideInputView
{
//    self.keyboradIsShown = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SystemBlueColor;
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    [[[NIMSDK sharedSDK] chatroomManager] addDelegate:self];
    [[TEMeetingRolesManager sharedService] setDelegate:self];
    [[TEMeetingNetCallManager sharedService] joinMeeting:_chatroom.roomId delegate:self];
    
    [self.view addSubview:self.videoView];
    [self.videoView addObserver:self forKeyPath:@"fullScreen" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    _manuView = [[TELessonManuView alloc] initWithItems:@[@"Whiteboard",@"Chat",@"Members"]];
    _manuView.delegate = self;
    [self.view addSubview:_manuView];
    
    _whitboardViewController = [[TEWhiteboardViewController alloc] initWithChatroom:_chatroom];
    [self addChildViewController:_whitboardViewController];
    [_whitboardViewController didMoveToParentViewController:self];
    
    self.chatroomViewController = [[TEChatroomViewController alloc] initWithChatroom:_chatroom];
    [self addChildViewController:_chatroomViewController];
    [_chatroomViewController didMoveToParentViewController:self];
    
    self.membersViewController = [[TEMembersViewController alloc] initWithChatroom:_chatroom];
    [self addChildViewController:_membersViewController];
    [_membersViewController didMoveToParentViewController:self];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-self.view.frame.size.height/8*3, self.view.height)];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _contentView.clipsToBounds = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    [_contentView.layer setMasksToBounds:YES];
    [_contentView.layer setCornerRadius:8.0];
    [self.view addSubview:_contentView];
    
    [_contentView addSubview:_whitboardViewController.view];
    [_whitboardViewController.view setFrame:CGRectMake(0, 0, _contentView.bounds.size.width, _contentView.bounds.size.height)];
    
    [_contentView addSubview:_chatroomViewController.view];
    [_chatroomViewController.view setFrame:CGRectMake(0, 0, _contentView.bounds.size.width, _contentView.bounds.size.height)];
    
    [_contentView addSubview:_membersViewController.view];
    [_membersViewController.view setFrame:CGRectMake(0, 0, _contentView.bounds.size.width, _contentView.bounds.size.height)];
    
    [self.view bringSubviewToFront:self.videoView];
    [self revertInputView];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定离开教室？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
    [self.whitboardViewController checkPermission];
    [self.membersViewController refresh];
}
- (void)meetingVolumesUpdate{
    [self.membersViewController refresh];
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
