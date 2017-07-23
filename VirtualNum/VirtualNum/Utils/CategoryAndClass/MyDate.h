//
//  MyDate.h
//  HealthPilot
//
//  Created by quanwangwulian on 14-7-23.
//  Copyright (c) 2014年 quanwangwulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDate : NSObject

//日期 转换成 星期
+ (NSString *)getWeekdayFromDate:(NSString *)dateStr;

@end
