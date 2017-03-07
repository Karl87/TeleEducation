//
//  TELessonCell.h
//  TeleEducation
//
//  Created by Karl on 2017/2/23.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TELessonCellActionType){
    TELessonCellActionTypeNone,
    TELessonCellActionTypeShowContent,
    TELessonCellActionTypeStartClass
};

@protocol TELessonCellDelegate <NSObject>

@optional
- (void)lessonActionWith:(TELessonCellActionType)type andIndexPath:(NSIndexPath*)indexPath;
@end

@interface TELessonCell : UITableViewCell
@property (nonatomic,weak) id<TELessonCellDelegate> delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) id data;
@end
