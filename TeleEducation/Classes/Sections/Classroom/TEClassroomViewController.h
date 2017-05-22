//
//  TEClassroomViewController.h
//  TeleEducation
//
//  Created by Karl on 2017/5/12.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TELesson;
@interface TEClassroomViewController : UIViewController

- (instancetype)initWithLesson:(TELesson *)lesson;

@end
