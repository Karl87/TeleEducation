//
//  TENIMCloseMeetingTask.m
//  TeleEducation
//
//  Created by Karl on 2017/3/8.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TENIMCloseMeetingTask.h"
#import "TEAppConfig.h"

#define NTESDemoCloseMeetingKeyRoomId @"roomid"
#define NTESDemoCloseMeetingKeyUid    @"uid"

@implementation TENIMCloseMeetingTask

- (NSURLRequest *)taskRequest
{
    
    if (![self validate]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSError *error = [NSError errorWithDomain:@"ntes domain"
                                                 code:NIMLocalErrorCodeInvalidParam
                                             userInfo:nil];
            
            self.handler(error,nil);
        });
        return nil;
        
    }
    
    NSString *urlString = [[[TEAppConfig sharedConfig] NIMApiURL] stringByAppendingString:@"/chatroom/close"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:30];
    [request setHTTPMethod:@"Post"];
    
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[[NIMSDK sharedSDK] appKey] forHTTPHeaderField:@"appKey"];
    
    NSData *data = [self encodedBody];
    
    [request setHTTPBody:data];
    
    return request;
}

- (BOOL)validate
{
    return self.roomId.length && self.creator.length;
}

- (NSData *)encodedBody
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:_roomId forKey:NTESDemoCloseMeetingKeyRoomId];
    [dict setObject:_creator forKey:NTESDemoCloseMeetingKeyUid];
    
    return [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
}


- (void)onGetResponse:(id)jsonObject error:(NSError *)error
{
    NSError *resultError = error;
    
    if (error == nil && [jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)jsonObject;
        NSInteger code = [dict[@"res"]integerValue];
        resultError = code == 200 ? nil : [NSError errorWithDomain:@"ntes domain"
                                                              code:code
                                                          userInfo:nil];
    }
    
    if (self.handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.handler(error,_roomId);
        });
    }
}

@end
