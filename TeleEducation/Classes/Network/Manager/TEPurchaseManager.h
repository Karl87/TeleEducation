//
//  TEPurchaseManager.h
//  TeleEducation
//
//  Created by Karl on 2017/3/6.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol TEPurchaseManagerDelegate<NSObject>
@optional
- (void)creatOrderWithGoods:(NSInteger)goods;
@end

@interface TEPurchaseManager : NSObject

@property (nonatomic,assign) NSInteger purchaseGoods;

+ (instancetype)sharedManager;
- (void)showPurchaseView;
- (void)hidePurchaseView;
- (void)creatOrderWithGoods:(NSInteger)goods;

-(void)addDelegate:(id<TEPurchaseManagerDelegate>) delegate;
-(void)removeDelegate:(id<TEPurchaseManagerDelegate>) delegate;

@end
