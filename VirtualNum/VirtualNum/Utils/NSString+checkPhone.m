//
//  NSString+checkPhone.m
//  HealthPilot
//
//  Created by quanwangwulian on 14/12/14.
//  Copyright (c) 2014年 quanwangwulian. All rights reserved.
//

#import "NSString+checkPhone.h"

@implementation NSString (checkPhone)

-(BOOL)checkPhoneNumInput:(NSString *) checkPhone{
    
//    //验证手机号
//    
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|7[7]|8[0125-9])\\d{8}$";
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188  新增：181，176
//     * 联通：130,131,132,152,155,156,185,186 新增：181，176
//     * 电信：133,1349,153,180,189，新增：181，177
//     */
//    
//    
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    
//    
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /*
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    
//    NSString * CT = @"^1((33|53|77|8[019])[0-9]|349)\\d{7}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     * 电信：133,1349,153,180,189，新增：181，177
//     22         */
//    
//    
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    
//    
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    
//    BOOL res1 = [regextestmobile evaluateWithObject:self];
//    
//    BOOL res2 = [regextestcm evaluateWithObject:self];
//    
//    BOOL res3 = [regextestcu evaluateWithObject:self];
//    
//    BOOL res4 = [regextestct evaluateWithObject:self];
//    
//    
//    
//    if (res1 || res2 || res3 || res4 )
//        
//    {
//        
//        return YES;
//        
//    }
//    
//    else
//        
//    {
//        
//        return NO;
//        
//    }

    
    NSString * MOBILE = @"^1(3[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if ([regextestmobile evaluateWithObject:checkPhone] == YES) {
        return YES;
    }else
    {
        return NO;
    }
    
}

//邮箱
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}


@end
