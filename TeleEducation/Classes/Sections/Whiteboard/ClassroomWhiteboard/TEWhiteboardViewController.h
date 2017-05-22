//
//  TEWhiteboardViewController.h
//  TeleEducation
//
//  Created by Karl on 2017/3/15.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEWhiteboardViewController : UIViewController
@property (nonatomic,assign) NSInteger lessonID;
@property (nonatomic,assign) NSInteger unitID;
- (instancetype)initWithChatroom:(NIMChatroom *)chatroom;
- (void)checkPermission;
@end
