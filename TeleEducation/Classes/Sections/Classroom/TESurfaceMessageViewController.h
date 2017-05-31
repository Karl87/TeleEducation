//
//  TESurfaceMessageViewController.h
//  TeleEducation
//
//  Created by Karl on 2017/5/24.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TESurfaceMessageViewController : UIViewController

@property (nonatomic,assign) BOOL autoShow;

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom;

- (void)hide;

@end
