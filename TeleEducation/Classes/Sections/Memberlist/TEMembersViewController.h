//
//  TEMembersViewController.h
//  TeleEducation
//
//  Created by Karl on 2017/4/11.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEMembersViewController : UIViewController

@property (nonatomic,strong) NSMutableArray<NIMChatroomMember *> *members;

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom;

- (void)prepareData;
- (void)refresh;
- (void)updateMembers:(NSArray *)members entered:(BOOL)entered;

@end
