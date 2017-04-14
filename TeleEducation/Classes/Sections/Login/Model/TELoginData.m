//
//  TELoginData.m
//  TeleEducation
//
//  Created by Karl on 2017/2/21.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TELoginData.h"

#define TEAccount      @"account"
#define TEToken        @"token"
#define NIMAccount      @"nimaccount"
#define NIMToken        @"nimtoken"

#define TEType @"type"
#define TEName @"name"
#define TEPhone @"phone"
#define TEQQ @"qq"
#define TESkype @"skype"
#define TEAvatar @"avatar"
#define TEVipStart @"vipStart"
#define TEVipEnd @"vipEnd"
#define TEClassCount @"classCount"

@implementation TELoginData

- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _account = [aDecoder decodeObjectForKey:TEAccount];
        _token = [aDecoder decodeObjectForKey:TEToken];
        
        _nimAccount = [aDecoder decodeObjectForKey:NIMAccount];
        _nimToken = [aDecoder decodeObjectForKey:NIMToken];
        
        _type = [aDecoder decodeIntegerForKey:TEType];
        _name = [aDecoder decodeObjectForKey:TEName];
        _phone = [aDecoder decodeObjectForKey:TEPhone];
        _qq = [aDecoder decodeObjectForKey:TEQQ];
        _skype = [aDecoder decodeObjectForKey:TESkype];
        _avatar = [aDecoder decodeObjectForKey:TEAvatar];
        _vipStart = [aDecoder decodeObjectForKey:TEVipStart];
        _vipEnd = [aDecoder decodeObjectForKey:TEVipEnd];
        _classCount = [aDecoder decodeIntegerForKey:TEClassCount];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:[_account length]?_account:@"" forKey:TEAccount];
    [aCoder encodeObject:[_token length]?_token:@"" forKey:TEToken];
    
    [aCoder encodeObject:[_nimAccount length]?_nimAccount:@"" forKey:NIMAccount];
    [aCoder encodeObject:[_nimToken length]?_nimToken:@"" forKey:NIMToken];
    
    [aCoder encodeInteger:_type forKey:TEType];
    [aCoder encodeObject:[_name length]?_name:@"" forKey:TEName];
    [aCoder encodeObject:[_phone length]?_phone:@"" forKey:TEPhone];
    [aCoder encodeObject:[_qq length]?_qq:@"" forKey:TEQQ];
    [aCoder encodeObject:[_skype length]?_skype:@"" forKey:TESkype];
    [aCoder encodeObject:[_avatar length]?_avatar:@"" forKey:TEAvatar];
    [aCoder encodeObject:_vipStart forKey:TEVipStart];
    [aCoder encodeObject:_vipEnd forKey:TEVipEnd];
    [aCoder encodeInteger:_classCount forKey:TEClassCount];

}
-(id)copyWithZone:(NSZone *)zone{
    TELoginData *data = [[[self class] allocWithZone:zone] init];
    data.account = self.account;
    data.token = self.token;
    data.nimAccount = self.nimAccount;
    data.nimToken = self.nimToken;
    data.type = self.type;
    data.name = self.name;
    data.phone = self.phone;
    data.qq = self.qq;
    data.skype = self.skype;
    data.avatar = self.avatar;
    data.vipStart = self.vipStart;
    data.vipEnd =self.vipEnd;
    data.classCount = self.classCount;
    return data;
}
@end
