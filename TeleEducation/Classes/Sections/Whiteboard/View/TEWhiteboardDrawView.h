//
//  TEWhiteboardDrawView.h
//  TeleEducation
//
//  Created by Karl on 2017/3/16.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TEWhiteboardDrawViewDataSource <NSObject>

- (NSDictionary *)allLinesToDraw;
- (BOOL)hasUpdate;

@end

@interface TEWhiteboardDrawView : UIView

@property (nonatomic,weak) id<TEWhiteboardDrawViewDataSource> dataSource;

@end
