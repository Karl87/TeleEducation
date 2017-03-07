//
//  TENetworkConfig.h
//  TeleEducation
//
//  Created by Karl on 2017/3/1.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TENetworkConfig : NSObject
+ (instancetype) sharedConfig;

@property (nonatomic,copy) NSString *baseURL;
@property (nonatomic,copy) NSString *cdnURL;
@end
