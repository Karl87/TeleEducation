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
#import "TEWhiteboardColorSelectView.h"
#import "TEWhiteboardWidthSelectView.h"

#import "TECourseContentApi.h"
#import "TELoginManager.h"
#import "UIImageView+WebCache.h"
#import "TENetworkConfig.h"

@interface TEWhiteboardViewController ()<TEMeetingRTSManagerDelegate,TEWhiteboardCmdHandlerDelegate,NIMLoginManagerDelegate,TEWhiteboardWidthSelectViewDelegate,TEWhiteboardColorSelectViewDelegate>{
    BOOL _isManager;
    NSString *_name;
    NSString *_managerUid;
    int _myDrawColorRGB;
    float _myDrawLineWidth;
    BOOL _isJoined;
}

@property (nonatomic,strong) TEWhiteboardDrawView *drawView;
@property (nonatomic,strong) NSMutableArray *contents;
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
@property (nonatomic,strong) UIButton *widthBtn;
@property (nonatomic,strong) NSArray *colors;
@property (nonatomic,strong) NSArray *widths;
@property (nonatomic,strong) TEWhiteboardWidthSelectView *widthView;
@property (nonatomic,strong) TEWhiteboardColorSelectView *colorView;

@property (nonatomic,assign) int currentPage;

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

- (void)buildData{
    TECourseContentApi *api = [[TECourseContentApi alloc] initWithToken:[[[TELoginManager sharedManager] currentTEUser] token] unit:_unitID lesson:_lessonID];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        NSLog(@"%@",request.responseJSONObject);
        NSDictionary *dic = request.responseJSONObject;
        if ([dic[@"code"]integerValue] != 1) {
            return;
        }
        if (![dic[@"content"] isKindOfClass:[NSArray class]]) {
            return;
        }
        NSArray *ary = dic[@"content"];
        [ary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.contents addObject:obj[@"url"]];
        }];
        
        for (int i = 0; i<_contents.count; i++) {
            TEWhiteboardLines *lines = [[TEWhiteboardLines alloc] init];
            [_allLines addObject:lines];
        }

        self.currentPage = 0;
        _drawView.dataSource = _allLines[_currentPage];

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom{
    self = [super init];
    if (self) {
        
        _contents = [NSMutableArray array];
//        _contents = @[@"11.png",@"12.png"];
        _name = chatroom.roomId;
        _managerUid = chatroom.creator;
        _cmdHandler = [[TEWhiteboardCmdHandler alloc] initWithDelegate:self];
        [[TEMeetingRTSManager sharedService] setDataHandler:_cmdHandler];
        _colors = @[@(0x000000), @(0xd1021c), @(0xfddc01), @(0x7dd21f), @(0x228bf7), @(0x9b0df5)];
        _widths = @[@(2.0),@(4.0),@(8.0),@(16.0)];
        _myDrawColorRGB = [_colors[0] intValue];
        _myDrawLineWidth = [_widths[0] floatValue];
        
//        _lines = [[TEWhiteboardLines alloc] init];
        
        _allLines = [NSMutableArray array];
        
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
//    if (_isManager) {
        error = [[TEMeetingRTSManager sharedService] reserveConference:_name];
//    }else{
//        error = [[TEMeetingRTSManager sharedService] joinConference:_name];
//    }
    if (error) {
        NSLog(@"Error %zd reserve/join rts conference: %@", error.code, _name);
    }
    
    [self initUI];
    [self buildData];
}
- (void)initUI{
    
    _contentView = [UIImageView new];
    [_contentView setBackgroundColor:[UIColor whiteColor]];
    [_contentView setContentMode:UIViewContentModeScaleAspectFit];
    [_contentView setClipsToBounds:YES];
//    [_contentView setImage:[UIImage imageNamed:_contents[_currentPage]]];
    [self.view addSubview:_contentView];
    
    [self.view addSubview:self.drawView];
    
    _pannel = [UIView new];
    [self.view addSubview:_pannel];

    _lastBtn = [UIButton new];
    [_lastBtn setTintColor:SystemBlueColor];
    [_lastBtn setImage:[[UIImage imageNamed:@"pageLast"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_lastBtn addTarget:self action:@selector(onLastPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_pannel addSubview:_lastBtn];
    
    _pageLab = [UILabel new];
    [_pageLab setTextColor:SystemBlueColor];
    [_pageLab setTextAlignment:NSTextAlignmentCenter];
    [_pageLab setText:@"0 / 0"];
    [_pageLab setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:21]];
    [_pannel addSubview:_pageLab];
    
    _nextBtn = [UIButton new];
    [_nextBtn setTintColor:SystemBlueColor];
    [_nextBtn addTarget:self action:@selector(onNextPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_nextBtn setImage:[[UIImage imageNamed:@"pageNext"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_pannel addSubview:_nextBtn];
    
    [_pannel addSubview:self.colorBtn];
    [_pannel addSubview:self.widthBtn];
    [_pannel addSubview:self.cancelBtn];
    [_pannel addSubview:self.clearBtn];
    
    [self.view addSubview:self.colorView];
    self.colorView.hidden =YES;
    [self.view addSubview:self.widthView];
    self.widthView.hidden = YES;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
        _cancelBtn.layer.cornerRadius = 35/2;
        [_cancelBtn addTarget:self action:@selector(onCancelLinePressed:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setImage:[UIImage imageNamed:@"btn_whiteboard_cancel"] forState:normal];
        [_cancelBtn setBackgroundColor:SystemBlueColor];
//        [_cancelBtn setTitle:@"撤" forState:UIControlStateNormal];
    }
    return _cancelBtn;
}

- (UIButton *)clearBtn{
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
        _clearBtn.layer.cornerRadius = 35/2;
        [_clearBtn addTarget:self action:@selector(onClearAllPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_clearBtn setImage:[UIImage imageNamed:@"btn_whiteboard_clear"] forState:UIControlStateNormal];
        [_clearBtn setBackgroundColor:SystemBlueColor];
        if (![TEMeetingRolesManager sharedService].myRole.isManager) {
            _clearBtn.hidden = YES;
        }
//        [_clearBtn setTitle:@"清" forState:UIControlStateNormal];
    }
    return _clearBtn;
}

- (UIButton *)colorBtn{
    if (!_colorBtn) {
        _colorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
        _colorBtn.layer.cornerRadius = 35/2;
        [_colorBtn setBackgroundColor:SystemBlueColor];
        [_colorBtn setTintColor:UIColorFromRGB(_myDrawColorRGB)];
        [_colorBtn setImage:[[UIImage imageNamed:@"btn_whiteboard_color"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_colorBtn addTarget:self action:@selector(onColorSelectPressed:) forControlEvents:UIControlEventTouchUpInside];
        
//        UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(9.f, 9.f, 17.f, 17.f)];
//        circle.layer.cornerRadius = 17.f / 2.f;
//        circle.layer.borderColor = [UIColor whiteColor].CGColor;
//        circle.layer.borderWidth = 1;
//        [circle setUserInteractionEnabled:NO];
//        [_colorBtn addSubview:circle];
    }
    return _colorBtn;
}

- (TEWhiteboardColorSelectView *)colorView{
    if (!_colorView) {
        _colorView = [[TEWhiteboardColorSelectView alloc] initWithFrame:CGRectZero colors:_colors delegate:self];
    }
    return _colorView;
}

- (UIButton *)widthBtn{
    if (!_widthBtn) {
        _widthBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
        _widthBtn.layer.cornerRadius = 35/2;
        [_widthBtn setBackgroundColor:SystemBlueColor];
        [_widthBtn setTitle:[NSString stringWithFormat:@"%.1f",_myDrawLineWidth] forState:UIControlStateNormal];
        [_widthBtn addTarget:self action:@selector(onWidthSelectPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _widthBtn;
}

- (TEWhiteboardWidthSelectView *)widthView{
    if (!_widthView) {
        _widthView = [[TEWhiteboardWidthSelectView alloc] initWithFrame:CGRectZero widths:_widths delegate:self];
    }
    return _widthView;
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
    
//    NSLog(@"-----%f,-----%f",dWidth,dHeight);
    
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
    _pannel.top = dHeight - 40;
    _pannel.height = 34;
    
    
    
    _pageLab.centerY = _pannel.height/2;
    _pageLab.centerX  =_pannel.width/2;
    _pageLab.width = 80;
    _pageLab.height = 34;
    
    _lastBtn.centerY = _pannel.height/2;
    _lastBtn.right = _pageLab.left - 15;
    _lastBtn.width = 34;
    _lastBtn.height = 34;
    
    _nextBtn.centerY = _pannel.height/2;
    _nextBtn.left = _pageLab.right + 15;
    _nextBtn.width = 34;
    _nextBtn.height = 34;
    
    _colorBtn.left = _nextBtn.right + 20;
    _colorBtn.centerY = _nextBtn.centerY;
    
    _widthBtn.left = _colorBtn.right + 20;
    _widthBtn.centerY = _colorBtn.centerY;
    
    _cancelBtn.right = _lastBtn.left - 20;
    _cancelBtn.centerY = _colorBtn.centerY;
    
    _clearBtn.right = _cancelBtn.left -20;
    _clearBtn.centerY = _colorBtn.centerY;
    
    
    self.colorView.width = 34;
    self.colorView.height = self.colorView.width*_colors.count;
    self.colorView.centerX = self.colorBtn.centerX;
    self.colorView.bottom = self.pannel.top - 3.5;
    
    self.widthView.width = 34;
    self.widthView.height = self.widthView.width*_widths.count;
    self.widthView.centerX = self.widthBtn.centerX;
    self.widthView.bottom = self.pannel.top - 3.5;

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
    [self.colorView setHidden:!(self.colorView.hidden)];
}


- (void)onColorSelected:(int)rgbColor
{
    [self.colorBtn setTintColor:UIColorFromRGB(rgbColor)];
    _myDrawColorRGB = rgbColor;
    [self.colorView setHidden:YES];
}

- (void)onWidthSelectPressed:(id)sender
{
    [self.widthView setHidden:!(self.widthView.hidden)];
}


- (void)onWidthSelected:(float)width
{
    [_widthBtn setTitle:[NSString stringWithFormat:@"%.1f",width] forState:UIControlStateNormal];
    _myDrawLineWidth = width;
    [self.widthView setHidden:YES];
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
- (void)setCurrentPage:(int)currentPage{
    _currentPage = currentPage;
    [_pageLab setText:[NSString stringWithFormat:@"%d / %ld",_currentPage+1,self.contents.count]];
    
    [_contentView sd_setImageWithURL:[NSURL URLWithString:[[[TENetworkConfig sharedConfig] baseURL] stringByAppendingString:_contents[_currentPage]]] placeholderImage:nil];
    
    TEWhiteboardLines *lines = _allLines[_currentPage];
    lines.hasUpdate = YES;
    [_drawView setDataSource:lines];
    
}
#pragma mark  - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.colorView.hidden = YES;
    self.widthView.hidden = YES;
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
    point.lineWidth = _myDrawLineWidth;
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
