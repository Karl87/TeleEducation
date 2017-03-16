//
//  TELoginManager.h
//  TeleEducation
//
//  Created by Karl on 2017/2/21.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TELoginData.h"

@protocol TELoginManagerDelegate <NSObject>

@optional
- (void)loginSuccessed;
- (void)loginFailed;
- (void)logout;
- (void)userInfoRefreshed;
@end



@interface TELoginManager : NSObject

@property (nonatomic,strong) TELoginData *currentTEUser;

+ (instancetype)sharedManager;
- (void)nimLogin;
- (void)loginWithUserName:(NSString *)username password:(NSString *)password userType:(TEUserType)type;

- (void)logout;
- (void)registerWithUserName:(NSString *)username phone:(NSString *)phone password:(NSString *)password;
- (void)registerNIMWithAccount:(NSString *)acconut nickname:(NSString *)nickname token:(NSString *)token;

- (void)refreshUserInfo;

-(void)addDelegate:(id<TELoginManagerDelegate>) delegate;
-(void)removeDelegate:(id<TELoginManagerDelegate>) delegate;

@end
