//
//  TEPinyinConverter.h
//  TeleEducation
//
//  Created by Karl on 2017/2/9.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEPinyinConverter : NSObject

+(TEPinyinConverter *)sharedConverter;
- (NSString *)toPinyin:(NSString *)source;

@end
