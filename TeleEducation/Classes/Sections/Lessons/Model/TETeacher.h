//
//  TETeacher.h
//  TeleEducation
//
//  Created by Karl on 2017/3/3.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TETeacher : NSObject<NSCopying>
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@property (nonatomic,assign) NSInteger teacherID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,assign) NSInteger times;
@end
