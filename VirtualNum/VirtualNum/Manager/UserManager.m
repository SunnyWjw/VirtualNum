//
//  UserManager.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/22.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

SINGLETON_FOR_CLASS(UserManager);

-(instancetype)init{
    self = [super init];
    if (self) {
        //被踢下线
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onKick)
                                                     name:KNotificationOnKick
                                                   object:nil];
    }
    return self;
}

#pragma mark ————— 三方登录 —————
-(void)login:(UserLoginType )loginType completion:(loginBlock)completion{
    [self login:loginType params:nil completion:completion];
}

#pragma mark ————— 带参数登录 —————
-(void)login:(UserLoginType )loginType params:(NSDictionary *)params completion:(loginBlock)completion{
   
    if (loginType == kUserLoginTypeQQ) {
        
    }else if (loginType == kUserLoginTypeWeChat){
        
    }else if(loginType == kUserLoginTypePwd){
        //账号登录
        [self loginToServer:params completion:completion];
    }else{
        
    }
}

#pragma mark ————— 手动登录到服务器 —————
-(void)loginToServer:(NSDictionary *)params completion:(loginBlock)completion{
    [MBProgressHUD showActivityMessageInView:@"登录中..."];
    
    NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_user_info);
    [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Post).Parameters(params) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
         [self LoginSuccess:responseObject completion:completion];
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        if (completion) {
            completion(NO,error.localizedDescription);
        }
    }];
}

#pragma mark ————— 自动登录到服务器 —————
-(void)autoLoginToServer:(loginBlock)completion{
    NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_user_info);
    NSDictionary *parameters = @{
                                 @"username": [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"],
                                 @"password": [[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"]
                                 } ;
    
    [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Post).Parameters(parameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [self LoginSuccess:responseObject completion:completion];
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(NO,error.localizedDescription);
        }
    }];
}

#pragma mark ————— 登录成功处理 —————
-(void)LoginSuccess:(id )responseObject completion:(loginBlock)completion{
    
    NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
        [MBProgressHUD showErrorMessage:@"服务器繁忙，请稍后再试"];
        return;
    }
    
    NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
    NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
    if ([successstr isEqualToString:@"1"]) {
        [MBProgressHUD showErrorMessage:@"登录成功"];
        [SaveUserInfo SaveInfo:tempJSON];
       // DLog(@"tempJSON>>%@",tempJSON);
        if (completion) {
            completion(YES,nil);
        }
        KPostNotification(KNotificationLoginStateChange, @YES);
    }else{
        if (completion) {
            completion(NO,@"登录失败");
        }
        KPostNotification(KNotificationLoginStateChange, @NO);
    }
}
#pragma mark ————— 储存用户信息 —————
-(void)saveUserInfo{
    /*
    if (self.curUserInfo) {
        YYCache *cache = [[YYCache alloc]initWithName:KUserCacheName];
        NSDictionary *dic = [self.curUserInfo modelToJSONObject];
        [cache setObject:dic forKey:KUserModelCache];
    }*/  
}
#pragma mark ————— 加载缓存的用户信息 —————
-(BOOL)loadUserInfo{
 
    return NO;
}
#pragma mark ————— 被踢下线 —————
-(void)onKick{
    [self logout:nil];
}
#pragma mark ————— 退出登录 —————
- (void)logout:(void (^)(BOOL, NSString *))completion{
    [SaveUserInfo DelInfo];
}

@end
