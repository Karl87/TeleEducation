//
//  TEWhiteboardCmdHandler.h
//  TeleEducation
//
//  Created by Karl on 2017/3/15.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEWhiteboardPoint.h"
#import "TEWhiteboardCommand.h"
#import "TEMeetingRTSManager.h"

@protocol TEWhiteboardCmdHandlerDelegate <NSObject>

- (void)onReceivePoint:(TEWhiteboardPoint *)point from:(NSString *)sender;

- (void)onReceiveCmd:(TEWhiteboardCmdType)type from:(NSString *)sender;

- (void)onReceiveCancelLinePage:(int)page from:(NSString *)sender;

- (void)onReceiveClearLinePage:(int)page from:(NSString *)sender;

- (void)onReceiveClearLineAckPage:(int)page from:(NSString *)sender;

- (void)onReceiveSyncRequestFrom:(NSString *)sender;

- (void)onReceiveSyncPoints:(NSMutableArray *)points owner:(NSString *)owner;

@end


@interface TEWhiteboardCmdHandler : NSObject<TEMeetingRTSDataHandler>

- (instancetype)initWithDelegate:(id<TEWhiteboardCmdHandlerDelegate>)delegate;

- (void)sendMyPoint:(TEWhiteboardPoint *)point;

- (void)sendPureCmd:(TEWhiteboardCmdType)type page:(NSInteger)page to:(NSString *)uid;

- (void)sendPureCmd:(TEWhiteboardCmdType)type to:(NSString *)uid;

- (void)sync:(NSDictionary *)allLines toUser:(NSString *)targetUid;

@end
