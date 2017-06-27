//
//  MyDate.m
//  HealthPilot
//
//  Created by quanwangwulian on 14-7-23.
//  Copyright (c) 2014年 quanwangwulian. All rights reserved.
//

#import "MyDate.h"

@implementation MyDate

+ (NSString *)getWeekdayFromDate:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:dateStr];
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents* components = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit |NSWeekdayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
    
    components = [calendar components:unitFlags fromDate:date];
    
    NSUInteger weekday = [components weekday];
    
//    NSLog(@"%lu",(unsigned long)weekday);
    
    NSString *weekStr = @"";
    
    switch (weekday)
    {
        case 2:
        {//周一
            weekStr = @"星期一";
        }
            break;
        case 3:
        {//周二
            weekStr = @"星期二";
        }
            break;
        case 4:
        {//周三
            weekStr = @"星期三";
        }
            break;
        case 5:
        {//周四
            weekStr = @"星期四";
        }
            break;
        case 6:
        {//周五
            weekStr = @"星期五";
        }
            break;
        case 7:
        {//周六
            weekStr = @"星期六";
        }
            break;
        case 1:
        {//周六
            weekStr = @"星期日";
        }
            break;
            
        default:
            break;
    }
    
    
//    NSLog(@" dateStr %@ weekday %d",dateStr,weekday);
    
    return weekStr;
}


@end
