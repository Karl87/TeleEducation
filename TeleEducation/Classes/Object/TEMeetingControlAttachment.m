//
//  TEMeetingControlAttachment.m
//  TeleEducation
//
//  Created by Karl on 2017/2/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEMeetingControlAttachment.h"

@implementation TEMeetingControlAttachment
- (NSString *)encodeAttachment
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [dict setObject:@(CustomMessageTypeMeetingControl) forKey:CMType];
    [data setObject:_roomID?_roomID:@"" forKey:CMRoomID];
    [data setObject:@(_command) forKey:CMCommand];
    if (_uids.count) {
        [data setObject:_uids forKey:CMUIDs];
    }
    [dict setObject:data forKey:CMData];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:nil];
    
    return [[NSString alloc] initWithData:jsonData
                                 encoding:NSUTF8StringEncoding];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"room: %@, command:%zd, uids:%@", _roomID, _command, _uids];
}

@end
