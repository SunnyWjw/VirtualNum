//
//  NSString+checkPhone.h
//  HealthPilot
//
//  Created by quanwangwulian on 14/12/14.
//  Copyright (c) 2014年 quanwangwulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (checkPhone)

/**
 *  验证手机号码
 *
 *  @param checkPhone 输入的手机号码
 *
 *  @return 返回 YES or  NO
 */
-(BOOL) checkPhoneNumInput:(NSString *) checkPhone;

/**
 *  验证邮箱地址
 *
 *  @param checkPhone 输入的邮箱地址
 *
 *  @return 返回 YES or  NO
 */
- (BOOL) validateEmail:(NSString *)email;

@end
