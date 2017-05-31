//
//  TESurfaceMessageViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/5/24.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TESurfaceMessageViewController.h"
#import "TEClassroomSurfaceCell.h"
#import "TEChartletAttachment.h"


@interface TESurfaceMessageViewController ()<NIMChatManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NIMChatroom *chatroom;
@property (nonatomic,strong) NSMutableArray *messages;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation TESurfaceMessageViewController

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom{
    self = [super init];
    if (self) {
        _chatroom = chatroom;
        _messages = [NSMutableArray array];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self destroyTimer];
}

- (void)dealloc{
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
}


- (void)show{
    
    if (_autoShow) {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.alpha = 1.0;
        }];
        [self destroyTimer];
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hide) userInfo:nil repeats:NO];
        }
    }
}

- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0.0;
    }];
    [self destroyTimer];
}

- (void)destroyTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView registerClass:[TEClassroomSurfaceCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setRowHeight:44.];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableView.left = 0;
    _tableView.top = 0;
    _tableView.width = self.view.width;
    _tableView.height = self.view.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages{
    NIMMessage *message = messages.firstObject;
    if (message.session.sessionType == NIMSessionTypeChatroom) {
        NSLog(@"📩 messageType = %ld， sessionid = %@, chatroomid = %@", (long)message.messageType,message.session.sessionId,_chatroom.roomId);
        
        [self show];
        
        if (message.messageType == NIMMessageTypeNotification) {
            NIMNotificationObject *object = message.messageObject;
            NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)object.content;
            NSMutableArray *targetNicks = [[NSMutableArray alloc] init];
            for (NIMChatroomNotificationMember *memebr in content.targets) {
                if ([memebr.userId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
                    [targetNicks addObject:Babel(@"you")];
                }else{
                    [targetNicks addObject:memebr.nick];
                }
                
            }
            NSString *targetText =[targetNicks componentsJoinedByString:@","];
            if (content.eventType == NIMChatroomEventTypeEnter) {
                NSLog(@"🚪%@",[NSString stringWithFormat:@"%@已进入教室",targetText]);
                [_messages addObject:[NSString stringWithFormat:@"🚪%@",[NSString stringWithFormat:@"%@ %@",targetText,Babel(@"enter_classroom")]]];
            }else if (content.eventType == NIMChatroomEventTypeExit){
                NSLog(@"🚪%@",[NSString stringWithFormat:@"%@离开了教室",targetText]);
                [_messages addObject:[NSString stringWithFormat:@"🚪%@",[NSString stringWithFormat:@"%@ %@",targetText,Babel(@"leave_classroom")]]];
            }
        }else{
            NIMMessageChatroomExtension *ext = [message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]] ? (NIMMessageChatroomExtension *)message.messageExt : nil;
            NSLog(@"✉️ %@ : %@",ext.roomNickname,message.text);
            
            if (message.messageType == NIMMessageTypeText) {
                [_messages addObject:[NSString stringWithFormat:@"✉️ %@ : %@",ext.roomNickname,message.text]];

            }else if (message.messageType == NIMMessageTypeImage){
                [_messages addObject:[NSString stringWithFormat:@"✉️ %@ : %@",ext.roomNickname,Babel(@"message_photo")]];

            }else if (message.messageType == NIMMessageTypeCustom){
                NIMCustomObject *customObject = (NIMCustomObject*)message.messageObject;
                id attachment = customObject.attachment;
                if ([attachment isKindOfClass:[TEChartletAttachment class]]) {
                    [_messages addObject:[NSString stringWithFormat:@"✉️ %@ : %@",ext.roomNickname,Babel(@"message_chartlet")]];
                }else{
                    [_messages addObject:[NSString stringWithFormat:@"✉️ %@ : %@",ext.roomNickname,Babel(@"message_custom")]];
                }

            }else{
                [_messages addObject:[NSString stringWithFormat:@"✉️ %@:%@",ext.roomNickname,message.text]];
            }
            
        }
        [_tableView reloadData];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TEClassroomSurfaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.content = _messages[indexPath.row];
    cell.cellAlpha = 0.9 - (_messages.count-1-indexPath.row)*0.25;
    return cell;
}


@end
