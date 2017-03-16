//
//  TEClassListViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/2/21.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEClassListViewController.h"
#import "NIMCommonTableData.h"
#import "UIView+TE.h"
#import "UIImage+TEColor.h"
#import "TELessonCell.h"
#import "TEChooseLessonViewController.h"
#import "TELessonCell.h"
#import "TELessonHeaderView.h"
#import "TECommonPostTokenApi.h"

#import "TELoginManager.h"

#import "NSDictionary+TEJson.h"
#import "TELesson.h"
#import "TECourseContentViewController.h"
#import "TENavigationViewController.h"

#import "TENIMService.h"
#import "TENIMCreatMeetingTask.h"
#import "TEMeetingManager.h"
#import "TEMeetingRolesManager.h"
#import "NIMAVChat.h"

#import "TELessonViewController.h"

@interface TEClassListViewController ()<UITableViewDelegate,UITableViewDataSource,TELessonCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *lessonData;
@property (nonatomic,strong) NSArray *dateData;
@property (nonatomic,strong) UIButton * orderBtn;
@end

@implementation TEClassListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configNav];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self buildData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:[TELessonCell class] forCellReuseIdentifier:@"lessonCell"];
    [self.tableView registerClass:[TELessonHeaderView class] forHeaderFooterViewReuseIdentifier:@"lessonHeader"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 88, 0)];
    
    _orderBtn = [UIButton new];
    [_orderBtn setFrame:CGRectMake(0, 0, 48, 48)];
    [_orderBtn setBackgroundImage:[UIImage imageNamed:@"orderLessonBtn"] forState:UIControlStateNormal];
    [_orderBtn.layer setCornerRadius:24.0];
    [_orderBtn.layer setMasksToBounds:YES];
    [_orderBtn addTarget:self action:@selector(orderBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_orderBtn];
    
    if ([[[TELoginManager sharedManager] currentTEUser] type] == TEUserTypeTeacher) {
        [_orderBtn setHidden:YES];
        [self.tableView setContentInset:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configNav{
    [super configNav];
    UIBarButtonItem *allClassesBtn = [[UIBarButtonItem alloc] initWithTitle:@"全部课程" style:UIBarButtonItemStylePlain target:self action:@selector(showAllClasses)];
    [self.navigationItem setRightBarButtonItem:allClassesBtn];
}

#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [_tableView reloadData];
}
#pragma mark - Business
- (void)showAllClasses{
    
}
#pragma mark - 
- (void)lessonActionWith:(TELessonCellActionType)type andIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"type:%ld,section:%ld,row:%ld",type,indexPath.section,indexPath.row);
    
    if (type == LessonActionTypeShowContent) {
        
        TECourseContentViewController *vc = [[TECourseContentViewController alloc] initWithTitle:@"" statusStyle:UIStatusBarStyleLightContent showNaviBar:NO naviType:TENaviTypeImage naviColor:nil naviBlur:NO orientationMask:UIInterfaceOrientationMaskLandscape];
        TELesson* lesson = _lessonData[indexPath.section][indexPath.row];
        vc.unitID = lesson.unitID;
        vc.lessonID = lesson.lessonID;
//        TENavigationViewController *navi = [[TENavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:vc animated:NO completion:nil];
//        [self.navigationController pushViewController:vc animated:YES];
    }else if (type == LessonActionTypeStartLesson){
        TELesson* lesson = _lessonData[indexPath.section][indexPath.row];
        if ([[TELoginManager sharedManager] currentTEUser].type == TEUserTypeTeacher) {
            [self requestChatroomWithLesson:[TELoginManager sharedManager].currentTEUser.nimAccount lessonID:lesson.lessonID];
        }else{
            
            if (lesson.nimID.length) {
                [self reserveNetCallMeeting:lesson.nimID];
            }else{
                NSLog(@"教师尚未开始授课");
                [self refreshData];
            }
            
        }
        
    }
    
}

- (void)requestChatroomWithLesson:(NSString *)lesson lessonID:(NSInteger)lessonID{
    [[TENIMService sharedService] requestMeeting:lesson completion:^(NSError *error, NSString *meetingRoomID) {
        if (!error) {
            NSLog(@"meetingRoomID:%@",meetingRoomID);
            
            TECommonPostTokenApi *api = [[TECommonPostTokenApi alloc] initWithToken:[TELoginManager sharedManager].currentTEUser.token type:TETokenApiTypeSetNIMID userType:[TELoginManager sharedManager].currentTEUser.type lessonID:lessonID nimID:meetingRoomID];
            [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                NSDictionary *dic = request.responseJSONObject;
                NSDictionary *content = dic[@"content"];
                NSInteger status = [content[@"status"] integerValue];
                
                if (status == 1) {
                    [self reserveNetCallMeeting:meetingRoomID];
                }else{
                    NSLog(@"修改nim失败");
                }
                
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                
            }];
            
        }else{
            NSLog(@"创建聊天室失败");
        }
    }];
}
- (void)reserveNetCallMeeting:(NSString *)roomId{
    NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
    meeting.name = roomId;
    meeting.type = NIMNetCallTypeVideo;
    meeting.ext = @"text extend meetingmessage";
    
    [[NIMSDK sharedSDK].netCallManager reserveMeeting:meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
        if (!error) {
            NSLog(@"预约会议成功，%@",meeting.name);
            [self enterChatRoom:meeting.name];
        }else{
            NSLog(@"预约会议失败%ld,%@",error.code,error.description);
            //417重复操作
            if (error.code == NIMRemoteErrorCodeExist) {
                [self enterChatRoom:meeting.name];
            }
        }
    }];
}
- (void)enterChatRoom:(NSString *)roomId{
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = roomId;
    //允许自定义昵称头像
    
    [[[NIMSDK sharedSDK] chatroomManager] enterChatroom:request completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
        if (!error) {
            NSLog(@"加入会议成功！Chatroom:%@ ,me:%@, creator:%@",chatroom.roomId,me.roomNickname,chatroom.creator);
            
            [[TEMeetingManager sharedService] cacheMyInfo:me roomID:request.roomId];
            [[TEMeetingRolesManager sharedService] startNewMeeting:me withChatroom:chatroom newCreated:[TELoginManager sharedManager].currentTEUser.type == TEUserTypeTeacher?YES:NO];
            
            TELessonViewController *vc = [[TELessonViewController alloc] initWithNIMChatroom:chatroom];
            [self presentViewController:vc animated:YES completion:nil];
            
        }else{
            NSLog(@"加入会议失败%ld,%@",error.code,error.description);
            
            //404对象不存在
        }
    }];
    
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_lessonData[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_lessonData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TELessonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lessonCell"];
    cell.data = _lessonData[indexPath.section][indexPath.row];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TELessonHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"lessonHeader"];
    header.headerStr = _dateData[section];
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
- (NSMutableArray *)lessonData{
    if (!_lessonData) {
        _lessonData = [NSMutableArray array];
    }
    return _lessonData;
}
- (void)buildData{
    
    TETokenApiType apiType;
    
    if ([TELoginManager sharedManager].currentTEUser.type == TEUserTypeStudent) {
        apiType = TETokenApiTypeGetReservedLessons;
    }else if ([TELoginManager sharedManager].currentTEUser.type == TEUserTypeTeacher){
        apiType = TETokenApiTypeGetLessonsBeReserved;
    }
    
    TECommonPostTokenApi *api = [[TECommonPostTokenApi alloc] initWithToken:[[[TELoginManager sharedManager] currentTEUser] token]type:apiType];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",(NSDictionary *)request.responseJSONObject);
        NSDictionary *dic = request.responseJSONObject;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            if ([dic[@"content"] isKindOfClass:[NSArray class]]) {
                NSLog(@"data format valid");
                NSArray *jsonAry = dic[@"content"];
                if (jsonAry.count == 0) {
                    return;
                }
                
                
                NSMutableArray *timeOriginalAry = [NSMutableArray array];
                [jsonAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dicObj = obj;
                    NSString *date = dicObj[@"date"];
                    [timeOriginalAry addObject:date];
                }];
                
                NSSet *timeSet = [NSSet setWithArray:timeOriginalAry];
                NSArray *timeSetAry = [timeSet allObjects];
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
                _dateData = [timeSetAry sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
                
                [self.lessonData removeAllObjects];
                
                [_dateData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableArray *sectionAry = [NSMutableArray array];
                    [_lessonData addObject:sectionAry];
                }];
                
                [jsonAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TELesson *lesson = [[TELesson alloc] initWithDictionary:(NSDictionary*)obj userType:[TELoginManager sharedManager].currentTEUser.type];
                    for (NSString *dateStr in _dateData) {
                        if ([dateStr isEqualToString:lesson.date]) {
                            NSMutableArray *lessonAry = [_lessonData objectAtIndex:[_dateData indexOfObject:dateStr]];
                            [lessonAry addObject:lesson];
                        }
                    }
                }];
                
                [_tableView reloadData];
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (void)refreshData{
    [self buildData];
    [self.tableView reloadData];
}

- (void)orderBtnTouchAction:(id)sender{
    TEChooseLessonViewController *vc = [[TEChooseLessonViewController alloc] initWithTitle:@"选择课程" statusStyle:UIStatusBarStyleLightContent showNaviBar:YES naviType:TENaviTypeImage naviColor:SystemBlueColor naviBlur:NO orientationMask:UIInterfaceOrientationMaskPortrait];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _tableView.left = 0;
    _tableView.top = 0;
    _tableView.width = self.view.width;
    _tableView.height = self.view.height;
    
    _orderBtn.top = self.view.height- 48.0-49.0-20.0;
    _orderBtn.centerX = self.view.centerX;
}
@end
