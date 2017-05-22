//
//  TEWhiteboardCommand.m
//  TeleEducation
//
//  Created by Karl on 2017/3/15.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEWhiteboardCommand.h"
#define TEWhiteboardCmdFormatPoint @"%zd:%.4f,%.4f,%d,%d,%.1f;"
#define TEWhiteboardCmdFormatPacketID @"%zd:%llu;"
#define TEWhiteboardCmdFormatSync @"%zd:%@,%d;"
#define TEWhiteboardCmdFormatPureCmd @"%zd:;"
#define TEWhiteboardCmdFormatPureCmdWithExtra @"%zd:%d;"

@implementation TEWhiteboardCommand

+ (NSString *)pointCommand:(TEWhiteboardPoint *)point
{
    return [NSString stringWithFormat:TEWhiteboardCmdFormatPoint, point.type, point.xScale, point.yScale, point.colorRGB,point.page,point.lineWidth];
}
+ (NSString *)pureCommand:(TEWhiteboardCmdType)type page:(int)page{
    return [NSString stringWithFormat:TEWhiteboardCmdFormatPureCmdWithExtra,type,page];
}

+ (NSString *)pureCommand:(TEWhiteboardCmdType)type
{
    return [NSString stringWithFormat:TEWhiteboardCmdFormatPureCmd, type];
}

+ (NSString *)syncCommand:(NSString *)uid end:(int)end
{
    return [NSString stringWithFormat:TEWhiteboardCmdFormatSync, TEWhiteboardCmdTypeSync, uid, end];
}

+ (NSString *)packetIdCommand:(UInt64)packetId
{
    return [NSString stringWithFormat:TEWhiteboardCmdFormatPacketID, TEWhiteboardCmdTypePacketID, packetId];
}


@end
