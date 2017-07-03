//
//  CallPhone.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/2.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "CallPhone.h"

@implementation CallPhone


+(void) sendCallRequest:(NSString *)phoneNum ContactName:(NSString *)contactName{
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
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:aNumStr forKey:@"a"];
    [dictionary setValue:xNumStr forKey:@"x"];
    [dictionary setValue:phoneNum forKey:@"b"];
    [dictionary setValue:@"11" forKey:@"trans"];
    [dictionary setValue:@"single" forKey:@"mode"];
    [dictionary setValue:companyIDStr forKey:@"companyid"];
    [dictionary setValue:companyNameStr forKey:@"companyname"];
    
    NSDictionary *parameters = @{
                                 @"newItem": dictionary,
                                 @"oldItem": @{},
                                 @"type": @"create"
                                 //@"type": @"update"
                                 } ;
    DLog(@"parameters>>>%@",parameters);
    [MBProgressHUD showActivityMessageInView:@"请求中..."];
    [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Post).Parameters(parameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
            [MBProgressHUD showErrorMessage:@"服务器繁忙，请稍后再试"];
            return;
        }
        
        NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
        DLog(@"tempJSON>>>%@",tempJSON);
        NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
        if ([successstr isEqualToString:@"1"]) {
            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel://%@",phoneNum];
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

@end
