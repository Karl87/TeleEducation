//
//  TEChatroomConfig.m
//  TeleEducation
//
//  Created by Karl on 2017/4/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEChatroomConfig.h"
#import "TEChatroomMessageDataProvider.h"


@interface TEChatroomConfig ()

@property (nonatomic,strong) TEChatroomMessageDataProvider *provider;
@end

@implementation TEChatroomConfig

- (instancetype)initWithChatroom:(NSString *)roomId{
    self = [super init];
    if (self) {
        self.provider = [[TEChatroomMessageDataProvider alloc] initWithChatroom:roomId];
    }
    return self;
}

- (id<NIMKitMessageProvider>)messageDataProvider{
    return self.provider;
}


- (NSArray<NSNumber *> *)inputBarItemTypes{
    return @[
             @(NIMInputBarItemTypeTextAndRecord),
             @(NIMInputBarItemTypeEmoticon)
//             ,@(NIMInputBarItemTypeMore)
             ];
}


- (NSArray *)mediaItems
{
    NSArray *defaultMediaItems = [NIMKitUIConfig sharedConfig].defaultMediaItems;

    NIMMediaItem *janKenPon = [NIMMediaItem item:@"onTapMediaItemJanKenPon:"
                                     normalImage:[UIImage imageNamed:@"icon_jankenpon_normal"]
                                   selectedImage:[UIImage imageNamed:@"icon_jankenpon_pressed"]
                                           title:@"石头剪刀布"];
    
    NSArray *items = @[];
    items = @[janKenPon];
    return [defaultMediaItems arrayByAddingObjectsFromArray:items];
}


//- (BOOL)disableCharlet{
//    return NO;
//}
//
- (BOOL)autoFetchWhenOpenSession
{
    return NO;
}

- (BOOL)shouldHandleReceipt
{
    return NO;
}


@end
