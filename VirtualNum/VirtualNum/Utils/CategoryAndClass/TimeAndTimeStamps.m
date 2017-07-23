//
//  TimeAndTimeStamps.m
//  Ltalk
//
//  Created by livecom on 15/12/18.
//  Copyright © 2015年 livecom. All rights reserved.
//

#import "TimeAndTimeStamps.h"

@implementation TimeAndTimeStamps

//当前时前转为时间戳(精确到秒)
+ (NSString *)GetTimeStampWithAccurateTosecond
{
    NSDate * nowdate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *datenow = [dateFormatter stringFromDate:nowdate];
    NSDate* date = [dateFormatter dateFromString:datenow];
    //转为时间戳 精确到秒
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    
    return timeSp;
}

//当前时前转为时间戳(精确到毫秒)
+ (NSString *)GetTimeStampWithAccurateTomilliseconds
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a]; //转为字符型 注：不想有小数点用%.0f​就OK啦
    return timeString;
}

// 时间戳(精确到秒)转时间的方法
+ (NSString *)GetTimeWithTimestamp:(NSString *)timestamp Timezone:(NSString *)timezone {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:timezone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

//  时间戳(精确到毫秒)转时间的方法
+ (NSString *)GetTimeWithTimestampWithAccurateTomilliseconds:(NSString *)timestamp Timezone:(NSString *)timezone{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:timezone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue] / 1000];
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

//  获取系统当前时间
+ (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)getNowDateTimeFoFourteenr{
    NSDate *date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}


@end
