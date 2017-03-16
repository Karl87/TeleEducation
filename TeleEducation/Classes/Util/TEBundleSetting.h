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

+ (instancetype)sharedConfig;

- (BOOL)serverRecordAudio;                          //服务器录制语音

- (BOOL)serverRecordVideo;                          //服务器录制视频

- (BOOL)videochatAutoCropping;                      //自动裁剪画面

- (BOOL)videochatAutoRotateRemoteVideo;             //自动旋转视频聊天远端画面

- (NIMNetCallVideoQuality)preferredVideoQuality;    //期望的视频发送清晰度

- (BOOL)startWithBackCamera;                        //使用后置摄像头开始视频通话

- (NIMNetCallVideoCodec)perferredVideoEncoder;      //期望的视频编码器

- (NIMNetCallVideoCodec)perferredVideoDecoder;      //期望的视频解码器

- (NSUInteger)videoMaxEncodeKbps;                   //最大发送视频编码码率

- (NSUInteger)localRecordVideoKbps;                 //本地录制视频码率

- (BOOL)autoDeactivateAudioSession;                 //自动结束AudioSession

- (NSUInteger)audioDenoise;                         //降噪开关

- (NSUInteger)voiceDetect;                          //语音检测开关

- (NSUInteger)bypassVideoMixMode;                   //互动直播推流混屏模式

- (BOOL)serverRecordWhiteboardData;                 //服务器录制白板数据

- (BOOL)testerToolUI;                               //打开测试者菜单@end
@end
