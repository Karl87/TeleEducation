//
//  TEWhiteboardCmdHandler.m
//  TeleEducation
//
//  Created by Karl on 2017/3/15.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEWhiteboardCmdHandler.h"
#import "TETimerHolder.h"
#import "TEMeetingRTSManager.h"
#import "TEWhiteboardCommand.h"

#define TESendCmdIntervalSeconds 0.06
#define TESendCmdMaxSize 30000

@interface TEWhiteboardCmdHandler ()<TETimeHolderDelegate>

@property (nonatomic, strong) TETimerHolder *sendCmdsTimer;

@property (nonatomic, strong) NSMutableString *cmdsSendBuffer;

@property (nonatomic, assign) UInt64 refPacketID;

@property (nonatomic, weak) id<TEWhiteboardCmdHandlerDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *syncPoints;

@end


@implementation TEWhiteboardCmdHandler
- (instancetype)initWithDelegate:(id<TEWhiteboardCmdHandlerDelegate>)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
        _sendCmdsTimer = [[TETimerHolder alloc] init];
        _cmdsSendBuffer = [[NSMutableString alloc] init];
        _syncPoints = [[NSMutableDictionary alloc] init];
        [_sendCmdsTimer startTimer:TESendCmdIntervalSeconds delegate:self repeats:YES];
    }
    return self;
}

- (void)sendMyPoint:(TEWhiteboardPoint *)point
{
    NSString *cmd = [TEWhiteboardCommand pointCommand:point];
    
    [_cmdsSendBuffer appendString:cmd];
    
    if (_cmdsSendBuffer.length > TESendCmdMaxSize) {
        [self doSendCmds];
    }
}

- (void)sendPureCmd:(TEWhiteboardCmdType)type page:(NSInteger)page to:(NSString *)uid{
    NSString *cmd = [TEWhiteboardCommand pureCommand:type page:page];
    if (uid == nil) {
        [_cmdsSendBuffer appendString:cmd];
        [self doSendCmds];
    }else {
        [[TEMeetingRTSManager sharedService] sendRTSData:[cmd dataUsingEncoding:NSUTF8StringEncoding]
                                                     toUser:uid];
    }
}
- (void)sendPureCmd:(TEWhiteboardCmdType)type to:(NSString *)uid
{
    NSString *cmd = [TEWhiteboardCommand pureCommand:type];
    if (uid == nil) {
        [_cmdsSendBuffer appendString:cmd];
        [self doSendCmds];
    }
    else {
        [[TEMeetingRTSManager sharedService] sendRTSData:[cmd dataUsingEncoding:NSUTF8StringEncoding]
                                                     toUser:uid];
    }
    
}

- (void)sync:(NSDictionary *)allLines toUser:(NSString *)targetUid
{
    for (NSString *uid in allLines.allKeys) {
        
        NSMutableString *pointsCmd = [[NSMutableString alloc] init];
        
        NSArray *lines = [allLines objectForKey:uid];
        for (NSArray *line in lines) {
            
            for (TEWhiteboardPoint *point in line) {
                [pointsCmd appendString:[TEWhiteboardCommand pointCommand:point]];
            }
            
            int end = [line isEqual:lines.lastObject] ? 1 : 0;
            
            if (pointsCmd.length > TESendCmdMaxSize || end) {
                
                NSString *syncHeadCmd = [TEWhiteboardCommand syncCommand:uid end:end];
                
                NSString *syncCmds = [syncHeadCmd stringByAppendingString:pointsCmd];
                
                [[TEMeetingRTSManager sharedService] sendRTSData:[syncCmds dataUsingEncoding:NSUTF8StringEncoding]
                                                             toUser:targetUid];
                
                [pointsCmd setString:@""];
            }
        }
    }
}


- (void)onTETimerFired:(TETimerHolder *)holder
{
    [self doSendCmds];
}

- (void)doSendCmds
{
    if (_cmdsSendBuffer.length) {
        NSString *cmd =  [TEWhiteboardCommand packetIdCommand:_refPacketID++];
        [_cmdsSendBuffer appendString:cmd];
        
        [[TEMeetingRTSManager sharedService] sendRTSData:[_cmdsSendBuffer dataUsingEncoding:NSUTF8StringEncoding] toUser:nil];
        
        NSLog(@"send data %@", _cmdsSendBuffer);
        
        [_cmdsSendBuffer setString:@""];
    }
}

- (void)handleReceivedData:(NSData *)data sender:(NSString *)sender
{
    NSString *cmdsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *cmdsArray = [cmdsString componentsSeparatedByString:@";"];
    
    for (NSString *cmdString in cmdsArray) {
        
        if (cmdString.length == 0) {
            continue;
        }
        
        NSArray *cmd = [cmdString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":,"]];
        
        NSInteger type = [cmd[0] integerValue];
        
        switch (type) {
            case TEWhiteboardCmdTypePointStart:
            case TEWhiteboardCmdTypePointMove:
            case TEWhiteboardCmdTypePointEnd:
            {
                if (cmd.count == 5) {
                    TEWhiteboardPoint *point = [[TEWhiteboardPoint alloc] init];
                    point.type = type;
                    point.xScale = [cmd[1] floatValue];
                    point.yScale = [cmd[2] floatValue];
                    point.colorRGB = [cmd[3] intValue];
                    point.page = [cmd[4] intValue];
                    if (_delegate) {
                        [_delegate onReceivePoint:point from:sender];
                    }
                }
                else {
                    NSLog(@"Invalid point cmd: %@", cmdString);
                }
                break;
            }
            case TEWhiteboardCmdTypeCancelLine:
            {
                if (cmd.count == 2) {
                    if(_delegate){
                        [_delegate onReceiveCancelLinePage:[cmd[1] intValue] from:sender];
                    }
                }
                break;
            }
            case TEWhiteboardCmdTypeClearLines:
            {
                if (cmd.count == 2) {
                    if(_delegate){
                        [_delegate onReceiveClearLinePage:[cmd[1] intValue] from:sender];
                    }
                }
                break;
            }
            case TEWhiteboardCmdTypeClearLinesAck:
            {
                if (cmd.count == 2) {
                    if(_delegate){
                        [_delegate onReceiveClearLineAckPage:[cmd[1] intValue] from:sender];
                    }
                }
                break;
            }
            case TEWhiteboardCmdTypeSyncPrepare:
            {
                if (_delegate) {
                    [_delegate onReceiveCmd:type from:sender];
                }
                break;
            }
            case TEWhiteboardCmdTypeSyncRequest:
            {
                if (_delegate) {
                    [_delegate onReceiveSyncRequestFrom:sender];
                }
                break;
            }
            case TEWhiteboardCmdTypeSync:
            {
                NSString *linesOwner = cmd[1];
                int end = [cmd[2] intValue];
                [self handleSync:cmdsArray linesOwner:linesOwner end:end];
                return;
            }
            default:
                break;
        }
    }
    
}

- (void)handleSync:(NSArray *)cmdsArray linesOwner:(NSString *)linesOwner end:(int)end
{
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < cmdsArray.count; i ++) {
        NSString *cmdString = cmdsArray[i];
        
        if (cmdString.length == 0) {
            continue;
        }
        
        NSArray *cmd = [cmdString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":,"]];
        NSInteger type = [cmd[0] integerValue];
        switch (type) {
            case TEWhiteboardCmdTypePointStart:
            case TEWhiteboardCmdTypePointMove:
            case TEWhiteboardCmdTypePointEnd:
            {
                if (cmd.count == 5) {
                    TEWhiteboardPoint *point = [[TEWhiteboardPoint alloc] init];
                    point.type = [cmd[0] integerValue];
                    point.xScale = [cmd[1] floatValue];
                    point.yScale = [cmd[2] floatValue];
                    point.colorRGB = [cmd[3] intValue];
                    point.page = [cmd[4] intValue];
                    [points addObject:point];
                }
                else {
                    NSLog(@"Invalid point cmd in sync: %@", cmdString);
                }
                break;
            }
            case TEWhiteboardCmdTypePacketID:
                break;
            default:
                NSLog(@"Invalid cmd in sync: %@", cmdString);
                break;
        }
    }
    
    NSMutableArray *allPoints = [_syncPoints objectForKey:linesOwner];
    
    if (!allPoints) {
        allPoints = [[NSMutableArray alloc] init];
    }
    
    [allPoints addObjectsFromArray:points];
    
    if (end) {
        if (_delegate) {
            [_delegate onReceiveSyncPoints:allPoints owner:linesOwner];
        }
        
        [_syncPoints removeObjectForKey:linesOwner];
    }
    else {
        [_syncPoints setObject:allPoints forKey:linesOwner];
    }
}

@end
