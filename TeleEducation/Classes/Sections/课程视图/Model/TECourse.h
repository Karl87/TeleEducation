//
//  TECourse.h
//  TeleEducation
//
//  Created by Karl on 2017/3/3.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,TECourseStatus) {
    TECourseStatusNormal
};

@interface TECourse : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@property (nonatomic,assign) NSInteger courseID;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,assign) TECourseStatus status;
@property (nonatomic,copy) NSString *character;
@end
