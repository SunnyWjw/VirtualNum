//
//  CommonMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/31.
//  Copyright © 2017年 徐阳. All rights reserved.
//

//全局标记字符串，用于 通知 存储

#ifndef CommonMacros_h
#define CommonMacros_h

#pragma mark - ——————— 用户相关 ————————
//登录状态改变通知
#define KNotificationLoginStateChange @"loginStateChange"

//自动登录成功
#define KNotificationAutoLoginSuccess @"KNotificationAutoLoginSuccess"

//被踢下线
#define KNotificationOnKick @"KNotificationOnKick"

//用户信息缓存 名称
#define KUserCacheName @"KUserCacheName"

//用户model缓存
#define KUserModelCache @"KUserModelCache"



#pragma mark - ——————— 网络状态相关 ————————

//网络状态变化
#define KNotificationNetWorkStateChange @"KNotificationNetWorkStateChange"

#endif /* CommonMacros_h */

/**基本信息**/
#define permissions @"PERMISSIONS"
#define VN_USERID      @"_ID"
#define VN_USERNAME  @"USERNAME"
#define VN_PASSWORD  @"PASSWORD"
#define VN_COMPANYID @"COMPANYID"
#define VN_COMPANYNAME @"COMPANYNAME"
#define VN_PHONE   @"PHONENUM"
#define VN_AUTOLOGIN   @"AUTOLOGIN"
#define VN_X  @"XENUMBER"
#define VN_SERVICE    @"SERVICE"
#define VN_CallPhoneNum @"CallPhoneNum"
#define VN_ContactName @"ContactName"
