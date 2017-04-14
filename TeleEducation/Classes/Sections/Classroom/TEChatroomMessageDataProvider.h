//
//  TEChatroomMessageDataProvider.h
//  TeleEducation
//
//  Created by Karl on 2017/4/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEChatroomMessageDataProvider : NSObject<NIMKitMessageProvider>

- (instancetype)initWithChatroom:(NSString *)roomId;
@end
