//
//  MyMd5.m
//  HealthPilot
//
//  Created by quanwangwulian on 14-6-27.
//  Copyright (c) 2014年 quanwangwulian. All rights reserved.
//

#import "MyMd5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MyMd5

+(NSString *)md5_lowerStr:(NSString *)str {
    
    const char *cStr = [str UTF8String];//转换成utf-8
    
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    
    CC_MD5(cStr, strlen(cStr), result);
    
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    
    extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md);
    
    NSString *daxieStr = [NSString stringWithFormat:
                          
                          @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                          
                          result[0], result[1], result[2], result[3],
                          
                          result[4], result[5], result[6], result[7],
                          
                          result[8], result[9], result[10], result[11],
                          
                          result[12], result[13], result[14], result[15]
                          
                          ];
   
    // Convert string to lowercase
    NSString *lowerStr = [daxieStr lowercaseStringWithLocale:[NSLocale currentLocale]];
   
    return lowerStr;
    
    /*
     
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     
     NSLog("%02X", 0x888);  //888
     
     NSLog("%02X", 0x4); //04
     
     */
}

+(NSString *)md5_uppercaseStr:(NSString *)str {
    
    const char *cStr = [str UTF8String];//转换成utf-8
    
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    
    CC_MD5(cStr, strlen(cStr), result);
    
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    
    extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md);
    
    NSString *daxieStr = [NSString stringWithFormat:
                          
                          @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                          
                          result[0], result[1], result[2], result[3],
                          
                          result[4], result[5], result[6], result[7],
                          
                          result[8], result[9], result[10], result[11],
                          
                          result[12], result[13], result[14], result[15]
                          
                          ];
    
    // Convert string to lowercase
    NSString *uppercaseStr = [daxieStr uppercaseStringWithLocale:[NSLocale currentLocale]];
    
    return uppercaseStr;
    
    /*
     
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     
     NSLog("%02X", 0x888);  //888
     
     NSLog("%02X", 0x4); //04
     
     */
}

//32位MD5加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    //CC_MD5( cStr, self.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

@end
