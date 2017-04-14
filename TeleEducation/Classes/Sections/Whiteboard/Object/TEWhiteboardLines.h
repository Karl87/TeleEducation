//
//  TEWhiteboardLines.h
//  TeleEducation
//
//  Created by Karl on 2017/3/16.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEWhiteboardPoint.h"
#import "TEWhiteboardDrawView.h"

@interface TEWhiteboardLines : NSObject<TEWhiteboardDrawViewDataSource>

@property (nonatomic,assign) BOOL hasUpdate;

- (void)addPoint:(TEWhiteboardPoint *)point uid:(NSString *)uid;

- (void)cancelLastLine:(NSString *)uid;

- (void)clear;

- (void)clearUser:(NSString *)uid;

- (NSDictionary *)allLines;

- (BOOL)hasLines;

@end
