//
//  TEClassroomRole.h
//  TeleEducation
//
//  Created by Karl on 2017/5/19.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEClassroomRole : NSObject

@property(nonatomic, copy)   NSString  *uid;

@property(nonatomic, copy)   NSString  *nickName;

@property(nonatomic, assign) BOOL isManager;  //会议管理者

@property(nonatomic, assign) BOOL isJoined;   //已经加入音视频会议

@property(nonatomic, assign) BOOL isActor;    //有发言权限

@property(nonatomic, assign) BOOL audioOn;    //开启声音

@property(nonatomic, assign) BOOL videoOn;    //开启画面

@property(nonatomic, assign) BOOL whiteboardOn; //开启白板绘制

@property(nonatomic, assign) UInt16 audioVolume; //声音音量

@end
