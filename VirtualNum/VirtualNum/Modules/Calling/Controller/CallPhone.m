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

#pragma mark - 创建AXB记录
-(void)sendCallRequestForBindAXB:(NSString *)phoneNum ContactName:(NSString *)contactName Respone:( CallResponeBlcok )respone{
    
    //先清除再保存
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:VN_CallPhoneNum];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:VN_ContactName];
    [[NSUserDefaults standardUserDefaults] setObject:phoneNum forKey:VN_CallPhoneNum];
    [[NSUserDefaults standardUserDefaults] setObject:contactName forKey:VN_ContactName];
    
    NSString *comPanyIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_COMPANYID];
    if (!comPanyIDStr) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"获取信息失败，请重新登录",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定",nil), nil];
        [alertView show];
        [userManager DelInfo];
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
	
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *aNumStr = [userDefaults objectForKey:VN_PHONE];
    if (!aNumStr) {
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"请先绑定手机号码",nil)];
        return;
    }
    NSString *xNumStr = [userDefaults objectForKey:VN_X];
    if (!xNumStr) {
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"请先绑定X号码",nil)];
        return;
    }
    NSString *companyIDStr = [userDefaults objectForKey:VN_COMPANYID];
    if (!companyIDStr) {
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"请输入companyid",nil)];
        return;
    }
    NSString *companyNameStr = [userDefaults objectForKey:VN_COMPANYNAME];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *randomNum = [numberFormatter numberFromString:[TimeAndTimeStamps getNowDateTimeFoMillisecond]];
    
    NSString * strTransid =[NSString stringWithFormat:@"%@%@",companyIDStr,randomNum] ;
	//保存生成的transID
    [[NSUserDefaults standardUserDefaults] setObject:strTransid forKey:VN_TRANS];
	NSLog(@"呼叫产生的TRANSID是:%@",strTransid);
	
    NSString *mode = [userDefaults objectForKey:VN_SERVICE];
    mode = [mode isEqual:@"0"] ? @"dual" : @"single";
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:aNumStr forKey:@"a"];
    [dictionary setValue:xNumStr forKey:@"x"];
    [dictionary setValue:phoneNum forKey:@"b"];
//    if ([mode isEqualToString:@"dual"]) {
	//单向模式也生成transID
	[dictionary setValue:[NSString stringWithFormat:@"%@",strTransid] forKey:@"trans"];
//    }else{
//        [dictionary setValue:@"" forKey:@"trans"];
//    }
    [dictionary setValue:mode forKey:@"mode"];
    [dictionary setValue:companyIDStr forKey:@"companyid"];
    [dictionary setValue:companyNameStr forKey:@"companyname"];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:VN_TOKEN];
    if (!token) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"获取信息失败，请重新登录",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定",nil), nil];
        [alertView show];
        
        [userManager DelInfo];
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
	NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_AXB);
    NSDictionary *headerDic = @{
                                @"token":token,
                                @"version":VN_APIVERSION
                                };
    
    NSDictionary *parameters = @{
                                 @"newItem": dictionary,
                                 @"oldItem": @{},
                                 @"type": @"create"
                                 } ;
    DLog(@"请求地址>>>%@",baseUrl);
    DLog(@"绑定AXBparameters>>>%@",parameters);
    [MBProgressHUD showActivityMessageInView:NSLocalizedString(@"请求中...",nil)];
    [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Put).HTTPHeader(headerDic).Parameters(parameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
            [MBProgressHUD showErrorMessage:NSLocalizedString(@"服务器繁忙，请稍后再试",nil)];
            return;
        }
        
        NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
        respone(tempJSON,mode,xNumStr);
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        DLog(@"error>>>%@",error);
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"连接网络超时，请稍后再试",nil)];
    }];
}

#pragma mark - 删除AXB记录
- (void) DelBindAXB:(NSDictionary *)dic Respone:( CallResponeBlcok )respone{
		//目前trans 和 axb分别是独立的，所以无先后关系
		//1、先去激活transid
		[self unBindTrans:dic[@"TRANS"]];
	
		//2、删除AXB记录
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		NSString *aNumStr = [userDefaults objectForKey:VN_PHONE];
		if (!aNumStr) {
			[MBProgressHUD showErrorMessage:NSLocalizedString(@"请先绑定手机号码",nil)];
			return;
		}
		NSString *companyIDStr = [userDefaults objectForKey:VN_COMPANYID];
		if (!companyIDStr) {
			[MBProgressHUD showErrorMessage:NSLocalizedString(@"请输入companyid",nil)];
			return;
		}
		NSString *companyNameStr = [userDefaults objectForKey:VN_COMPANYNAME];
		
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
		[dictionary setValue:aNumStr forKey:@"a"];
		[dictionary setValue:dic[@"X"] forKey:@"x"];
		[dictionary setValue:dic[@"B"] forKey:@"b"];
		[dictionary setValue:dic[@"TRANS"] forKey:@"trans"];
		[dictionary setValue:dic[@"MODE"] forKey:@"mode"];
		[dictionary setValue:companyIDStr forKey:@"companyid"];
		[dictionary setValue:companyNameStr forKey:@"companyname"];
		
		NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:VN_TOKEN];
		if (!token) {
			
			UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"获取信息失败，请重新登录",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定",nil), nil];
			[alertView show];
			
			[userManager DelInfo];
			KPostNotification(KNotificationLoginStateChange, @NO);
			return;
		}
		NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_AXB);
		NSDictionary *headerDic = @{
									@"token":token,
									@"version":VN_APIVERSION
									};
		
		NSDictionary *parameters = @{
									 @"newItem": dictionary,
									 @"oldItem": @{},
									 @"type": @"create"
									 } ;
		DLog(@"请求地址>>>%@",baseUrl);
		DLog(@"绑定AXBparameters>>>%@",parameters);
		[MBProgressHUD showActivityMessageInView:NSLocalizedString(@"请求中...",nil)];
		[[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Delete).HTTPHeader(headerDic).Parameters(parameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
			[MBProgressHUD hideHUD];
			NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
			if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
				[MBProgressHUD showErrorMessage:NSLocalizedString(@"服务器繁忙，请稍后再试",nil)];
				return;
			}
			
			NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
			respone(tempJSON,dic[@"MODE"],dic[@"X"]);
		} progress:^(NSProgress *progress) {
			
		} failure:^(NSURLSessionDataTask *task, NSError *error) {
			[MBProgressHUD hideHUD];
			DLog(@"error>>>%@",error);
			[MBProgressHUD showErrorMessage:NSLocalizedString(@"连接网络超时，请稍后再试",nil)];
		}];
}


///激活transid接口
/**
 解绑Trans

 @param transid transid description
 */
#pragma mark - 解绑Trans后激活trans
- (void) sendCallRequestToActivationTran:(NSString *)transid{
    
    NSString *xNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
   
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:VN_TOKEN];
    if (!token) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"获取信息失败，请重新登录",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定",nil), nil];
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
    [MBProgressHUD showActivityMessageInView:NSLocalizedString(@"请求中...",nil)];
    [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Delete).HTTPHeader(headerDic).Parameters(parameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
            [MBProgressHUD showErrorMessage:NSLocalizedString(@"服务器繁忙，请稍后再试",nil)];
            return;
        }
        
        NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
        NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
        if ([successstr isEqualToString:@"1"]) {
//			 [MBProgressHUD showTopTipMessage:@"解绑Trans：%@成功" isWindow:YES];
            if ([[tempJSON objectForKey:@"data"] isKindOfClass:[NSArray class]])
            {
                [self RequestToActivationTran:transid];
            }else{
                [self RequestToActivationTran:transid];
            }
        }else{
			 [MBProgressHUD showTopTipMessage:tempJSON[@"message"] isWindow:YES];
             [self RequestToActivationTran:transid];
//            [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
//			return;
        }
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"连接网络超时，请稍后再试",nil)];
    }];
}

#pragma mark - 解绑Trans
-(void)unBindTrans:(NSString *)oldTrans{
	NSString *xNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
	
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:VN_TOKEN];
	if (!token) {
		return;
	}
	
	if (!oldTrans) {
		return;
	}
	NSLog(@"解绑的TRANSID是:%@",oldTrans);
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
	[[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Delete).HTTPHeader(headerDic).Parameters(parameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
		[MBProgressHUD hideHUD];
		NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
			//[MBProgressHUD showErrorMessage:NSLocalizedString(@"服务器繁忙，请稍后再试",nil)];
			return;
		}
		
		NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
		NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
		if ([successstr isEqualToString:@"1"]) {
			NSLog(@"解绑定成功>>>>");
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:VN_OLDTRANS];
		}else{
			NSLog(@"解绑Trans失败，%@",tempJSON[@"message"]);
			return;
		}
	} progress:^(NSProgress *progress) {
		
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
//		[MBProgressHUD hideHUD];
//		[MBProgressHUD showErrorMessage:NSLocalizedString(@"连接网络超时，请稍后再试",nil)];
		NSLog(@"连接网络超时，请稍后再试,,,%@",error);
	}];
	
}

#pragma mark - 激活transid
-(void)RequestToActivationTran:(NSString *)transid{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strX = [userDefaults objectForKey:VN_X];
    if (!strX) {
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"请先绑定X号码",nil)];
        return;
    }
    NSString *strCompany = [userDefaults objectForKey:VN_COMPANYID];
    if (!strCompany) {
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"请输入companyid",nil)];
        return;
    }
  
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:VN_TOKEN];
    if (!token) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"获取信息失败，请重新登录",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定",nil), nil];
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
    [MBProgressHUD showActivityMessageInView:NSLocalizedString(@"请求中...",nil)];
    
    [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Put).HTTPHeader(headerDic).Parameters(parameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
            [MBProgressHUD showErrorMessage:NSLocalizedString(@"服务器繁忙，请稍后再试",nil)];
            return;
        }
        
        NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
        NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
        if ([successstr isEqualToString:@"1"]) {
			DLog(@"激活TRANSID:%@ 成功",transid);
            NSString * xNumStr = [NSString stringWithFormat:@"%@%@",VN_CALLPREFIX,strX];
            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel://+86%@",xNumStr];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
        }else{
				DLog(@"激活TRANSID:%@ 失败",transid);
            [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
        }
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"连接网络超时，请稍后再试",nil)];
    }];
    
}





@end
