//
//  TEBook.h
//  TeleEducation
//
//  Created by Karl on 2017/3/3.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEBook : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *image;
@end
