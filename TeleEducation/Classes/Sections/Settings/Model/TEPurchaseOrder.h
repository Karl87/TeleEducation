//
//  TEPurchaseOrder.h
//  TeleEducation
//
//  Created by Karl on 2017/3/7.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEPurchaseOrder : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@property (nonatomic,assign) NSInteger orderID;
@property (nonatomic,assign) NSInteger title;
@property (nonatomic,assign) float timeStamp;
@property (nonatomic,copy) NSString *status;
@end
