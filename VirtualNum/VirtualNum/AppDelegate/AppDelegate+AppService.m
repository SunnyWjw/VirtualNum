//
//  AppDelegate+AppService.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/23.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "LoginViewController.h"
#import "CallLog.h"
#import "DataBase.h"

@implementation AppDelegate (AppService)


#pragma mark ————— 初始化服务 —————
-(void)initService{
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNotificationLoginStateChange
                                               object:nil];    
    
    //网络状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkStateChange:)
                                                 name:KNotificationNetWorkStateChange
                                               object:nil];
}

#pragma mark ————— 初始化window —————
-(void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = KWhiteColor;
    [self.window makeKeyAndVisible];
    [[UIButton appearance] setExclusiveTouch:YES];
//    [[UIButton appearance] setShowsTouchWhenHighlighted:YES];
 //   [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = KWhiteColor;

//    //为避免自动登录成功刷新tabbar
//    if (!self.mainTabBar || ![self.window.rootViewController isKindOfClass:[MainTabBarController class]]) {
//        self.mainTabBar = [MainTabBarController new];
//        self.window.rootViewController = self.mainTabBar;
//    }
    
   
}


#pragma mark ————— 初始化用户系统 —————
-(void)initUserManager{
    
    NSString *callSettingsType = [[NSUserDefaults standardUserDefaults] objectForKey:VN_SERVICE];
    if (callSettingsType.length == 0) {
        callSettingsType = @"0";
        [[NSUserDefaults standardUserDefaults] setObject:callSettingsType forKey:VN_SERVICE];
    }
    
    
    if([self loadUserDefaults]){
        
        //如果有本地数据，先展示TabBar 随后异步自动登录
        self.mainTabBar = [MainTabBarController new];
        self.window.rootViewController = self.mainTabBar;
        
        //自动登录
        [userManager autoLoginToServer:^(BOOL success, NSString *des) {
            if (success) {
                DLog(@"自动登录成功");
                //                    [MBProgressHUD showSuccessMessage:@"自动登录成功"];
                KPostNotification(KNotificationAutoLoginSuccess, nil);
            }else{
                [MBProgressHUD showErrorMessage:NSStringFormat(@"自动登录失败：%@",des)];
            }
        }];
        
    }else{
        //没有登录过，展示登录页面
        KPostNotification(KNotificationLoginStateChange, @NO)
    }
}


-(BOOL)loadUserDefaults{
    NSString * usernameStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    NSString * pwdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"];
    NSString * checkBoxBool = [[NSUserDefaults standardUserDefaults] objectForKey:@"zidongdenglu"];
     DLog(@"checkBoxBool>>>%@",checkBoxBool);
    if ([checkBoxBool isEqual: @"1"]) {
        DLog(@"YES>>>");
    }else{
        DLog(@"NO>>>>");
    }
   
    if(usernameStr && pwdStr && [checkBoxBool isEqual: @"1"]){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    
    if (loginSuccess) {//登陆成功加载主窗口控制器
        
        //为避免自动登录成功刷新tabbar
        if (!self.mainTabBar || ![self.window.rootViewController isKindOfClass:[MainTabBarController class]]) {
            self.mainTabBar = [MainTabBarController new];
            self.window.rootViewController = self.mainTabBar;
        }
        
    }else {//登陆失败加载登陆页面控制器
        
        self.mainTabBar = nil;
        RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:[LoginViewController new]];
        self.window.rootViewController = loginNavi;
        
    }
    //展示FPS
   //[AppManager showFPS];
}


#pragma mark ————— 网络状态变化 —————
- (void)netWorkStateChange:(NSNotification *)notification
{
    //BOOL isNetWork = [notification.object boolValue];
    /*
    if (isNetWork) {//有网络
        if ([userManager loadUserInfo] && !isLogin) {//有用户数据 并且 未登录成功 重新来一次自动登录
            [userManager autoLoginToServer:^(BOOL success, NSString *des) {
                if (success) {
                    DLog(@"网络改变后，自动登录成功");
//                    [MBProgressHUD showSuccessMessage:@"网络改变后，自动登录成功"];
                    KPostNotification(KNotificationAutoLoginSuccess, nil);
                }else{
                    [MBProgressHUD showErrorMessage:NSStringFormat(@"自动登录失败：%@",des)];
                }
            }];
        }
        
    }else {//登陆失败加载登陆页面控制器
        [MBProgressHUD showTopTipMessage:@"网络状态不佳" isWindow:YES];
    }
     */
}


#pragma mark ————— 友盟 初始化 —————
-(void)initUMeng{
    
    /* 打开调试日志 */
    //[[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    //[[UMSocialManager defaultManager] setUmSocialAppkey:UMengKey];
    
    
    
   // [self configUSharePlatforms];
}
#pragma mark ————— 配置第三方 —————
-(void)configUSharePlatforms{
    /* 设置微信的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kAppKey_Wechat appSecret:kSecret_Wechat redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kAppKey_Tencent/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
}

#pragma mark ————— OpenURL 回调 —————
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
    return YES;
}

#pragma mark ————— 网络状态监听 —————
- (void)monitorNetworkStatus
{
    /*
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatusType networkStatus) {
        
        switch (networkStatus) {
                // 未知网络
            case PPNetworkStatusUnknown:
                DLog(@"网络环境：未知网络");
                // 无网络
            case PPNetworkStatusNotReachable:
                DLog(@"网络环境：无网络");
                KPostNotification(KNotificationNetWorkStateChange, @NO);
                break;
                // 手机网络
            case PPNetworkStatusReachableViaWWAN:
                DLog(@"网络环境：手机自带网络");
                // 无线网络
            case PPNetworkStatusReachableViaWiFi:
                DLog(@"网络环境：WiFi");
                KPostNotification(KNotificationNetWorkStateChange, @YES);
                break;
        }
        
    }];
    */
}

#pragma mark ————— 通话状态监听 —————
- (void)callCenterState{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.callCenter = [[CTCallCenter alloc] init];
    
    self.callCenter.callEventHandler = ^(CTCall* call) {
        
        if ([call.callState isEqualToString:CTCallStateDisconnected])
            
        {
            
             DLog(@"挂断了电话咯Call has been disconnected");
        }
        
        else if ([call.callState isEqualToString:CTCallStateConnected])
            
        {
            
            DLog(@"电话通了Call has just been connected");
            
        }
        
        else if([call.callState isEqualToString:CTCallStateIncoming])
            
        {
            
             DLog(@"来电话了Call is incoming");
            
        }
        
        else if ([call.callState isEqualToString:CTCallStateDialing])
            
        {
            
            DLog(@"正在播出电话call is dialing");
            CallLog *callLog = [[CallLog alloc] init];
            NSString *callPhoneNum = [userDefaults objectForKey:VN_CallPhoneNum];
            NSString *calledName = [userDefaults objectForKey:VN_ContactName];
            NSString *callingName = [userDefaults objectForKey:VN_USERNAME];
            callingName = callingName.length > 0 ? callingName : @"";
            
            NSString *XNum = [userDefaults objectForKey:VN_X];
            XNum = XNum.length > 0 ? XNum : 0;
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber *numTemp = [numberFormatter numberFromString:XNum];
            
            NSNumber *randomNum = [numberFormatter numberFromString:[userDefaults objectForKey:VN_TRANS]];
            
            NSString *serviceType = [userDefaults objectForKey:VN_SERVICE];
            serviceType = serviceType.length > 0 ? serviceType : @"";
            NSString *create = [userDefaults objectForKey:VN_COMPANYID];
            create = create.length > 0 ? create : @"";
            
            callLog.CallPhoneNum = callPhoneNum;
            callLog.calledName = calledName;
            callLog.CallingName = callingName;
            callLog.XNum = numTemp;
            callLog.randomNum = randomNum;
            callLog.durationTime = 0;
            callLog.serviceType = serviceType;
            callLog.generatorPersonnel = create;
            
           [[DataBase sharedDataBase] addCallLog:callLog];
            
            
        }
        
        else  
            
        {  
            
           DLog(@"嘛都没做Nothing is done");
            
        }  
        
    };
}


+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


-(UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}


@end
