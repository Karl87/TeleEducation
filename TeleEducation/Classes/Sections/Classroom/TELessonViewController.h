//
//  TELessonViewController.h
//  TeleEducation
//
//  Created by Karl on 2017/3/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TELessonViewController : UIViewController

@property (nonatomic,assign) NSInteger lessonID;
@property (nonatomic,assign) NSInteger unitID;

- (instancetype)initWithNIMChatroom:(NIMChatroom *)room;
@end
