//
//  TEAppConfig.h
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEAppConfig : NSObject

+ (instancetype) sharedConfig;

@property (nonatomic,copy) NSString *NIMAppKey;
@property (nonatomic,copy) NSString *NIMCerName;

@end
