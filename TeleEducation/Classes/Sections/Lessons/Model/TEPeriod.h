//
//  TEPeriod.h
//  TeleEducation
//
//  Created by Karl on 2017/3/3.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,TEPeriodStatus) {
    TEPeriodStatusAvaliable,
    TEPeriodStatusInAvaliable,
    TEPeriodStatusLeave,
    TEPeriodStatusOrdered
};


@interface TEPeriod : NSObject<NSCopying>
- (instancetype)initWithDictionary:(NSDictionary *)dic currentTime:(NSTimeInterval)time;
@property (nonatomic,assign)NSInteger periodID;
@property (nonatomic,assign)NSInteger userID;
@property (nonatomic,assign)float periodTime;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *period;
@property (nonatomic,assign) TEPeriodStatus status;
@end
