//
//  TEWhiteboardCommand.h
//  TeleEducation
//
//  Created by Karl on 2017/3/15.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEWhiteboardPoint.h"

typedef NS_ENUM(NSUInteger,TEWhiteboardCmdType){
    TEWhiteboardCmdTypePointStart = 1,
    TEWhiteboardCmdTypePointMove = 2,
    TEWhiteboardCmdTypePointEnd = 3,
    
    TEWhiteboardCmdTypeCancelLine = 4,
    TEWhiteboardCmdTypePacketID = 5,
    TEWhiteboardCmdTypeClearLines = 6,
    TEWhiteboardCmdTypeClearLinesAck = 7,
    
    TEWhiteboardCmdTypeSyncRequest = 8,
    TEWhiteboardCmdTypeSync = 9,
    
    TEWhiteboardCmdTypeSyncPrepare = 10,
    TEWhiteboardCmdTypeSyncPrepareAck = 11
};

@interface TEWhiteboardCommand : NSObject

+ (NSString *)pointCommand:(TEWhiteboardPoint *)point;

+ (NSString *)pureCommand:(TEWhiteboardCmdType)type;

+ (NSString *)pureCommand:(TEWhiteboardCmdType)type extraInfo:(id)info;

+ (NSString *)syncCommand:(NSString *)uid end:(int)end;

+ (NSString *)packetIdCommand:(UInt64)packetId;

@end
