//
//  TERegisterViewController.m
//  TeleEducation
//
//  Created by Karl on 2017/2/20.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TERegisterViewController.h"
#import "TELoginInput.h"
#import "TELoginManager.h"
#import "NSString+TE.h"



@interface TERegisterViewController ()

@end

@implementation TERegisterViewController{
    TELoginInput *_name;
    TELoginInput *_phone;
    TELoginInput *_code;
    TELoginInput *_psw;
    UIButton *_register;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    _name = [[TELoginInput alloc] initWithPlaceHolder:@"请输入姓名" image:[UIImage imageNamed:@"registerNameIcon"] isSecureTextEntry:NO];
    [self.view addSubview:_name];
    
    _phone = [[TELoginInput alloc] initWithPlaceHolder:@"请输入手机号码" image:[UIImage imageNamed:@"loginPhoneIcon"] isSecureTextEntry:NO];
    _phone.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:_phone];
    
    _code = [[TELoginInput alloc] initWithPlaceHolder:@"请输入短信验证码" image:[UIImage imageNamed:@"registerCodeIcon"] isSecureTextEntry:NO];
    [self.view addSubview:_code];
    
    _psw = [[TELoginInput alloc] initWithPlaceHolder:@"请输入密码" image:[UIImage imageNamed:@"loginPswIcon"] isSecureTextEntry:YES];
    [self.view addSubview:_psw];
    
    _register = [UIButton new];
    [_register setBackgroundImage:[UIImage imageWithColor:SystemBlueColor] forState:UIControlStateNormal];
    [_register setTitle:@"注册" forState:UIControlStateNormal];
    [_register setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_register.layer setCornerRadius:8.0f];
    [_register.layer setMasksToBounds:YES];
    [_register addTarget:self action:@selector(registerBtnActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_register];

}
- (void)registerBtnActionHandler:(id)sender{
    [[TELoginManager sharedManager] registerWithUserName:_name.text.copy phone:_phone.text.copy password:[_psw.text.copy MD5String]];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat width = self.view.width;
//    CGFloat height = self.view.height;
    
    _name.left = 20;
    _name.top = 15 + 64;
    _name.width = width - 40;
    _name.height = 44;
    
    _phone.left = 20;
    _phone.top = _name.bottom + 20;
    _phone.width = _name.width;
    _phone.height = 44;
    
    _code.left  =20;
    _code.top = _phone.bottom + 20;
    _code.width  =_name.width;
    _code.height = 44;
    
    _psw.left  =20;
    _psw.top = _code.bottom +20;
    _psw.width = _name.width;
    _psw.height  =44;
    
    _register.left  =20;
    _register.top = _psw.bottom + 44;
    _register.width = _name.width;
    _register.height = 40;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
