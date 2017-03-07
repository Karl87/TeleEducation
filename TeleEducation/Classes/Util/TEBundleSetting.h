//
//  TEBundleSetting.h
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMGlobalDefs.h"
#import "NIMAVChat.h"

@interface TEBundleSetting : NSObject

+ (instancetype) sharedConfig;
/*
 服务器录制语音
 */
- (BOOL)serverRecordAudio;
/*
 服务器录制视频
 */
- (BOOL)serverRecordVideo;
/*
 自动裁剪画面
 */
- (BOOL)videochatAutoCropping;
/*
 自动旋转视频聊天远端画面
 */
- (BOOL)videochatAudoRotateRemoteVideo;
/*
 视频发送清晰度
 */
- (NIMNetCallVideoQuality)preferredVideoQuality;
/*
 使用后置摄像头开始视频通话
 */
- (BOOL)startWithBackCamera;
/*
 期望的视频编码器
 */
- (NIMNetCallVideoCodec)preferredVideoEncoder;
/*
 期望的视频解码器
 */
- (NIMNetCallVideoCodec)preferredVideoDecoder;
/*
 最大发送视频编码码率
 */
- (NSUInteger)videoMaxEncodeKbps;
/*
 本地录制视频编码码率
 */
- (NSUInteger)localRecordVideoKbps;
/*
 自动结束AudioSession
 */
- (BOOL)autoDeactivateAudioSession;
/*
 降噪开关
 */
- (BOOL)audioDenoise;
/*
 语音检测开关
 */
- (BOOL)voiceDetect;
/*
 是否高清语音
 */
- (BOOL)preferHDAudio;
/*
 互动直播推流混屏模式
 */
- (NSUInteger)bypassVideoMixMode;
/*
 服务器录制白板数据
 */
- (BOOL)serverRecordWhiteboardData;
//- (BOOL)testerToolUI;
@end
