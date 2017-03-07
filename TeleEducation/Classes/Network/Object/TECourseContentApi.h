//
//  TECourseContentApi.h
//  TeleEducation
//
//  Created by Karl on 2017/3/7.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface TECourseContentApi : YTKRequest
- (id)initWithToken:(NSString *)token unit:(NSInteger)unit lesson:(NSInteger)lesson;

@end
