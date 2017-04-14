//
//  TEChatroomMessageDataProvider.m
//  TeleEducation
//
//  Created by Karl on 2017/4/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEChatroomMessageDataProvider.h"

@interface TEChatroomMessageDataProvider ()
@property (nonatomic,copy) NSString *roomId;
@end


@implementation TEChatroomMessageDataProvider

- (instancetype)initWithChatroom:(NSString *)roomId{
    self = [super init];
    if (self) {
        _roomId = roomId;
    }
    return self;
}

- (void)pullDown:(NIMMessage *)firstMessage handler:(NIMKitDataProvideHandler)handler{
    NIMHistoryMessageSearchOption *option = [[NIMHistoryMessageSearchOption alloc] init];
    option.startTime = firstMessage.timestamp;
    option.limit = 10;
    [[NIMSDK sharedSDK].chatroomManager fetchMessageHistory:self.roomId option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        if (handler) {
            handler(error,messages.reverseObjectEnumerator.allObjects);
        }
    }];
}

- (BOOL)needTimetag{
    return NO;
}

@end
