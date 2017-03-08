//
//  TEPayOrderApi.h
//  TeleEducation
//
//  Created by Karl on 2017/3/8.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface TEPayOrderApi : YTKRequest

- (id)initWithToken:(NSString *)token order:(NSInteger)order status:(NSInteger)status;


@end
