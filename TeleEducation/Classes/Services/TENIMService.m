//
//  TENIMService.m
//  TeleEducation
//
//  Created by Karl on 2017/3/8.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TENIMService.h"

@implementation TENIMService

+ (instancetype)sharedService{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)runTask:(id<TENIMServiceTask>)task{
    NSURLRequest *request = [task taskRequest];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               id jsonObject = nil;
                               NSError *error = connectionError;
                               if (connectionError == nil && [response isKindOfClass:[NSHTTPURLResponse class]] && [(NSHTTPURLResponse *)response statusCode] == 200) {
                                   if (data) {
                                       jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   }else{
                                       error = [NSError errorWithDomain:@"ntes domain" code:-1 userInfo:@{@"description":@"invalid data"}];
                                   }
                               }
                               [task onGetResponse:jsonObject error:error];
                           }];
}

- (void)registerUser:(TENIMRegisterData *)data comletion:(TENIMRegisterHandler)completion{
    TENIMRegisterTask *task = [[TENIMRegisterTask alloc] init];
    task.data = data;
    task.handler = completion;
    [self runTask:task];
}

- (void)requestMeeting:(NSString *)meeting completion:(TENIMCreatMeetingHandler)completion{
    TENIMCreatMeetingTask *task = [[TENIMCreatMeetingTask alloc] init];
    task.meetingName = meeting;
    task.handler = completion;
    [self runTask:task];
}

- (void)closeMeeting:(NSString *)meeting creator:(NSString *)creator completion:(TENIMCloseMeetingHandler)completion{
    TENIMCloseMeetingTask *task = [[TENIMCloseMeetingTask alloc] init];
    task.roomId = meeting;
    task.creator  =creator;
    task.handler  =completion;
    [self runTask:task];
}
@end
