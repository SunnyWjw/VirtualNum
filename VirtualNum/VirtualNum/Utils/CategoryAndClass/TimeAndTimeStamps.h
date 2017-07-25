//
//  TimeAndTimeStamps.h
//  Ltalk
//
//  Created by livecom on 15/12/18.
//  Copyright © 2015年 livecom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeAndTimeStamps : NSObject


/**
 *  @author livecom, 15-12-18 10:12:20
 *
 *  @brief   当前时前转为(十位)时间戳（精确到秒）
 *
 *  @return 返回时间戳
 */
+ (NSString *)GetTimeStampWithAccurateTosecond;

/**
 *  @author livecom, 15-12-18 11:12:24
 *
 *  @brief  当前时前转为(十三位)时间戳（精确到毫秒）
 *
 *  @return 返回时间戳
 */
+ (NSString *)GetTimeStampWithAccurateTomilliseconds;


/**
 *  @author livecom, 15-12-18 11:12:02
 *
 *  @brief  (十位)时间戳转时间的方法
 *
 *  @param timestamp 时间戳
 *  @param timezone  时区
 *
 *  @return 返回时间
 */
+ (NSString *)GetTimeWithTimestamp:(NSString *)timestamp Timezone:(NSString *)timezone;

/**
 *  @author livecom, 15-12-18 11:12:32
 *
 *  @brief  (十三位)时间戳转时间的方法
 *
 *  @param timestamp 时间戳
 *  @param timezone  时区
 *
 *  @return 返回时间
 */
+ (NSString *)GetTimeWithTimestampWithAccurateTomilliseconds:(NSString *)timestamp Timezone:(NSString *)timezone;

/**
 *  @author livecom, 16-12-30 09:12:25
 *
 *  @brief  获取系统当前时间
 *
 *  @param date 系统时间
 *
 *  @return String类型的时间格式
 */
+ (NSString *)dateToString:(NSDate *)date;


/**
 获取当前时间格式串 例:20170702221249

 @return 返回时间串
 */
+ (NSString *)getNowDateTimeFoFourteenr;


/**
 获取当前时间格式串 例:20170727100851324

 @return 返回时间字符串
 */
+ (NSString *)getNowDateTimeFoMillisecond;

@end
