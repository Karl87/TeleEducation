//
//  TEUnit.m
//  TeleEducation
//
//  Created by Karl on 2017/3/3.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "TEUnit.h"
#import "TECourse.h"

@implementation TEUnit
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        
        NSArray*characters = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
        
        _title = dic[@"title"];
        _unitID = [dic[@"id"] integerValue];
        _courses = [NSMutableArray array];
        [dic[@"lessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TECourse *course = [[TECourse alloc] initWithDictionary:obj];
            course.character = characters[idx];
            [_courses addObject:course];
        }];
    }
    return self;
}
@end
