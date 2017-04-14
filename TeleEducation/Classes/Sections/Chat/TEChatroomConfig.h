//
//  TEChatroomConfig.h
//  TeleEducation
//
//  Created by Karl on 2017/4/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSInteger, TEMediaButton)
//{
//    TEMediaButtonJanKenPon,      //石头剪刀布
//};

@interface TEChatroomConfig : NSObject<NIMSessionConfig>

- (instancetype)initWithChatroom:(NSString *)roomId;

@end
