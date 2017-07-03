//
//  AppDelegate+AppService.h
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/23.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "AppDelegate.h"

#import <CoreTelephony/CTCallCenter.h>

#import <CoreTelephony/CTCall.h>

#define ReplaceRootViewController(vc) [[AppDelegate shareAppDelegate] replaceRootViewController:vc]

/**
 包含第三方 和 应用内业务的实现，减轻入口代码压力
 */
@interface AppDelegate (AppService)

@property(nonatomic,strong)CTCallCenter *callCenter;

//初始化服务
-(void)initService;

//初始化 window
-(void)initWindow;

//初始化 UMeng
-(void)initUMeng;

//初始化用户系统
-(void)initUserManager;

//监听网络状态
- (void)monitorNetworkStatus;

//监听通话状态
- (void)callCenterState;

//单例
+ (AppDelegate *)shareAppDelegate;

/**
 当前顶层控制器
 */
-(UIViewController*) getCurrentVC;

-(UIViewController*) getCurrentUIVC;
@end
