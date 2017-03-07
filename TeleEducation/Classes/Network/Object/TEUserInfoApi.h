//
//  TEUserInfoApi.h
//  TeleEducation
//
//  Created by Karl on 2017/3/6.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "TELoginData.h"

@interface TEUserInfoApi : YTKRequest
- (id)initWithToken:(NSString *)token type:(TEUserType)type;

@end
