//
//  TEChatroomViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/4/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEChatroomViewController.h"
#import "TEChatroomConfig.h"
#import "TEJanKenPonAttachment.h"
#import "TESessionMsgConverter.h"
#import "TEMeetingManager.h"
#import "TEChartletAttachment.h"
#import "TECellLayoutConfig.h"
#import "TEMeetingControlAttachment.h"

@interface TEChatroomViewController (){
    BOOL _isRefreshing;
}
@property (nonatomic,strong) TEChatroomConfig *config;
@property (nonatomic,strong) NIMChatroom *chatroom;
@end

@implementation TEChatroomViewController

- (instancetype) initWithChatroom:(NIMChatroom *)chatroom{
    self = [super initWithSession:[NIMSession session:chatroom.roomId type:NIMSessionTypeChatroom]];
    if (self) {
        _chatroom = chatroom;
    }
    return self;
}

- (void)dealloc{
//    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NIMKit sharedKit] registerLayoutConfig:[TECellLayoutConfig class]];
//    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.refreshControl removeFromSuperview];
    [self.refreshControl removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id<NIMSessionConfig>)sessionConfig{
    return self.config;
}

- (BOOL)onTapMediaItem:(NIMMediaItem *)item{
    SEL sel = item.selctor;
    BOOL response = [self respondsToSelector:sel];
    if (response) {
        SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:item]);
    }
    return response;
}

- (void)onTapMediaItemJanKenPon:(NIMMediaItem *)item{
    TEJanKenPonAttachment *attachment = [[TEJanKenPonAttachment alloc] init];
    attachment.value = arc4random() % 3 + 1;
    [self sendMessage:[TESessionMsgConverter msgWithJenKenPon:attachment]];
}
- (void)onSelectChartlet:(NSString *)chartletId
                 catalog:(NSString *)catalogId
{
    TEChartletAttachment *attachment = [[TEChartletAttachment alloc] init];
    attachment.chartletID = chartletId;
    attachment.chartletCatalog = catalogId;
    NSLog(@"chid:%@,caid:%@",chartletId,catalogId);
    [self sendMessage:[TESessionMsgConverter msgWithChartletAttachment:attachment]];
}
- (void)sendMessage:(NIMMessage *)message
{
    NIMChatroomMember *member = [[TEMeetingManager sharedService] myInfo:self.chatroom.roomId];
    message.remoteExt = @{@"type":@(member.type)};
    [super sendMessage:message];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"contentOffset"]) {
//        CGFloat offset = 44.f;
//        if (self.tableView.contentOffset.y <= -offset && !_isRefreshing && self.tableView.isDragging) {
//            _isRefreshing = YES;
//            [self.refreshControl beginRefreshing];
//            [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
//            [self.tableView endEditing:YES];
//        }
//        else if(self.tableView.contentOffset.y >= 0)
//        {
//            _isRefreshing = NO;
//        }
//    }
//}
#pragma mark - NIMInputDelegate
- (void)showInputView
{
    if ([self.delegate respondsToSelector:@selector(showInputView)]) {
        [self.delegate showInputView];
    }
}


- (void)hideInputView
{
    if ([self.delegate respondsToSelector:@selector(hideInputView)]) {
        [self.delegate hideInputView];
    }
}
#pragma mark -  filter messages
- (void)onRecvMessages:(NSArray *)messages
{
    NSMutableArray *filteredMessages = [NSMutableArray arrayWithArray:messages];
    for (NIMMessage *message in messages) {
        if ([self isMeetingControlMessage:message]) {
            [filteredMessages removeObject:message];
        }
//        else{
//            if (message.session.sessionType == NIMSessionTypeChatroom) {
//                NIMMessageChatroomExtension *ext = [message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]] ? (NIMMessageChatroomExtension *)message.messageExt : nil;
//                NSLog(@"%@,%@,%@,%@",message.text,ext.roomAvatar,ext.roomNickname,ext.roomExt);
//                
//            }
//
//        }
    }
    [super onRecvMessages:filteredMessages];
}

- (void)willSendMessage:(NIMMessage *)message
{
    if (![self isMeetingControlMessage:message]) {
        [super willSendMessage:message];
    }
}

-(void)sendMessage:(NIMMessage *)message progress:(float)progress
{
    if (![self isMeetingControlMessage:message]) {
        [super sendMessage:message progress:progress];
    }
}


- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    if (![self isMeetingControlMessage:message]) {
        [super sendMessage:message didCompleteWithError:error];
    }
}

#pragma mark - Get
- (TEChatroomConfig *)config{
    if (!_config) {
        _config = [[TEChatroomConfig alloc] initWithChatroom:self.chatroom.roomId];
    }
    return _config;
}
#pragma mark - private

- (BOOL)isMeetingControlMessage:(NIMMessage *)message
{
    if (message.session.sessionType == NIMSessionTypeChatroom) {
        if(message.messageType == NIMMessageTypeCustom) {
            NIMCustomObject *object = message.messageObject;
            if ([object.attachment isKindOfClass:[TEMeetingControlAttachment class]]) {
                return YES;
            }
        }
    }
    return NO;
}
@end
