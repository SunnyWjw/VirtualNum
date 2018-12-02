//
//  NSString+Handle.h
//  ADIntegral
//
//  Created by SunnyWu on 2018/5/30.
//  Copyright © 2018年 Livecom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Handle)

/**
 字符串去空格
 
 @param str 需要去空格的字符串
 @return 返回去空格以后的字符串
 */
+ (NSString *)trimString:(NSString *)str;


/**
 判断输入的内容是否是数字

 @param number 限制的内容
 @return 返回bool值
 */
+ (BOOL)validateNumber:(NSString*)number;

+ (NSString*)iphoneType;


/**
 判断一个字符串是否为空

 @param string 需要较验的字符串
 @return 返回YES or NO
 */
+ (BOOL) strIsNullOrEmpty:(NSString *)string;

+ (NSString*)IphoneSystemVersion;

@end
