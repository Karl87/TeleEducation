//
//  TEChatroomViewController.h
//  TeleEducation
//
//  Created by Karl on 2017/4/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "NIMSessionViewController.h"

@interface TEChatroomViewController : NIMSessionViewController
@property (nonatomic,weak) id<NIMInputDelegate> delegate;

- (instancetype) initWithChatroom:(NIMChatroom *)chatroom;

@end
