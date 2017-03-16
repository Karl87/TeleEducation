//
//  TELoginData.h
//  TeleEducation
//
//  Created by Karl on 2017/2/21.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,TEUserType){
    TEUserTypeAdmin,
    TEUserTypeTeacher,
    TEUserTypeStudent
};

@interface TELoginData : NSObject <NSCoding>

@property (nonatomic,copy) NSString *account;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *nimAccount;
@property (nonatomic,copy) NSString *nimToken;

@property (nonatomic,assign) TEUserType type;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *qq;
@property (nonatomic,copy) NSString *skype;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString* vipStart;
@property (nonatomic,copy) NSString* vipEnd;
@property (nonatomic,assign) NSInteger classCount;
@end
