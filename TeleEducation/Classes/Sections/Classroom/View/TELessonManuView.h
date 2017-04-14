//
//  TELessonManuView.h
//  TeleEducation
//
//  Created by Karl on 2017/4/7.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TELessonManuView;

@protocol TELessonManuViewDelegate <NSObject>

- (void)lessonManuView:(TELessonManuView *)view didSelectedItem:(NSString *)item;

@end

@interface TELessonManuView : UIView


@property (nonatomic,weak) id<TELessonManuViewDelegate> delegate;
- (instancetype)initWithItems:(NSArray *)items;

@end
