//
//  TENIMRegisterTask.m
//  TeleEducation
//
//  Created by Karl on 2017/3/8.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TENIMRegisterTask.h"
#import "TEAppConfig.h"
#import "NSDictionary+TEJson.h"
#import "NIMSDK.h"

@implementation TENIMRegisterData

@end

@implementation TENIMRegisterTask
- (NSURLRequest *)taskRequest{
    NSString *urlString = [[[TEAppConfig sharedConfig] NIMApiURL] stringByAppendingString:@"/creatDemoUser"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [request setHTTPMethod:@"Post"];
    [request addValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"nim_demo_ios" forHTTPHeaderField:@"User_Agent"];
    [request addValue:[[NIMSDK sharedSDK] appKey] forHTTPHeaderField:@"appkey"];
    
    NSString *postData = [NSString stringWithFormat:@"username=%@&password=%@&nickname=%@",[_data account],[_data token],[_data nickname]];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

- (void)onGetResponse:(id)jsonObject error:(NSError *)error{
    NSError *resultError = error;
    NSString *errMsg = @"unknown error";
    if (error == nil && [jsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)jsonObject;
        NSInteger code = [dict jsonInteger:@"res"];
        resultError = code == 200?nil:[NSError errorWithDomain:@"ntes domain" code:code userInfo:nil];
        errMsg = dict[@"errmsg"];
    }
    if (_handler) {
        _handler(resultError,errMsg);
    }
}

@end
