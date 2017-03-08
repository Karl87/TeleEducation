//
//  TENIMCreatMeetingTask.m
//  TeleEducation
//
//  Created by Karl on 2017/3/8.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TENIMCreatMeetingTask.h"
#import "TEAppConfig.h"
#import "NSDictionary+TEJson.h"

#define NTESDemoCreateMeetingKeyCreator              @"creator"
#define NTESDemoCreateMeetingKeyMeetingName          @"name"
#define NTESDemoCreateMeetingKeyMeetingAnnouncement  @"announcement"
#define NTESDemoCreateMeetingKeyExt                  @"ext"
#define NTESDemoCreateMeetingKeyMeeting              @"meeting"

@implementation TENIMCreatMeetingTask

- (BOOL)validate{
    return self.meetingName.length;
}
- (NSData *)encodedBody
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    
    [dict setObject:currentUserId forKey:NTESDemoCreateMeetingKeyCreator];
    
    if (self.meetingName.length) {
        [dict setObject:self.meetingName forKey:NTESDemoCreateMeetingKeyMeetingName];
    }
    
    NSDictionary *ext = @{
                          NTESDemoCreateMeetingKeyMeeting : self.meetingName,
                          };
    
    NSString *extString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:ext options:0 error:nil]
                                                encoding:NSUTF8StringEncoding];
    
    [dict setObject:extString
             forKey:NTESDemoCreateMeetingKeyExt];
    
    return [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
}
- (NSURLRequest *)taskRequest{
    if (![self validate]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [NSError errorWithDomain:@"ntes domain" code:NIMLocalErrorCodeInvalidParam userInfo:nil];
            self.handler(error,nil);
        });
    }
    
    NSString *urlString = [[[TEAppConfig sharedConfig] NIMApiURL] stringByAppendingString:@"/chatroom/creat"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [request setHTTPMethod:@"Post"];
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[[NIMSDK sharedSDK] appKey] forHTTPHeaderField:@"appKey"];
    
    NSData *data = [self encodedBody];
    [request setHTTPBody:data];
    return request;
}

- (void)onGetResponse:(id)jsonObject error:(NSError *)error{
    NSError *resultError = error;
    NSString *meetinRoomID;
    if (error == nil &&[jsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)jsonObject;
        NSInteger code = [dic[@"res"] integerValue];
        resultError = code == 200 ? nil : [NSError errorWithDomain:@"ntes domain" code:code userInfo:nil];
        if (resultError == nil) {
            meetinRoomID = dic[@"msg"];
        }
    }
    if (self.handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.handler(error,meetinRoomID);
        });
    }
}
@end
