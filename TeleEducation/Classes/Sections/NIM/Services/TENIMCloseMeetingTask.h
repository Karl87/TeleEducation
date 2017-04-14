//
//  TENIMCloseMeetingTask.h
//  TeleEducation
//
//  Created by Karl on 2017/3/8.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TENIMServiceTask.h"

typedef void (^TENIMCloseMeetingHandler)(NSError *error, NSString *roomId);


@interface TENIMCloseMeetingTask : NSObject<TENIMServiceTask>

@property (nonatomic,copy) NSString *roomId;

@property (nonatomic,copy) NSString *creator;

@property (nonatomic,copy) TENIMCloseMeetingHandler handler;

@end
