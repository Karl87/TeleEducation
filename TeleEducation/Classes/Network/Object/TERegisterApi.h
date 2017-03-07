//
//  TERegisterApi.h
//  TeleEducation
//
//  Created by Karl on 2017/3/2.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface TERegisterApi : YTKRequest

- (id)initWithUsername:(NSString *)username phone:(NSString*)phone password:(NSString *)password;

@end
