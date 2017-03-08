//
//  TENIMCreatMeetingTask.h
//  TeleEducation
//
//  Created by Karl on 2017/3/8.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TENIMServiceTask.h"

typedef void(^TENIMCreatMeetingHandler)(NSError *error,NSString *meetingRoomID);

@interface TENIMCreatMeetingTask : NSObject<TENIMServiceTask>

@property (nonatomic,copy) NSString *meetingName;
@property (nonatomic,copy) TENIMCreatMeetingHandler handler;

@end
