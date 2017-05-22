//
//  NSString+TEDate.m
//  TeleEducation
//
//  Created by Karl on 2017/5/10.
//  Copyright © 2017年 i-Craftsmen ltd. All rights reserved.
//

#import "NSString+TEDate.h"

@implementation NSString (TEDate)

+ (NSString *)stringWithDateString:(NSString *)dString{
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
//    NSDate *date = [dateFormatter dateFromString:dString];

    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSDate *tomorrow, *yesterday ,*dayAfterTomorrow;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    dayAfterTomorrow = [today dateByAddingTimeInterval:2*secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    NSString * dayAfterTomorrowString = [[dayAfterTomorrow description] substringToIndex:10];
//    NSString * dateString = [[date description] substringToIndex:10];
//    NSLog(@"d%@,tod%@,yes%@,tom%@",dString,todayString,yesterdayString,tomorrowString);
    
    if ([dString isEqualToString:todayString]){
        return @"今天";
    } else if ([dString isEqualToString:yesterdayString]){
        return @"昨天";
    }else if ([dString isEqualToString:tomorrowString]){
        return @"明天";
    }else if ([dString isEqualToString:dayAfterTomorrowString]){
        return @"后天";
    }else{
        return @"";
    }

}

//-(NSString *)compareDate:(NSDate *)date{
//    
//    NSTimeInterval secondsPerDay = 24 * 60 * 60;
//    NSDate *today = [[NSDate alloc] init];
//    NSDate *tomorrow, *yesterday;
//    
//    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
//    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
//    
//    // 10 first characters of description is the calendar date:
//    NSString * todayString = [[today description] substringToIndex:10];
//    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
//    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
//    
//    NSString * dateString = [[date description] substringToIndex:10];
//    
//    if ([dateString isEqualToString:todayString])
//    {
//        return @"今天";
//    } else if ([dateString isEqualToString:yesterdayString])
//    {
//        return @"昨天";
//    }else if ([dateString isEqualToString:tomorrowString])
//    {
//        return @"明天";
//    }
//    else
//    {
//        return dateString;
//    }
//}
////----------------------------------------------
//
///**
// /////  和当前时间比较
// ////   1）1分钟以内 显示        :    刚刚
// ////   2）1小时以内 显示        :    X分钟前
// ///    3）今天或者昨天 显示      :    今天 09:30   昨天 09:30
// ///    4) 今年显示              :   09月12日
// ///    5) 大于本年      显示    :    2013/09/09
// **/
//
//+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate
//{
//    
//    @try {
//        //实例化一个NSDateFormatter对象
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:formate];
//        
//        NSDate * nowDate = [NSDate date];
//        
//        /////  将需要转换的时间转换成 NSDate 对象
//        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
//        /////  取当前时间和转换时间两个日期对象的时间间隔
//        /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
//        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
//        
//        //// 再然后，把间隔的秒数折算成天数和小时数：
//        
//        NSString *dateStr = @"";
//        
//        if (time<=60) {  //// 1分钟以内的
//            dateStr = @"刚刚";
//        }else if(time<=60*60){  ////  一个小时以内的
//            
//            int mins = time/60;
//            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
//            
//        }else if(time<=60*60*24){   //// 在两天内的
//            
//            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
//            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
//            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
//            
//            [dateFormatter setDateFormat:@"HH:mm"];
//            if ([need_yMd isEqualToString:now_yMd]) {
//                //// 在同一天
//                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
//            }else{
//                ////  昨天
//                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
//            }
//        }else {
//            
//            [dateFormatter setDateFormat:@"yyyy"];
//            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
//            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
//            
//            if ([yearStr isEqualToString:nowYear]) {
//                ////  在同一年
//                [dateFormatter setDateFormat:@"MM月dd日"];
//                dateStr = [dateFormatter stringFromDate:needFormatDate];
//            }else{
//                [dateFormatter setDateFormat:@"yyyy/MM/dd"];
//                dateStr = [dateFormatter stringFromDate:needFormatDate];
//            }
//        }
//        
//        return dateStr;
//    }
//    @catch (NSException *exception) {
//        return @"";
//    }
//    
//    
//}

@end
