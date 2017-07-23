//
//  MyMd5.h
//  HealthPilot
//
//  Created by quanwangwulian on 14-6-27.
//  Copyright (c) 2014年 quanwangwulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMd5 : NSObject

///md5 32位小写加密
+(NSString *)md5_lowerStr:(NSString *)str;
///md5 32位大写加密
+(NSString *)md5_uppercaseStr:(NSString *)str;

/**
 *  @author livecom, 15-12-24 09:12:28
 *
 *  @brief  32位MD5加密方式
 *
 *  @param srcString 需要加密的字符串
 *
 *  @return 返回32位加密后的字符串
 */
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;

@end
