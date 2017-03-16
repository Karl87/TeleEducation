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

@interface TELessonVideoView ()<NIMNetCallManagerDelegate>
@property (nonatomic,strong) TEGLView *selfVideo;
@property (nonatomic, weak) CALayer *localVideoLayer;
@property (nonatomic,strong) TEGLView *otherVideo;
@property (nonatomic,strong) NSMutableArray *actors;
@end

@implementation TELessonVideoView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _otherVideo = [[TEGLView alloc] initWithFrame:self.bounds];
        [_otherVideo setBackgroundColor:[UIColor grayColor]];
        _otherVideo.contentMode = UIViewContentModeScaleAspectFill;
        [_otherVideo render:nil width:0 height:0];
        [self addSubview:_otherVideo];
        
        _selfVideo = [[TEGLView alloc] initWithFrame:self.bounds];
        [_selfVideo setBackgroundColor:[UIColor whiteColor]];
        _selfVideo.contentMode = UIViewContentModeScaleAspectFill;
        [_selfVideo render:nil width:0 height:0];
        [self addSubview:_selfVideo];
        
        [self updateActors];
        [[NIMSDK sharedSDK].netCallManager addDelegate:self];
        
        }
    return self;
}
- (void)dealloc{
    [[NIMSDK sharedSDK].netCallManager removeDelegate:self];
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
    if (_actors.count == 0) {
        return;
    }
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
    _otherVideo.left = 0;
    _otherVideo.top  = 0;
    _otherVideo.width =  self.width;
    _otherVideo.height = self.height;
    
    _selfVideo.left = self.width*3/4;
    _selfVideo.top = self.height*3/4;
    _selfVideo.width = self.width/4;
    _selfVideo.height  =self.height/4;
    
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
