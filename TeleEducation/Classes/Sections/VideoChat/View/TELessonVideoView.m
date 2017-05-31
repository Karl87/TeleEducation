//
//  TELessonVideoView.m
//  TeleEducation
//
//  Created by Karl on 2017/3/13.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TELessonVideoView.h"
#import "TEMeetingRolesManager.h"
#import "TEGLView.h"
#import "NIMAVChat.h"
#import "MBProgressHUD.h"

@interface TELessonVideoView ()<NIMNetCallManagerDelegate>
@property (nonatomic,strong) UIImageView *selfBg;
@property (nonatomic,strong) TEGLView *selfVideo;
@property (nonatomic, weak) CALayer *localVideoLayer;
@property (nonatomic,strong) UIImageView *otherBg;
@property (nonatomic,strong) TEGLView *otherVideo;
@property (nonatomic,strong) NSMutableArray *actors;
@property (nonatomic,strong) UIButton *sizeModeBtn;
@property (nonatomic,strong) UIButton *muteBtn;
@property (nonatomic,strong) UIButton *cameraBtn;
@property (nonatomic,strong) UIButton *directionBtn;
@property (nonatomic,assign) BOOL isFrontCamera;
@end

@implementation TELessonVideoView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _fullScreen = NO;
        _isFrontCamera = YES;
//        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        
        _selfBg = [[UIImageView alloc] init];
        [_selfBg setImage:[UIImage imageNamed:@"videoBackground"]];
        [_selfBg setContentMode:UIViewContentModeCenter];
        _selfBg.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_selfBg];
        
        _otherBg = [[UIImageView alloc] init];
        [_otherBg setImage:[UIImage imageNamed:@"videoBackground"]];
        [_otherBg setContentMode:UIViewContentModeCenter];
        _otherBg.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_otherBg];
        
        _otherVideo = [[TEGLView alloc] initWithFrame:self.bounds];
//        [_otherVideo setBackgroundColor:[UIColor darkGrayColor]];
        _otherVideo.contentMode = UIViewContentModeScaleAspectFill;
        [_otherVideo render:nil width:0 height:0];
        [self addSubview:_otherVideo];
        
        _selfVideo = [[TEGLView alloc] initWithFrame:self.bounds];
//        [_selfVideo setBackgroundColor:[UIColor darkGrayColor]];
        _selfVideo.contentMode = UIViewContentModeScaleAspectFill;
        [_selfVideo render:nil width:0 height:0];
        [self addSubview:_selfVideo];
        
        _sizeModeBtn = [UIButton new];
        [_sizeModeBtn setBackgroundImage:[UIImage imageNamed:@"chatroom_video_normalsize"] forState:UIControlStateNormal];
        [_sizeModeBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sizeModeBtn];
        
        
        _muteBtn = [UIButton new];
//        [_muteBtn setTitle:@"静" forState:UIControlStateNormal];
        [_muteBtn setBackgroundImage:[UIImage imageNamed:@"chatroom_audio_off"] forState:UIControlStateNormal];
        [_muteBtn addTarget:self action:@selector(muteAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_muteBtn];
        
        _cameraBtn = [UIButton new];
//        [_cameraBtn setTitle:@"镜" forState:UIControlStateNormal];
        [_cameraBtn setBackgroundImage:[UIImage imageNamed:@"chatroom_video_off"] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cameraBtn];
        
        _directionBtn = [UIButton new];
//        [_directionBtn setTitle:@"向" forState:UIControlStateNormal];
        [_directionBtn setBackgroundImage:[UIImage imageNamed:@"switchCamera"] forState:UIControlStateNormal];
        [_directionBtn addTarget:self action:@selector(directionAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_directionBtn];
        
        [self updateActors];
        [[NIMSDK sharedSDK].netCallManager addDelegate:self];
        
        UITapGestureRecognizer *doubleClick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fullScreenAction:)];
        doubleClick.numberOfTapsRequired = 2;
        doubleClick.delaysTouchesBegan = YES;
        [self addGestureRecognizer:doubleClick];
        
        self.backgroundColor = [UIColor darkGrayColor];
        
        }
    return self;
}
- (void)dealloc{
    [[NIMSDK sharedSDK].netCallManager removeDelegate:self];
}
- (void)directionAction:(id)sender{
    
    self.isFrontCamera = !_isFrontCamera;
    
}
- (void)setIsFrontCamera:(BOOL)isFrontCamera{
    _isFrontCamera = isFrontCamera;
    if (_isFrontCamera) {
        [self hudShowWithStr:@"Change to front camera"];

        [[NIMSDK sharedSDK].netCallManager switchCamera:NIMNetCallCameraFront];
    }else{
        [self hudShowWithStr:@"Change to back camera"];

        [[NIMSDK sharedSDK].netCallManager switchCamera:NIMNetCallCameraBack];
    }
}

- (void)hudShowWithStr:(NSString *)str{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = str;
    [self hudHide];
}

- (void)hudHide{
    MBProgressHUD * hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud) {
        [hud hideAnimated:YES afterDelay:1.5];
    }
}

- (void)muteAction:(id)sender{
    if (![TEMeetingRolesManager sharedService].myRole.audioOn) {
        [self hudShowWithStr:@"Audio on"];
        [_muteBtn setBackgroundImage:[UIImage imageNamed:@"chatroom_audio_off"] forState:UIControlStateNormal];
    }else{
        [self hudShowWithStr:@"Audio off"];
        [_muteBtn setBackgroundImage:[UIImage imageNamed:@"chatroom_audio_on"] forState:UIControlStateNormal];
    }
    [[TEMeetingRolesManager sharedService] setMyAudio:![TEMeetingRolesManager sharedService].myRole.audioOn];
    
    
    
}

- (void)cameraAction:(id)sender{
    if (![TEMeetingRolesManager sharedService].myRole.videoOn) {
        [self hudShowWithStr:@"Video on"];
        [_cameraBtn setBackgroundImage:[UIImage imageNamed:@"chatroom_video_off"] forState:UIControlStateNormal];
    }else{
        [self hudShowWithStr:@"Video off"];
        [_cameraBtn setBackgroundImage:[UIImage imageNamed:@"chatroom_video_on"] forState:UIControlStateNormal];
    }
    [[TEMeetingRolesManager sharedService] setMyVideo:![TEMeetingRolesManager sharedService].myRole.videoOn];
    
    

}
- (void)fullScreenAction:(id)sender{
    
    self.fullScreen = !_fullScreen;

    
    if (self.fullScreen) {
        [_sizeModeBtn setBackgroundImage:[UIImage imageNamed:@"chatroom_video_fullsize"] forState:UIControlStateNormal];
    }else{
        [_sizeModeBtn setBackgroundImage:[UIImage imageNamed:@"chatroom_video_normalsize"] forState:UIControlStateNormal];
    }
    
    if ([_delegate respondsToSelector:@selector(videoViewFullScreen:)]) {
        [_delegate videoViewFullScreen:_fullScreen];
    }
    
    [self.viewController.view setNeedsLayout];
    [self setNeedsLayout];
}
#pragma mark - netcallmanagerdelegate
- (void)onLocalPreviewReady:(CALayer *)layer{
    NSLog(@"onLocalPreviewReady");
    if ([TEMeetingRolesManager sharedService].myRole.isActor) {
        NSLog(@"onLocalPreviewReady : isActor");
        [self startLocalPreview:layer];
    }else{
        NSLog(@"onLocalPreviewReady : notActor");
        _localVideoLayer = layer;
    }
    
//    [self startLocalPreview:layer];
}
- (void)onRemoteYUVReady:(NSData *)yuvData width:(NSUInteger)width height:(NSUInteger)height from:(NSString *)user{
//    NSLog(@"%ld",_actors.count);
//    if (_actors.count == 0) {
//        return;
//    }
    [_otherVideo render:yuvData width:width height:height];
}

#pragma mark - Private
- (void)startLocalPreview:(CALayer *)layer{
    [self stopLocalPreview];
    NSLog(@"start local preview");
    _localVideoLayer = layer;
    [_selfVideo render:nil width:0 height:0];
    [_selfVideo.layer addSublayer:_localVideoLayer];
    [self layoutLocalPreviewLayer];
}
- (void)stopLocalPreview{
    NSLog(@"stop local preview");
    if (_localVideoLayer) {
        [_localVideoLayer removeFromSuperlayer];
    }
}
- (void)layoutLocalPreviewLayer{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat rotateDegree;
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateDegree = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateDegree = M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateDegree = M_PI_2 * 3.0;
            break;
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationUnknown:
            rotateDegree = 0;
            break;
    }
    
    [_localVideoLayer setAffineTransform:CGAffineTransformMakeRotation(rotateDegree)];
    
    _localVideoLayer.frame = _selfVideo.bounds;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btnSize = 0;
    
    if (!_fullScreen) {
        
        btnSize = 24;
        
        _otherVideo.left = 0;
        _otherVideo.top  = 0;
        _otherVideo.width =  self.width;
        _otherVideo.height = self.height/2;
        
        _selfVideo.left = 0;
        _selfVideo.top = self.height/2;
        _selfVideo.width = self.width;
        _selfVideo.height  =self.height/2;
    }else{
        
        btnSize = 44;
        
        _otherVideo.left = 0;
        _otherVideo.top  = 0;
        _otherVideo.width =  self.width/2;
        _otherVideo.height = self.height;
        
        _selfVideo.left = self.width/2;
        _selfVideo.top = 0;
        _selfVideo.width = self.width/2;
        _selfVideo.height  =self.height;
    }
    
    _otherBg.left = _otherVideo.left;
    _otherBg.top = _otherVideo.top;
    _otherBg.width = _otherVideo.width;
    _otherBg.height = _otherVideo.height;
    
    _selfBg.left = _selfVideo.left;
    _selfBg.top = _selfVideo.top;
    _selfBg.width = _selfVideo.width;
    _selfBg.height = _selfVideo.height;
    
    _sizeModeBtn.width = btnSize;
    _sizeModeBtn.height = btnSize;
    _sizeModeBtn.top = 5;
    _sizeModeBtn.right = self.width - 5;
    
    _muteBtn.width = btnSize;
    _muteBtn.height = btnSize;
    _muteBtn.top = _selfVideo.top + 5;
    _muteBtn.left = _selfVideo.left + 5;
    
    _cameraBtn.width = btnSize;
    _cameraBtn.height =btnSize;
    _cameraBtn.top = _selfVideo.top+ 5;
    _cameraBtn.left = _muteBtn.right + 5;
    
    _directionBtn.width = btnSize;
    _directionBtn.height =btnSize;
    _directionBtn.bottom = _selfVideo.bottom - 5;
    _directionBtn.centerX = _selfVideo.width/2 + _selfVideo.left;

    
    
//    _selfVideo.left = self.width*3/4;
//    _selfVideo.top = self.height*3/4;
//    _selfVideo.width = self.width/4;
//    _selfVideo.height  =self.height/4;
    
    [self layoutLocalPreviewLayer];
}
- (void)updateActors{
    
    NSMutableArray *actors= [NSMutableArray arrayWithArray:[[TEMeetingRolesManager sharedService] allActorsByName:NO]];
    
    if (actors.count != _actors.count) {
        [_otherVideo render:nil width:0 height:0];
    }
    
    _actors = actors;
    
    if(_localVideoLayer){
        if ([TEMeetingRolesManager sharedService].myRole.videoOn) {
            [self onLocalPreviewReady:_localVideoLayer];
        }else{
            [self stopLocalPreview];
        }
    }
}
@end
