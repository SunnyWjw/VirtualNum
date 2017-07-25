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
#define permissions @"PERMISSIONS"          //权限
#define VN_USERID      @"_ID"
#define VN_USERNAME  @"USERNAME"            //用户名
#define VN_PASSWORD  @"PASSWORD"            //密码
#define VN_COMPANYID @"COMPANYID"           //企业ID
#define VN_COMPANYNAME @"COMPANYNAME"       //企业名称
#define VN_PHONE   @"PHONENUM"      //手机号码
#define VN_AUTOLOGIN   @"AUTOLOGIN"     //自动登录
#define VN_X  @"XENUMBER"   //X号码
#define VN_SERVICE    @"SERVICE"        //呼叫模式
#define VN_CallPhoneNum @"CallPhoneNum"         //呼叫号码
#define VN_ContactName @"ContactName"           //呼叫联系人
#define VN_TRANS    @"trans"    //随机数
#define VN_CALLPREFIX   @"0"    //呼叫前缀，例：呼叫x为80246994时，实际呼叫02180246994
#define VN_APIVERSION   @"1"    //Api版本号
