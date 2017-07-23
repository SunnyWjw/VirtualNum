//
//  SBAPIurl.m
//  Ltalk
//
//  Created by Mark.PL on 14/11/28.
//  Copyright (c) 2014年 Ltalk. All rights reserved.
//

#import "SBAPIurl.h"
#import "GTMBase64.h"





@interface NSDictionary (BVJSONString)
-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint;
@end

@implementation SBAPIurl

+(NSString*) deviceID {
    
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    return uuid;
}



+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSLog(@"mobileNum00 ==%@",mobileNum);
    mobileNum = [self stringWithoutSpaceWithString:mobileNum];
    NSLog(@"mobileNum ==%@",mobileNum);
    
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     * 中国电信：China Telecom
//     * 133,1349,153,180,189,181(增加)
//     */
//    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
     NSString * MOBILE = @"^1(3[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
    if ([regextestmobile evaluateWithObject:mobileNum] == YES) {
        return YES;
    }else
    {
        return NO;
    }
}

+ (NSString *)stringWithoutSpaceWithString:(NSString *)str
{
    NSString *strUrl = [str stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"+" withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"-" withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return strUrl;
}

+ (void) showDialog:(NSString *)content
{
    UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:content
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"知道了"
                                               otherButtonTitles: nil];
    [alertError show];
    
}

//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}




#pragma mark -文字编码(对字典加密返回字典)
+(NSDictionary *)TextCodeBase64:(NSDictionary *) str
{
    NSString *paramJSON = [str bv_jsonStringWithPrettyPrint:false ];
    NSString *paramStr = [NSString stringWithFormat:@"%@", paramJSON];    
    NSData *Data=[paramStr dataUsingEncoding:NSUTF8StringEncoding];
    //进行编码
    Data =[GTMBase64 encodeData:Data];
    NSString *encodeparam =  [[NSString alloc] initWithData:Data encoding:NSUTF8StringEncoding];
    
    NSDictionary *newparam =  @{
                                @"data_enc": [NSString stringWithFormat:@"WLFflaj%@", encodeparam]} ;
    return newparam;
    
}

#pragma mark -文字编码(对字典加密返回字符串)
+(NSString *)TextCodeBase64ToString:(NSString *)str
{
//    NSString *paramJSON = [str bv_jsonStringWithPrettyPrint:false ];
    NSString *paramStr = [NSString stringWithFormat:@"%@", str];
    NSData *Data=[paramStr dataUsingEncoding:NSUTF8StringEncoding];
    //进行编码
    Data =[GTMBase64 encodeData:Data];
    NSString *encodeparam =  [[NSString alloc] initWithData:Data encoding:NSUTF8StringEncoding];
    
    NSString *newStr =[NSString stringWithFormat:@"abcdefg%@", encodeparam];
    
    return newStr;
}

#pragma mark -文字解码（对字典解密）
+(NSString *)TextDecodeBase64:(NSString *) codeStr
{
    NSString *str1 = [codeStr substringWithRange:NSMakeRange(0, 3)];
    NSString *str2 = [codeStr substringFromIndex:5];
    NSString *str3 = [NSString stringWithFormat:@"%@%@", str1, str2];
    NSData *data=[str3 dataUsingEncoding:NSUTF8StringEncoding];
    data=  [GTMBase64 decodeData:data];
//  NSString *re = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"re=========== %@",re);
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


#pragma mark -文字解码（对字符串解密）
+(NSString *)TextDecodeBase64ToString:(NSString *) codeStr
{
    NSString *str2 = [codeStr substringFromIndex:5];
    NSString *str3 = [NSString stringWithFormat:@"%@", str2];
    NSData *data=[str3 dataUsingEncoding:NSUTF8StringEncoding];
    data=  [GTMBase64 decodeData:data];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end

@implementation NSDictionary (BVJSONString)

-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end



