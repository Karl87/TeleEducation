//
//  TEClassListViewController.h
//  TeleEducation
//
//  Created by Karl on 2017/2/21.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TECommonViewController.h"
@class NIMCommonTableRow;

typedef NS_ENUM(NSInteger,LessonActionType) {
    LessonActionTypeNone,
    LessonActionTypeShowContent,
    LessonActionTypeStartLesson
};

@interface TEClassListViewController : TECommonViewController
//- (void)lesson:(NIMCommonTableRow *)rowData withAction:(LessonActionType)type;
@end
