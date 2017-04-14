//
//  TEUser.h
//  TeleEducation
//
//  Created by Karl on 2017/2/23.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEUser : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@property (nonatomic,assign) NSInteger userID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *avatar;
@end
