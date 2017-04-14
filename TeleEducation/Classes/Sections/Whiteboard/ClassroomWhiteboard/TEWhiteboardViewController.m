//
//  TEWhiteboardViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/3/15.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEWhiteboardViewController.h"
#import "TEMeetingRolesManager.h"
#import "TEMeetingRTSManager.h"
#import "TEWhiteboardCommand.h"
#import "TEWhiteboardCmdHandler.h"
#import "TEWhiteboardLines.h"
#import "TEWhiteboardDrawView.h"

@interface TEWhiteboardViewController ()<TEMeetingRTSManagerDelegate,TEWhiteboardCmdHandlerDelegate,NIMLoginManagerDelegate>{
    BOOL _isManager;
    NSString *_name;
    NSString *_managerUid;
    int _myDrawColorRGB;
    BOOL _isJoined;
}

@property (nonatomic,strong) TEWhiteboardDrawView *drawView;
@property (nonatomic,strong) NSArray *contents;
@property (nonatomic,strong) UIImageView *contentView;
@property (nonatomic, strong) NSMutableArray *allLines;
@property (nonatomic,strong) TEWhiteboardLines *lines;
@property (nonatomic,strong) TEWhiteboardCmdHandler *cmdHandler;
@property (nonatomic, strong) NSString *myUid;

@property (nonatomic,strong) UIView *pannel;
@property (nonatomic,strong) UIButton *lastBtn;
@property (nonatomic,strong) UIButton *nextBtn;
@property (nonatomic,strong) UILabel *pageLab;
@property (nonatomic,strong) UIButton *clearBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *colorBtn;
@property (nonatomic,strong) NSArray *colors;

@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation TEWhiteboardViewController
- (BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (instancetype)initWithChatroom:(NIMChatroom *)chatroom{
    self = [super init];
    if (self) {
        _contents = @[@"11.png",@"12.png"];
        _name = chatroom.roomId;
        _managerUid = chatroom.creator;
        _cmdHandler = [[TEWhiteboardCmdHandler alloc] initWithDelegate:self];
        [[TEMeetingRTSManager sharedService] setDataHandler:_cmdHandler];
        _colors = @[@(0x000000), @(0xd1021c), @(0xfddc01), @(0x7dd21f), @(0x228bf7), @(0x9b0df5)];
        _myDrawColorRGB = [_colors[0] intValue];
//        _lines = [[TEWhiteboardLines alloc] init];
        
        _allLines = [NSMutableArray array];
        for (int i = 0; i<_contents.count; i++) {
            TEWhiteboardLines *lines = [[TEWhiteboardLines alloc] init];
            [_allLines addObject:lines];
        }
        _currentPage = 0;
        _myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
    }
    return self;
}

- (void)dealloc{
    [[TEMeetingRTSManager sharedService] leaveCurrentConference];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    _isManager = [TEMeetingRolesManager sharedService].myRole.isManager;
    [[TEMeetingRTSManager sharedService] setDelegate:self];
    
    NSError *error;
    if (_isManager) {
        error = [[TEMeetingRTSManager sharedService] reserveConference:_name];
    }else{
        error = [[TEMeetingRTSManager sharedService] joinConference:_name];
    }
    if (error) {
        NSLog(@"Error %zd reserve/join rts conference: %@", error.code, _name);
    }
    
    [self initUI];
}
- (void)initUI{
    
    _contentView = [UIImageView new];
    [_contentView setBackgroundColor:[UIColor whiteColor]];
    [_contentView setContentMode:UIViewContentModeScaleAspectFit];
    [_contentView setClipsToBounds:YES];
    [_contentView setImage:[UIImage imageNamed:_contents[_currentPage]]];
    [self.view addSubview:_contentView];
    
    [self.view addSubview:self.drawView];
    _drawView.dataSource = _allLines[_currentPage];
    
    _pannel = [UIView new];
    [self.view addSubview:_pannel];

    _lastBtn = [UIButton new];
    [_lastBtn setTintColor:SystemBlueColor];
    [_lastBtn setImage:[[UIImage imageNamed:@"pageLast"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_lastBtn addTarget:self action:@selector(onLastPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_pannel addSubview:_lastBtn];
    
    _pageLab = [UILabel new];
    [_pageLab setTextAlignment:NSTextAlignmentCenter];
    [_pageLab setText:[NSString stringWithFormat:@"%ld/%ld",_currentPage+1,_contents.count]];
    [_pannel addSubview:_pageLab];
    
    _nextBtn = [UIButton new];
    [_nextBtn setTintColor:SystemBlueColor];
    [_nextBtn addTarget:self action:@selector(onNextPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setImage:[[UIImage imageNamed:@"pageNext"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_pannel addSubview:_nextBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkPermission];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGFloat dTop = self.view.top;
    CGFloat dLeft = self.view.left;
    CGFloat dWidth = self.view.width;
    CGFloat dHeight = self.view.height;
    
    NSLog(@"-----%f,-----%f",dWidth,dHeight);
    
    _drawView.top = dTop;
    _drawView.left = dLeft;
    _drawView.width = dWidth;
    _drawView.height = dHeight;
    
    _contentView.top = dTop;
    _contentView.left = dLeft;
    _contentView.width = dWidth;
    _contentView.height = dHeight;
    
    _pannel.left = dLeft;
    _pannel.width = dWidth;
    _pannel.top = dHeight - 30;
    _pannel.height = 30;
    
    
    
    _pageLab.centerY = _pannel.height/2;
    _pageLab.centerX  =_pannel.width/2;
    _pageLab.width = 50;
    _pageLab.height = 30;
    
    _lastBtn.centerY = _pannel.height/2;
    _lastBtn.right = _pageLab.left - 20;
    _lastBtn.width = 30;
    _lastBtn.height = 30;
    
    _nextBtn.centerY = _pannel.height/2;
    _nextBtn.left = _pageLab.right +10;
    _nextBtn.width = 30;
    _nextBtn.height = 30;
}

- (void)checkPermission{
    if ([TEMeetingRolesManager sharedService].myRole.whiteboardOn && _isJoined) {
        
    }else{
        
    }
}

- (TEWhiteboardDrawView *)drawView{
    if (!_drawView) {
        _drawView = [[TEWhiteboardDrawView alloc] initWithFrame:CGRectZero];
        _drawView.backgroundColor = [UIColor clearColor];
    }
    return _drawView;
}
- (TEWhiteboardLines *)currentLines{
    TEWhiteboardLines *lines = _allLines[_currentPage];
    return lines;
}
#pragma mark - User Interactions
- (void)onClearAllPressed:(id)sender
{
    [[self currentLines] clear];
    [_cmdHandler sendPureCmd:TEWhiteboardCmdTypeClearLines page:_currentPage to:nil];
}

- (void)onCancelLinePressed:(id)sender
{
    [[self currentLines] cancelLastLine:_myUid];
    [_cmdHandler sendPureCmd:TEWhiteboardCmdTypeCancelLine page:_currentPage to:nil];
}

- (void)onColorSelectPressed:(id)sender
{
//    [self.colorSelectView setHidden:!(self.colorSelectView.hidden)];
}

- (void)onColorSeclected:(int)rgbColor
{
//    [self.colorSelectButton setBackgroundColor:UIColorFromRGB(rgbColor)];
//    _myDrawColorRGB = rgbColor;
//    [self.colorSelectView setHidden:YES];
}
- (void)onLastPressed:(id)sender{
    if (self.contents.count != 0) {
        if (self.currentPage != 0) {
            self.currentPage -- ;
        }
    }
    
}
- (void)onNextPressed:(id)sender{
    if (self.contents.count != 0) {
        if (self.currentPage != self.contents.count - 1) {
            self.currentPage ++ ;
        }
    }
}
- (void)setCurrentPage:(NSInteger)currentPage{
    _currentPage = currentPage;
    [_pageLab setText:[NSString stringWithFormat:@"%ld/%ld",_currentPage+1,self.contents.count]];
    
    [_contentView setImage:[UIImage imageNamed:_contents[_currentPage]]];
    
    TEWhiteboardLines *lines = _allLines[_currentPage];
    lines.hasUpdate = YES;
    [_drawView setDataSource:lines];
    
}
#pragma mark  - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    self.colorSelectView.hidden = YES;
    CGPoint p = [[touches anyObject] locationInView:_drawView];
    [self onPointCollected:p type:TEWhiteboardPointTypeStart];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:_drawView];
    [self onPointCollected:p type:TEWhiteboardPointTypeMove];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:_drawView];
    [self onPointCollected:p type:TEWhiteboardPointTypeEnd];
}

- (void)onPointCollected:(CGPoint)p type:(TEWhiteboardPointType)type
{
    if (!([TEMeetingRolesManager sharedService].myRole.whiteboardOn)) {
        NSLog(@"whiteboard not on");
        return;
    }
    
    if (!_isJoined) {
        NSLog(@"not joined");
        return;
    }
    
//    if (p.x < 0 || p.y < 0 || p.x > _drawView.frame.size.width || p.y > _drawView.frame.size.height){
//        NSLog(@"point invalid");
//        return;
//    }
    
    TEWhiteboardPoint *point = [[TEWhiteboardPoint alloc] init];
    point.type = type;
    point.xScale = p.x/_drawView.frame.size.width;
    point.yScale = p.y/_drawView.frame.size.height;
    point.colorRGB = _myDrawColorRGB;
    point.page = _currentPage;
    [_cmdHandler sendMyPoint:point];
    [[self currentLines] addPoint:point uid:_myUid];
}
# pragma mark - NTESMeetingRTSManagerDelegate
- (void)onReserve:(NSString *)name result:(NSError *)result
{
    if (result == nil) {
        NSError *result = [[TEMeetingRTSManager sharedService] joinConference:_name];
        NSLog(@"预定白板成功 join rts conference: %@ result %zd", _name, result.code);
    }
    else {
        NSLog(@"预定白板失败 join rts conference error: %@ result %zd", _name, result.code);
//        [self.view makeToast:[NSString stringWithFormat:@"预订白板出错:%zd", result.code]];
    }
}

- (void)onJoin:(NSString *)name result:(NSError *)result
{
    if (result == nil) {
        _isJoined = YES;
        [self checkPermission];
        
        if (_isManager) {
            
            for (int i = 0; i<_contents.count; i++) {
                [_cmdHandler sendPureCmd:TEWhiteboardCmdTypeSyncPrepare to:nil];
                if ([(TEWhiteboardLines*)_allLines[i] hasLines]) {
                    [_cmdHandler sync:[(TEWhiteboardLines*)_allLines[i] allLines] toUser:nil];
                }
            }
            
            
        }
        else {
            
            for (int i = 0; i<_contents.count; i++) {
                [(TEWhiteboardLines*)_allLines[i] clear];

            }
            [_cmdHandler sendPureCmd:TEWhiteboardCmdTypeSyncRequest to:_managerUid];
        }
    }
}

- (void)onLeft:(NSString *)name error:(NSError *)error
{
//    [self.view makeToast:[NSString stringWithFormat:@"已离开白板:%zd", error.code]];
    _isJoined = NO;
    
    NSError *result = [[TEMeetingRTSManager sharedService] joinConference:_name];
    NSLog(@"Rejoin rts conference: %@ result %zd", _name, result.code);
    
    [self checkPermission];
}

- (void)onUserJoined:(NSString *)uid conference:(NSString *)name
{
    
}

- (void)onUserLeft:(NSString *)uid conference:(NSString *)name
{
    
}

#pragma mark - NTESWhiteboardCmdHandlerDelegate
- (void)onReceivePoint:(TEWhiteboardPoint *)point from:(NSString *)sender
{
    TEWhiteboardLines *lines = (TEWhiteboardLines *)_allLines[point.page];
    [lines addPoint:point uid:sender];
}

- (void)onReceiveCancelLinePage:(int)page from:(NSString *)sender{
    TEWhiteboardLines *lines = (TEWhiteboardLines *)_allLines[page];
    [lines cancelLastLine:sender];
}

- (void)onReceiveClearLinePage:(int)page from:(NSString *)sender{
    TEWhiteboardLines *lines = (TEWhiteboardLines *)_allLines[page];
    [lines clear];
    [_cmdHandler sendPureCmd:TEWhiteboardCmdTypeClearLinesAck page:page to:nil];
}

- (void)onReceiveClearLineAckPage:(int)page from:(NSString *)sender{
    TEWhiteboardLines *lines = (TEWhiteboardLines *)_allLines[page];
    [lines clearUser:sender];
}

- (void)onReceiveCmd:(TEWhiteboardCmdType)type from:(NSString *)sender
{
    if (type == TEWhiteboardCmdTypeCancelLine) {
//        [_lines cancelLastLine:sender];
    }
    else if (type == TEWhiteboardCmdTypeClearLines) {
//        [_lines clear];
//        [_cmdHandler sendPureCmd:TEWhiteboardCmdTypeClearLinesAck to:nil];
    }
    else if (type == TEWhiteboardCmdTypeClearLinesAck) {
//        [_lines clearUser:sender];
    }
    else if (type == TEWhiteboardCmdTypeSyncPrepare) {
//        [_lines clear];
//        [_cmdHandler sendPureCmd:TEWhiteboardCmdTypeSyncPrepareAck to:sender];
    }
}

- (void)onReceiveSyncRequestFrom:(NSString *)sender
{
//    if (_isManager) {
//        [_cmdHandler sync:[_lines allLines] toUser:sender];
//    }
    
}

- (void)onReceiveSyncPoints:(NSMutableArray *)points owner:(NSString *)owner
{
//    [_lines clearUser:owner];
//    
//    for (TEWhiteboardPoint *point in points) {
//        [_lines addPoint:point uid:owner];
//    }
}

#pragma mark - NIMLoginManagerDelegate
- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepLoginOK) {
        
        if (!_isJoined) {
            NSError *result = [[TEMeetingRTSManager sharedService] joinConference:_name];
            NSLog(@"Rejoin rts conference: %@ result %zd", _name, result.code);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
