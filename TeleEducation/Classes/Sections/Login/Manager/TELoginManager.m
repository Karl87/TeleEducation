//
//  TELoginManager.m
//  TeleEducation
//
//  Created by Karl on 2017/2/21.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TELoginManager.h"
#import "TEFileLocationHelper.h"
#import "TELoginApi.h"
#import "TERegisterApi.h"
#import "TEUserInfoApi.h"

#import "TENIMService.h"
#import "MBProgressHUD.h"

#import "TEService.h"
#import "NSString+TE.h"
#define TELoginDataPath @"te_login_data"

@interface TELoginManager ()

@property (nonatomic,copy) NSString *filePath;
@end

@implementation TELoginManager{
    NSPointerArray* _delegates; // the array of observing delegates
}

+(instancetype) sharedManager{
    static TELoginManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *dataPath = [[TEFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:TELoginDataPath];
        manager = [[TELoginManager alloc] initWithPath:dataPath];
    });
    return manager;
}



- (void)loginWithUserName:(NSString *)username password:(NSString *)password userType:(TEUserType)type{
    
    NSLog(@"username:%@,password:%@,type:%ld",username,password,type);
    
    if (username.length && password.length &&type) {
        TELoginApi *api = [[TELoginApi alloc] initWithUsername:username password:password userType:type];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"%@",request.responseJSONObject);
            
            if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = request.responseJSONObject;
                NSInteger code = [dic[@"code"]integerValue];
                if (code == 0) {
                    NSLog(@"请求失败");
                }else if (code ==1){
                    NSLog(@"请求成功");
                    
                }
                NSDictionary *content = dic[@"content"];
                NSInteger apiCode = [content[@"status"] integerValue];
                switch (apiCode) {
                    case 0:
                        NSLog(@"登录失败");
                        if (_delegates.count >0) {
                            for (id<TELoginManagerDelegate> delegate in _delegates) {
                                [delegate respondsToSelector:@selector(loginFailed)];
                            }
                        }
                        return;
                    case 1:
                        NSLog(@"登录成功");
                        break;
                    case 2:
                        NSLog(@"用户未注册");
                        return;
                    case 3:
                        NSLog(@"账号密码错误");
                        return;
                    case 4:
                        NSLog(@"其他");
                        return;
                    default:
                        break;
                }
                NSDictionary *userInfo = content[@"userInfo"];
                TELoginData *data = [[TELoginData alloc] init];
                data.token = content[@"token"];
                data.account = username;
                data.type = type;
                data.name = userInfo[@"name"];
                data.phone = userInfo[@"phone"];
                data.avatar = userInfo[@"image_url"];
                data.qq = userInfo[@"qq"];
                data.skype = userInfo[@"skype"];
                data.vipStart = userInfo[@"vipstartdateline"];
                data.vipEnd = userInfo[@"vipenddateline"];
                data.classCount = [userInfo[@"classcount"]integerValue];
                
                
                data.nimAccount = [NSString stringWithFormat:@"te%@",data.phone];
                data.nimToken = password;
                
                [self setCurrentTEUser:data];
                
                NSLog(@"Logindelegates count %ld",_delegates.count);
                
//                for (id<TELoginManagerDelegate> delegate in _delegates) {
//                    if ([delegate respondsToSelector:@selector(loginSuccessed)]) {
//                        [delegate loginSuccessed];
//                    }
//                }
                for (NSInteger i = 0; i<_delegates.count; i++) {
                    id<TELoginManagerDelegate>delegate = [_delegates pointerAtIndex:i];
                    if ([delegate respondsToSelector:@selector(loginSuccessed)]) {
                        [delegate loginSuccessed];
                    }
                }
                
                [self nimLogin];
                [[TEServiceManager sharedManger] start];
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"%@",request.error.description);
        }];
    }
}
- (void)nimLogin{
    
    NSLog(@"%@\n%@",_currentTEUser.nimAccount,_currentTEUser.nimToken);
    
    [[[NIMSDK sharedSDK] loginManager] login:_currentTEUser.nimAccount token:_currentTEUser.nimToken completion:^(NSError * _Nullable error) {
        NSLog(@"%ld,%@",error.code,error.description);
        if (error == nil) {
            NSLog(@"NIM登录成功");
        }else{
            NSLog(@"NIM登录失败");
        }
    }];
}
- (void)logout{
    [self setCurrentTEUser:nil];
    for (id<TELoginManagerDelegate> delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(logout)]) {
            [delegate logout];
        }
    }
    [[NIMSDK sharedSDK].loginManager logout:^(NSError * _Nullable error) {
        
    }];

}

- (void)registerWithUserName:(NSString *)username phone:(NSString *)phone password:(NSString *)password{
    
    NSLog(@"username:%@,password:%@,phone:%@",username,password,phone);
    
    if (username.length && password.length && phone.length) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.label.text = @"注册TE账户";
        
        TERegisterApi *api = [[TERegisterApi alloc] initWithUsername:username phone:phone password:password];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"%@",request.responseJSONObject);
            [hud hideAnimated:YES];
            if (![request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
                return;
            }
            NSDictionary *dic = (NSDictionary *)request.responseJSONObject;
            NSInteger code = [dic[@"code"] integerValue];
            if (code !=1) {
                return;
            }
            NSDictionary *content =dic[@"content"];
            NSInteger status = [content[@"status"] integerValue];

            if (status == 1) {
                [self registerNIMWithAccount:[NSString stringWithFormat:@"te%@",phone] nickname:username token:password];
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            MBProgressHUD *hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
            if (hud) {
                [hud hideAnimated:YES];
            }
            NSLog(@"%@",request.error.description);
        }];
    }
}

- (void)registerNIMWithAccount:(NSString *)acconut nickname:(NSString *)nickname token:(NSString *)token{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.label.text = @"注册NIM账户";
    
    TENIMRegisterData *data = [[TENIMRegisterData alloc] init];
    data.account = acconut;
    data.nickname = nickname;
    data.token = token;
    
    [[TENIMService sharedService] registerUser:data comletion:^(NSError *error, NSString *errorMsg) {
        if (error == nil) {
            NSLog(@"注册NIM成功");
            hud.label.text = @"注册NIM成功";
            
        }else{
            NSLog(@"注册NIM失败");
            hud.label.text = @"注册NIM失败";

        }
        [hud hideAnimated:YES afterDelay:2.0];
    }];
}

- (void)refreshUserInfo{
    TEUserInfoApi *api = [[TEUserInfoApi alloc] initWithToken:self.currentTEUser.token type:self.currentTEUser.type];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.responseJSONObject);
        
        
        NSDictionary *userInfo = request.responseJSONObject[@"content"][@"userInfo"];
        TELoginData *data = [[TELoginData alloc] init];
        data.token = _currentTEUser.token;
        data.account = _currentTEUser.account;
        data.nimAccount = _currentTEUser.nimAccount;
        data.nimToken = _currentTEUser.nimToken;
        data.type = _currentTEUser.type;
        data.name = userInfo[@"name"];
        data.phone = userInfo[@"phone"];
        data.avatar = userInfo[@"image_url"];
        data.qq = userInfo[@"qq"];
        data.skype = userInfo[@"skype"];
        data.vipStart = userInfo[@"vipstartdateline"];
        data.vipEnd = userInfo[@"vipenddateline"];
        data.classCount = [userInfo[@"classcount"]integerValue];
        [self setCurrentTEUser:data];

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}


- (instancetype)initWithPath:(NSString *)filePath{
    if (self = [super init]) {
        _delegates = [NSPointerArray weakObjectsPointerArray];
        _filePath = filePath;
        [self readData];
    }
    return self;
}
- (void)setCurrentTEUser:(TELoginData *)currentTEUser{
    _currentTEUser = currentTEUser;
    [self saveData];
    for (id<TELoginManagerDelegate>delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(userInfoRefreshed)]) {
            [delegate userInfoRefreshed];
        }
    }
}
#pragma input/output
- (void)readData{
    NSString *filePath = [self filePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        id object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        _currentTEUser = [object isKindOfClass:[TELoginData class]]?object:nil;
    }
}
- (void)saveData{
    NSData *data = [NSData data];
    if (_currentTEUser) {
        data = [NSKeyedArchiver archivedDataWithRootObject:_currentTEUser];
    }
    [data writeToFile:[self filePath] atomically:YES];
}
#pragma mark - add/remove delegate
-(void)dealloc
{
}

-(void)addDelegate:(id<TELoginManagerDelegate>) delegate
{
    __weak typeof(id<TELoginManagerDelegate>) weakDelegate = delegate;
    
    [_delegates addPointer:(__bridge void *)(weakDelegate)];
}

-(void)removeDelegate:(id<TELoginManagerDelegate>) delegate
{
    int rIndex = -1;
    
    for (int index = 0; index < [_delegates count]; index++) {
        
        id<TELoginManagerDelegate> pDelegate = [_delegates pointerAtIndex:index];
        
        if (pDelegate == nil) {
            
            rIndex = index;
            break;
            
        }
    }
    
    if (rIndex > -1) {
        [_delegates removePointerAtIndex:rIndex];
    }
    
}
@end
