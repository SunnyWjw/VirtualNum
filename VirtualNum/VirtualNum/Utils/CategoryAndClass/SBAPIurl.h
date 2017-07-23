//
//  SBAPIurl.h
//  Ltalk
//
//  Created by Mark.PL on 14/11/28.
//  Copyright (c) 2014年 Ltalk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBAPIurl : NSObject

+ (BOOL)isMobileNumber:(NSString *)mobileNum;


/**
 对字典进行加密并返回一个加密后的字典

 @param str 需要加密的字典

 @return 返回加密后的字典
 */
+ (NSDictionary *)TextCodeBase64:(NSDictionary *)str;
//+ (NSString *)TextDecodeBase64:(NSDictionary *)str;

/**
 文字解密

 @param codeStr 需要解密的字符串

 @return 返回解密后的字符串
 */
+(NSString *)TextDecodeBase64:(NSString *) codeStr;

/**
 对字典进行加密并返回一个字符串

 @param str 需要加密的字典

 @return 返回加密后的字符串
 */
+(NSString *)TextCodeBase64ToString:(NSString *)str;
+(NSString *)TextDecodeBase64ToString:(NSString *) codeStr;

+ (void) showDialog:(NSString *)content;
+ (BOOL) validatePassword:(NSString *)passWord;
+ (BOOL) validateEmail:(NSString *)email;

+ (NSString *)deviceID;

@end
