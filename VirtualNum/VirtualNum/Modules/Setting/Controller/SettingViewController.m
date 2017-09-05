//
//  SettingViewController.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/24.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "SettingViewController.h"
#import "ChooseNumViewController.h"
#import "UserManager.h"

@interface SettingViewController ()<UIAlertViewDelegate>
@property (strong, nonatomic) UITextField *text;
@property (strong,nonatomic)NSString *baseUrl;
@property (strong,nonatomic)NSDictionary *parameters ;
@property (strong,nonatomic)UITextView *textView;
@property (strong,nonatomic)UITextView *textView2;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"设置";
  //[self createView];
    [self CreateExit];
}

-(void) CreateExit{
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
    [exitBtn setTitle:@"请求测试" forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    exitBtn.backgroundColor=[UIColor grayColor];
    [self.view addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-64);
        make.left.equalTo(self.view).with.offset(100);
        make.right.equalTo(self.view).with.offset(-100);
        make.height.mas_equalTo(40);
    }];
}

-(void)createView{
    
    self.text = [[UITextField alloc]initWithFrame:CGRectMake(50, 100, 250, 45)];
    self.text.placeholder = @"请输入A号码";
    self.text.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.text];
    
    
    UIButton *Btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn1.frame = CGRectMake(50, 160, 200, 45);
    [Btn1 setTitle:@"获取AXB列表(3参数）" forState:UIControlStateNormal];
    [Btn1 addTarget:self action:@selector(RequestOne) forControlEvents:UIControlEventTouchUpInside];
    Btn1.backgroundColor=[UIColor grayColor];
    [self.view addSubview:Btn1];
    
    UIButton *Btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn2.frame = CGRectMake(50, 210, 200, 45);
    [Btn2 setTitle:@"获取AXB列表(2参数）" forState:UIControlStateNormal];
    [Btn2 addTarget:self action:@selector(RequestTwo) forControlEvents:UIControlEventTouchUpInside];
    Btn2.backgroundColor=[UIColor grayColor];
    [self.view addSubview:Btn2];
    
    UIButton *Btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
     Btn3.frame = CGRectMake(50, 260, 200, 45);
    [Btn3 setTitle:@"获取AXB列表(0参数）" forState:UIControlStateNormal];
    [Btn3 addTarget:self action:@selector(RequestThree) forControlEvents:UIControlEventTouchUpInside];
    Btn3.backgroundColor=[UIColor grayColor];
    [self.view addSubview:Btn3];
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 330, 400, 120)];
    self.textView.textColor = [UIColor redColor];
    self.textView.font = [UIFont systemFontOfSize:14.0];
    self.textView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.textView];
    
    self.textView2= [[UITextView alloc]initWithFrame:CGRectMake(10, 460, 400, 150)];
    self.textView2.textColor = [UIColor redColor];
    self.textView2.font = [UIFont systemFontOfSize:14.0];
    self.textView2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.textView2];
    
    
   
    
}

- (void)RequestOne
{
    self.textView.text=@"";
    self.textView2.text = @"";
//    if (![self.text.text checkPhoneNumInput:self.text.text]) {
//        [MBProgressHUD showErrorMessage:@"请输入正确的手机号"];
//        return;
//    }
    if (self.text.text.length == 0) {
        [MBProgressHUD showErrorMessage:@"请输入手机号"];
        return;
    }
    self.baseUrl = NSStringFormat(@"%@%@",URL_main,URL_AXB);
    self.parameters = @{
                                 @"page": @"1",
                                 @"pageSize": @"20",
                                 @"a":self.text.text
                                 } ;
    self.textView.text = [NSString stringWithFormat:@"3参数，请求地址:%@\n参数:%@",self.baseUrl,self.parameters];
    [self SendRequestToURL:self.baseUrl Parameters:self.parameters];
}
- (void)RequestTwo
{
    self.textView.text=@"";
    self.textView2.text = @"";
    self.baseUrl = NSStringFormat(@"%@%@",URL_main,URL_AXB);
    self.parameters = @{
                                 @"page": @"1",
                                 @"pageSize": @"20",
                                 } ;
    self.textView.text = [NSString stringWithFormat:@"2参数请求地址:%@\n参数:%@",self.baseUrl,self.parameters];
    [self SendRequestToURL:self.baseUrl Parameters:self.parameters];
}

- (void)RequestThree
{
    self.textView.text=@"";
    self.textView2.text = @"";
    self.baseUrl = NSStringFormat(@"%@%@",URL_main,URL_AXB);
    self.parameters = @{
                                 } ;
    self.textView.text = [NSString stringWithFormat:@"0参数请求地址:%@\n参数:%@",self.baseUrl,self.parameters];
    [self SendRequestToURL:self.baseUrl Parameters:self.parameters];
}

-(void)SendRequestToURL:(NSString *) url Parameters:(NSDictionary *)dic{
    NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_AXB);
   
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:VN_TOKEN];
    NSDictionary *headerDic = @{
                                @"token":token,
                                @"version":VN_APIVERSION
                                };
 
    DLog(@" 获取AXB.... URL>>>%@ \n parameters>>%@",url,dic);
    //    NSDictionary *newParam = [SBAPIurl TextCodeBase64:parameters];
    [MBProgressHUD showActivityMessageInView:@"请求中..."];
    [[AFNetAPIClient sharedJsonClient].setRequest(url).RequestType(Post).HTTPHeader(headerDic).Parameters(dic)startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        

        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
            [MBProgressHUD showErrorMessage:@"服务器繁忙，请稍后再试"];
            return;
        }
        
        NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
        DLog(@"tempJSON>>>%@",tempJSON);
        self.textView2.text = [NSString stringWithFormat:@"返回信息:%@",tempJSON];
        NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
        if ([successstr isEqualToString:@"1"]) {
//            if ([[tempJSON objectForKey:@"data"] isKindOfClass:[NSArray class]])
//            {
//                [self.dataArray addObjectsFromArray:[tempJSON objectForKey:@"data"]];
//            }
//            self.totalCount = [[tempJSON[@"page"] objectForKey:@"total"] intValue];
//            
//            [self.tableView reloadData];
            [MBProgressHUD showErrorMessage:@"请求成功"];
            
        }else{
            [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
        }
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:@"连接网络超时，请稍后再试"];
    }];
}


#pragma mark 退出当前账号
- (void)exitBtnClick
{
    [self sendRequest];
    return;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 122)
    {
        if (buttonIndex == 0) {
            [userManager DelInfo];
            KPostNotification(KNotificationLoginStateChange, @NO)
        }
    }else if (alertView.tag ==123){
        if (buttonIndex == 0) {
            [self SendRequestToURL:self.baseUrl Parameters:self.parameters];
        }
    }
}


-(void)sendRequest{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strX = [userDefaults objectForKey:VN_X];

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
                                 @"x":strX
                                 } ;
     DLog(@"baseUrl>>>%@",baseUrl);
    DLog(@"查询transid>>>%@",parameters);
    [MBProgressHUD showActivityMessageInView:@"请求中..."];
    
    [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Get).HTTPHeader(headerDic).Parameters(parameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
            [MBProgressHUD showErrorMessage:@"服务器繁忙，请稍后再试"];
            return;
        }
        
        NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
        DLog(@"tempJSON>>>%@",tempJSON);
//        NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
//        if ([successstr isEqualToString:@"1"]) {
//            NSString * xNumStr = [NSString stringWithFormat:@"%@%@",VN_CALLPREFIX,strX];
//            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel://%@",xNumStr];
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
//        }else{
//            [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
//        }
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog("error>>>%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:@"连接网络超时，请稍后再试"];
    }];

}


/**
 隐藏键盘
 
 @param touches <#touches description#>
 @param event <#event description#>
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.text resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
