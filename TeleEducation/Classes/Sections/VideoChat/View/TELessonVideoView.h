//
//  TELessonVideoView.h
//  TeleEducation
//
//  Created by Karl on 2017/3/13.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TELessonVideoView : UIView
- (void)updateActors;
- (void)stopLocalPreview;
@property (nonatomic,assign) BOOL fullScreen;
@end
