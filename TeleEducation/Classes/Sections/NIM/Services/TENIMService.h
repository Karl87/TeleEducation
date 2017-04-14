//
//  TENIMService.h
//  TeleEducation
//
//  Created by Karl on 2017/3/8.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TENIMRegisterTask.h"
#import "TENIMCreatMeetingTask.h"
#import "TENIMCloseMeetingTask.h"

@interface TENIMService : NSObject
+(instancetype)sharedService;

- (void)registerUser:(TENIMRegisterData *)data
           comletion:(TENIMRegisterHandler)completion;

- (void)requestMeeting:(NSString *)meeting
            completion:(TENIMCreatMeetingHandler)completion;

- (void)closeMeeting:(NSString *)meeting
             creator:(NSString *)creator
          completion:(TENIMCloseMeetingHandler)completion;
@end
