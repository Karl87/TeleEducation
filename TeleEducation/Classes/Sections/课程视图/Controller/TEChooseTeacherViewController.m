//
//  TEChooseTeacherViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/2/24.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEChooseTeacherViewController.h"
#import "NIMCommonTableData.h"
#import "UIView+TE.h"
#import "TEChooseTimeViewController.h"
#import "TEChooseTeacherCell.h"

#import "TECommonPostTokenApi.h"
#import "TELoginManager.h"
#import "TETeacher.h"

#import "TEOrderLessonManager.h"
#import "TELesson.h"

@interface TEChooseTeacherViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
@end

@implementation TEChooseTeacherViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:UIColorFromRGB(0xf5f3f4)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[TEChooseTeacherCell class] forCellReuseIdentifier:@"teacherCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self buildData];

}
- (NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)buildData{
    
    TECommonPostTokenApi *api = [[TECommonPostTokenApi alloc] initWithToken:[[[TELoginManager sharedManager] currentTEUser] token] type:TETokenApiTypeGetTeacheres unit:[TEOrderLessonManager sharedManager].lesson.unitID course:[TEOrderLessonManager sharedManager].lesson.lessonID];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseJSONObject);
        
        NSDictionary *dic = request.responseJSONObject;
        NSInteger apiCode = [dic[@"code"] integerValue];
        
        NSArray *content = dic[@"content"];
        [self.data removeAllObjects];
        [content enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TETeacher *teacher = [[TETeacher alloc] initWithDictionary:obj];
            [self.data addObject:teacher];
        }];
        
        [_tableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}


#pragma mark - 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TEChooseTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teacherCell"];
    cell.data = _data[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TEChooseTimeViewController *vc = [[TEChooseTimeViewController alloc] initWithTitle:@"" statusStyle:UIStatusBarStyleLightContent showNaviBar:NO naviType:TENaviTypeImage naviColor:SystemBlueColor naviBlur:NO orientationMask:UIInterfaceOrientationMaskPortrait];
    TETeacher *teacher = _data[indexPath.row];
    [TEOrderLessonManager sharedManager].lesson.teacher = nil;
    [TEOrderLessonManager sharedManager].lesson.teacher = [teacher copy];

    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableView.top = 0;
    _tableView.left = 0;
    _tableView.width = self.view.width;
    _tableView.height = self.view.height;
}
#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    [_tableView reloadData];
    
}
@end
