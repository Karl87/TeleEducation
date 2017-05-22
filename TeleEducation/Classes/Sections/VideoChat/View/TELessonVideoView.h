//
//  TELessonVideoView.h
//  TeleEducation
//
//  Created by Karl on 2017/3/13.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TELessonVideoViewDelegate <NSObject>

- (void)videoViewSizeChanged;

@end

@interface TELessonVideoView : UIView
- (void)updateActors;
- (void)stopLocalPreview;
@property (nonatomic,weak) id<TELessonVideoViewDelegate> delegate;
@property (nonatomic,assign) BOOL fullScreen;
@end
