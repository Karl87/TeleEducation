//
//  TEGoods.h
//  TeleEducation
//
//  Created by Karl on 2017/3/7.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEGoods : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@property (nonatomic,assign) NSInteger goodsID;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) NSInteger num;
@property (nonatomic,assign) float price;
@property (nonatomic,copy) NSString *detail;
@property (nonatomic,copy) NSString *priceStr;

@end
