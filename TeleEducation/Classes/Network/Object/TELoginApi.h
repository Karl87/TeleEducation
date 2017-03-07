//
//  TELoginRequest.h
//  TeleEducation
//
//  Created by Karl on 2017/3/1.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "TELoginData.h"

@interface TELoginApi : YTKRequest

- (id)initWithUsername:(NSString *)username password:(NSString *)password userType:(TEUserType)type;

@end
