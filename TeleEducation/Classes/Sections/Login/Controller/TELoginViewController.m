//
//  TELoginViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/2/20.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TELoginViewController.h"
#import "UIImage+TEColor.h"
#import "TERegisterViewController.h"
#import "TEResetPasswordViewController.h"
#import "TELoginManager.h"
#import "TELoginInput.h"
#import "NSString+TE.h"

@interface TELoginViewController ()<TELoginManagerDelegate>

@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) TELoginInput *userInput;
@property (nonatomic,strong) TELoginInput *passwordInput;
@property (nonatomic,strong) UIButton *resetPasswordBtn;
@property (nonatomic,strong) UIButton *registerBtn;
@property (nonatomic,strong) UIImageView *logoView;
@property (nonatomic,strong) UIImageView *titleView;

//@property (nonatomic,strong) UISwitch * teacherSwitch;
@property (nonatomic,strong) UISegmentedControl *userTypeSeg;
@end

@implementation TELoginViewController

#pragma mark
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configView];
}
- (void)dealloc{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configView{
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _logoView = [UIImageView new];
    [_logoView setImage:[UIImage imageNamed:@"loginLogo"]];
    [self.view addSubview:_logoView];
    
    _titleView = [UIImageView new];
    [_titleView setImage:[UIImage imageNamed:@"loginTitle"]];
    [self.view addSubview:_titleView];
    
    _userInput = [[TELoginInput alloc] initWithPlaceHolder:Babel(@"login_input_phone") image:[UIImage imageNamed:@"loginPhoneIcon"] isSecureTextEntry:NO];
    _userInput.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:_userInput];
    
    _passwordInput = [[TELoginInput alloc] initWithPlaceHolder:Babel(@"login_input_psw") image:[UIImage imageNamed:@"loginPswIcon"] isSecureTextEntry:YES];
    [self.view addSubview:_passwordInput];
    
    _loginBtn = [UIButton new];
    [_loginBtn setBackgroundImage:[UIImage imageWithColor:SystemBlueColor] forState:UIControlStateNormal];
    [_loginBtn setTitle:Babel(@"login") forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn.layer setCornerRadius:8.0f];
    [_loginBtn.layer setMasksToBounds:YES];
    [_loginBtn addTarget:self action:@selector(loginBtnActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    
    NSString *no_account = Babel(@"no_account");
    NSString *register_now = Babel(@"register_now");
    NSString *append = [NSString stringWithFormat:@"%@%@",no_account,register_now];
    
    NSMutableAttributedString *registerBtnStrNormal = [[NSMutableAttributedString alloc] initWithString:append];
    [registerBtnStrNormal addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor],
                                    NSFontAttributeName : [UIFont systemFontOfSize:13.0]}
                            range:NSMakeRange(0, no_account.length)];
    [registerBtnStrNormal addAttributes:@{NSForegroundColorAttributeName : SystemBlueColor,
                                    NSFontAttributeName : [UIFont systemFontOfSize:13.0]}
                            range:NSMakeRange(no_account.length, register_now.length)];
    NSMutableAttributedString *registerBtnStrHighLight = [[NSMutableAttributedString alloc] initWithString:append];
    [registerBtnStrHighLight addAttributes:@{NSForegroundColorAttributeName : [UIColor groupTableViewBackgroundColor],
                                          NSFontAttributeName : [UIFont systemFontOfSize:13.0]}
                                  range:NSMakeRange(0, registerBtnStrHighLight.length)];
    _registerBtn = [UIButton new];
    [_registerBtn setBackgroundColor:[UIColor clearColor]];
    [_registerBtn setAttributedTitle:registerBtnStrNormal forState:UIControlStateNormal];
    [_registerBtn setAttributedTitle:registerBtnStrHighLight forState:UIControlStateHighlighted];
    [_registerBtn sizeToFit];
    [_registerBtn addTarget:self action:@selector(registerBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
    _resetPasswordBtn = [UIButton new];
    [_resetPasswordBtn setBackgroundColor:[UIColor clearColor]];
    [_resetPasswordBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [_resetPasswordBtn setTitle:Babel(@"forget_psw") forState:UIControlStateNormal];
    [_resetPasswordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_resetPasswordBtn setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateHighlighted];
    [_resetPasswordBtn sizeToFit];
    [_resetPasswordBtn addTarget:self action:@selector(resetPasswordBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resetPasswordBtn];
    
//    _teacherSwitch = [UISwitch new];
//    _teacherSwitch.on = NO;
//    [_teacherSwitch sizeToFit];
//    [self.view addSubview:_teacherSwitch];
    
    
    _userTypeSeg = [[UISegmentedControl alloc] initWithItems:@[Babel(@"user_student"),Babel(@"user_teacher")]];
    [_userTypeSeg setTintColor:SystemBlueColor];
    [_userTypeSeg setSelectedSegmentIndex:0];
    [_userTypeSeg sizeToFit];
    [self.view addSubview:_userTypeSeg];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _userInput.left = 20;
    _userInput.width = self.view.width - 40;
    _userInput.height = 44;
    _userInput.top = (self.view.height - _userInput.height)/2;
    
//    _teacherSwitch.left = 20;
//    _teacherSwitch.top = _userInput.top - _teacherSwitch.height - 20;

    
    _userTypeSeg.centerX = self.view.width/2;
    _userTypeSeg.bottom = _userInput.top - 20;
    
    _passwordInput.left = _userInput.left;
    _passwordInput.top = _userInput.bottom + 20;
    _passwordInput.width = _userInput.width;
    _passwordInput.height = _userInput.height;
    
    _loginBtn.left = _userInput.left;
    _loginBtn.top = _passwordInput.bottom + 20;
    _loginBtn.width = _userInput.width;
    _loginBtn.height = 40;
    
    _resetPasswordBtn.left = 24;
    _resetPasswordBtn.top = _loginBtn.bottom + 16;
    
    _registerBtn.left = self.view.width - 24 - _registerBtn.width;
    _registerBtn.top = _resetPasswordBtn.top;
    
    _titleView.width = 125;
    _titleView.height =18;
    _titleView.left = (self.view.width-_titleView.width)/2;
    _titleView.top = _userInput.top - _titleView.height - 80;

    _logoView.width = 72;
    _logoView.height = 72;
    _logoView.left = (self.view.width - _logoView.width)/2;
    _logoView.top = _titleView.top - _logoView.height - 11;
}


#pragma mark - EventHandler
- (void)loginBtnActionHandler:(id)sender{
    [[TELoginManager sharedManager] loginWithUserName:_userInput.text.copy password:[_passwordInput.text.copy MD5String] userType:_userTypeSeg.selectedSegmentIndex == 1?TEUserTypeTeacher:TEUserTypeStudent];
}
- (void)resetPasswordBtnHandler:(UIButton *)button{
    TEResetPasswordViewController *vc = [[TEResetPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)registerBtnHandler:(UIButton *)button{
    TERegisterViewController *vc = [[TERegisterViewController alloc]
                                    initWithTitle:Babel(@"register")
                                    statusStyle:UIStatusBarStyleLightContent
                                    showNaviBar:YES
                                    naviType:TENaviTypeImage
                                    naviColor:SystemBlueColor
                                    naviBlur:NO
                                    orientationMask:UIInterfaceOrientationMaskPortrait];
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Private


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_userInput resignFirstResponder];
    [_passwordInput resignFirstResponder];
}


@end
