//
//  CallPhone.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/2.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "CallPhone.h"
#import "ChooseTransidViewController.h"

@implementation CallPhone

static CallPhone *_instance;

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}
+(instancetype)shareTools
{
    //return _instance;
    // 最好用self 用Tools他的子类调用时会出现错误
    return [[self alloc]init];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}


-(void)sendCallRequest:(NSString *)phoneNum ContactName:(NSString *)contactName Respone:( CallResponeBlcok )respone{
    
    //先清除再保存
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:VN_CallPhoneNum];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:VN_ContactName];
    [[NSUserDefaults standardUserDefaults] setObject:phoneNum forKey:VN_CallPhoneNum];
    [[NSUserDefaults standardUserDefaults] setObject:contactName forKey:VN_ContactName];
    
    NSString *comPanyIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_COMPANYID];
    if (!comPanyIDStr) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"获取信息失败，请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        [userManager DelInfo];
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_AXB);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *aNumStr = [userDefaults objectForKey:VN_PHONE];
    if (!aNumStr) {
        [MBProgressHUD showErrorMessage:@"请先绑定手机号码"];
        return;
    }
    NSString *xNumStr = [userDefaults objectForKey:VN_X];
    if (!xNumStr) {
        [MBProgressHUD showErrorMessage:@"请先绑定X号码"];
        return;
    }
    NSString *companyIDStr = [userDefaults objectForKey:VN_COMPANYID];
    if (!companyIDStr) {
        [MBProgressHUD showErrorMessage:@"请输入companyid"];
        return;
    }
    NSString *companyNameStr = [userDefaults objectForKey:VN_COMPANYNAME];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *randomNum = [numberFormatter numberFromString:[TimeAndTimeStamps getNowDateTimeFoMillisecond]];
    
    NSString * strTransid =[NSString stringWithFormat:@"%@%@",companyIDStr,randomNum] ;
    [[NSUserDefaults standardUserDefaults] setObject:strTransid forKey:VN_TRANS];
    
    // xNumStr = [NSString stringWithFormat:@"%@%@",VN_CALLPREFIX,xNumStr];
    NSString *mode = [userDefaults objectForKey:VN_SERVICE];
    mode = [mode isEqual:@"0"] ? @"dual" : @"single";
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:aNumStr forKey:@"a"];
    [dictionary setValue:xNumStr forKey:@"x"];
    [dictionary setValue:phoneNum forKey:@"b"];
    if ([mode isEqualToString:@"dual"]) {
        [dictionary setValue:[NSString stringWithFormat:@"%@",strTransid] forKey:@"trans"];
    }else{
        [dictionary setValue:@"" forKey:@"trans"];
    }
    [dictionary setValue:mode forKey:@"mode"];
    [dictionary setValue:companyIDStr forKey:@"companyid"];
    [dictionary setValue:companyNameStr forKey:@"companyname"];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:VN_TOKEN];
    if (!token) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"获取信息失败，请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
        [userManager DelInfo];
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    NSDictionary *headerDic = @{
                                @"token":token,
                                @"version":VN_APIVERSION
                                };
    
    NSDictionary *parameters = @{
                                 @"newItem": dictionary,
                                 @"oldItem": @{},
                                 @"type": @"create"
                                 } ;
    DLog(@"baseUrl>>>%@",baseUrl);
    DLog(@"绑定AXBparameters>>>%@",parameters);
    [MBProgressHUD showActivityMessageInView:@"请求中..."];
    [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Put).HTTPHeader(headerDic).Parameters(parameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
            [MBProgressHUD showErrorMessage:@"服务器繁忙，请稍后再试"];
            return;
        }
        
        NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
        DLog(@"tempJSON>>>%@",tempJSON);
        respone(tempJSON,mode,xNumStr);
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        DLog(@"error>>>%@",error);
        [MBProgressHUD showErrorMessage:@"连接网络超时，请稍后再试"];
    }];
}

///激活transid接口
- (void) sendCallRequestToActivationTran:(NSString *)transid{
    
    NSString *xNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
   
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:VN_TOKEN];
    if (!token) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"获取信息失败，请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
        [userManager DelInfo];
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    
    NSString *oldTrans =[[NSUserDefaults standardUserDefaults] objectForKey:VN_OLDTRANS];
    if (!oldTrans) {
        [self RequestToActivationTran:transid];
        return;
    }

    NSDictionary *headerDic = @{
                                @"token":token,
                                @"version":VN_APIVERSION
                                };
    
    NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_TRANSACTION);
    NSDictionary *parameters = @{
                                 @"x": xNumStr,
                                 @"transid":oldTrans
                                 } ;
    DLog(@"解绑Trans>>>%@",parameters);
    [MBProgressHUD showActivityMessageInView:@"请求中..."];
    [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Delete).HTTPHeader(headerDic).Parameters(parameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
            [MBProgressHUD showErrorMessage:@"服务器繁忙，请稍后再试"];
            return;
        }
        
        NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
        DLog(@"解绑Trans__tempJSON>>>%@",tempJSON);
        NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
        if ([successstr isEqualToString:@"1"]) {
            if ([[tempJSON objectForKey:@"data"] isKindOfClass:[NSArray class]])
            {
                [self RequestToActivationTran:transid];
            }else{
                [self RequestToActivationTran:transid];
            }
        }else{
             [self RequestToActivationTran:transid];
           // [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
        }
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:@"连接网络超时，请稍后再试"];
    }];

    
    
    
    
    return;
    
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    // 将第一个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
                // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    // 将第二个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        /*
        // 开始网络请求任务
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:urlString_2
          parameters:dictionary
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"成功请求数据2:%@",[responseObject class]);
                 // 如果请求成功，发送信号量
                 dispatch_semaphore_signal(semaphore);
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"失败请求数据");
                 // 如果请求失败，也发送信号量
                 dispatch_semaphore_signal(semaphore);
             }];
         */
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *strX = [userDefaults objectForKey:VN_X];
        if (!strX) {
            [MBProgressHUD showErrorMessage:@"请先绑定X号码"];
            return;
        }
        NSString *strCompany = [userDefaults objectForKey:VN_COMPANYID];
        if (!strCompany) {
            [MBProgressHUD showErrorMessage:@"请输入companyid"];
            return;
        }
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:VN_TOKEN];
        if (!token) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"获取信息失败，请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            
            [userManager DelInfo];
            KPostNotification(KNotificationLoginStateChange, @NO);
            return;
        }
        NSDictionary *headerDic = @{
                                    @"token":token,
                                    @"version":VN_APIVERSION
                                    };
        
        NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_TRANSACTION);
        NSDictionary *parameters = @{
                                     @"x":strX,
                                     @"transid":transid
                                     } ;
        DLog(@"激活transid>>>%@",parameters);
        [MBProgressHUD showActivityMessageInView:@"请求中..."];
        
        [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Put).HTTPHeader(headerDic).Parameters(parameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUD];
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
                [MBProgressHUD showErrorMessage:@"服务器繁忙，请稍后再试"];
                return;
            }
            
            NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
            DLog(@"激活tempJSON>>>%@",tempJSON);
            NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
            if ([successstr isEqualToString:@"1"]) {
                // 如果请求成功，发送信号量
                dispatch_semaphore_signal(semaphore);
                NSString * xNumStr = [NSString stringWithFormat:@"%@%@",VN_CALLPREFIX,strX];
                NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel://%@",xNumStr];
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
            }else{
                // 如果请求失败，也发送信号量
                dispatch_semaphore_signal(semaphore);
                [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
            }
        } progress:^(NSProgress *progress) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            // 如果请求失败，也发送信号量
            dispatch_semaphore_signal(semaphore);
            [MBProgressHUD hideHUD];
            [MBProgressHUD showErrorMessage:@"连接网络超时，请稍后再试"];
        }];
        // 在网络请求任务成功之前，信号量等待中
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"完成了网络请求，不管网络请求失败了还是成功了。");
    });

}

-(void)RequestToActivationTran:(NSString *)transid{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strX = [userDefaults objectForKey:VN_X];
    if (!strX) {
        [MBProgressHUD showErrorMessage:@"请先绑定X号码"];
        return;
    }
    NSString *strCompany = [userDefaults objectForKey:VN_COMPANYID];
    if (!strCompany) {
        [MBProgressHUD showErrorMessage:@"请输入companyid"];
        return;
    }
  
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:VN_TOKEN];
    if (!token) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"获取信息失败，请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
        [userManager DelInfo];
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    NSDictionary *headerDic = @{
                                @"token":token,
                                @"version":VN_APIVERSION
                                };
    
    NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_TRANSACTION);
    NSDictionary *parameters = @{
                                 @"x":strX,
                                 @"transid":transid
                                 } ;
    DLog(@"激活transid>>>%@",parameters);
    [MBProgressHUD showActivityMessageInView:@"请求中..."];
    
    [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Put).HTTPHeader(headerDic).Parameters(parameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
            [MBProgressHUD showErrorMessage:@"服务器繁忙，请稍后再试"];
            return;
        }
        
        NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
        DLog(@"激活tempJSON>>>%@",tempJSON);
        NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
        if ([successstr isEqualToString:@"1"]) {
            NSString * xNumStr = [NSString stringWithFormat:@"%@%@",VN_CALLPREFIX,strX];
            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel://%@",xNumStr];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
        }else{
            [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
        }
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:@"连接网络超时，请稍后再试"];
    }];
    
}


///去激活transid接口
-(BOOL) DelResult{
    static BOOL resultBool = false;
    
    NSString *xNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
    NSString *oldTrans =[[NSUserDefaults standardUserDefaults] objectForKey:VN_OLDTRANS];
    if (!oldTrans) {
        resultBool = true;
        return resultBool;
    }
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:VN_TOKEN];
    if (!token) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"获取信息失败，请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
        [userManager DelInfo];
        KPostNotification(KNotificationLoginStateChange, @NO);
        return resultBool;
    }
    NSDictionary *headerDic = @{
                                @"token":token,
                                @"version":VN_APIVERSION
                                };
    
    NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_TRANSACTION);
    NSDictionary *parameters = @{
                                 @"x": xNumStr,
                                 @"transid":oldTrans
                                 } ;
    DLog(@"解绑Trans>>>%@",parameters);
    [MBProgressHUD showActivityMessageInView:@"请求中..."];
    [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Delete).HTTPHeader(headerDic).Parameters(parameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
            [MBProgressHUD showErrorMessage:@"服务器繁忙，请稍后再试"];
            return;
        }
        
        NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
        DLog(@"解绑tempJSON>>>%@",tempJSON);
        NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
        if ([successstr isEqualToString:@"1"]) {
            if ([[tempJSON objectForKey:@"data"] isKindOfClass:[NSArray class]])
            {
                resultBool = true;
            }
            
        }else{
            //            resultBool = true;
            [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
        }
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:@"连接网络超时，请稍后再试"];
    }];
    
    return resultBool;
}

@end
