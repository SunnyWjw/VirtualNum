//
//  MineViewController.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/24.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "MineViewController.h"
#import "ChooseNumViewController.h"
#import "ChooseServiceViewController.h"
#import "BindPhoneViewController.h"
#import "SetLanguageViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong) NSArray * dataArray;
@property (nonatomic,strong) UITableView *personalTableView;
@property (nonatomic,strong)UIButton *SiginOutBtn;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=NSLocalizedString(@"个人中心",nil);
    [self creadTableView];
    
    self.dataArray = @[NSLocalizedString(@"绑定X号码",nil),NSLocalizedString(@"解绑X",nil), NSLocalizedString(@"服务模式",nil),NSLocalizedString(@"语言设置",nil)];//, @"去激活Trans"];
    
}

-(void)creadTableView{
    self.personalTableView = [[UITableView alloc]init];
    self.personalTableView.delegate = self;
    self.personalTableView.dataSource = self;
    [self.view addSubview:self.personalTableView];
    [self.personalTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
    }];
    self.personalTableView.tableFooterView = [self CreateFootView];
    //    [self setExtraCellLineHidden:self.personalTableView];
}

-(UIView *)CreateFootView{
    UIView *tablefootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    //    tablefootView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    self.SiginOutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.SiginOutBtn.layer setMasksToBounds:YES];
    [self.SiginOutBtn.layer setCornerRadius:3.0];//设置矩形四个圆角半径
    self.SiginOutBtn.frame =CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width-40, 45);
    self.SiginOutBtn.backgroundColor =[UIColor colorWithHexString:@"EF271A"];
    [self.SiginOutBtn setTintColor:[UIColor whiteColor]];
    self.SiginOutBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [self.SiginOutBtn setTitle:NSLocalizedString(@"退出",nil) forState:UIControlStateNormal];
    [self.SiginOutBtn addTarget:self action:@selector(sginOutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tablefootView addSubview:self.SiginOutBtn];
    
    return tablefootView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [self.personalTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    switch (section) {
        case 0:
            num = 4;
            break;
        case 1:
            num = self.dataArray.count;
            break;
    }
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 30;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *v = nil;
    v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [v setBackgroundColor:[UIColor colorWithHexString:@"F6F6F6"]];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.view.frame.size.width, 20)];
    labelTitle.textColor = [UIColor colorWithHexString:@"959594"];
    labelTitle.font = [UIFont systemFontOfSize:14.0];
    labelTitle.textAlignment = NSTextAlignmentLeft;
    
    [v addSubview:labelTitle];
    switch (section) {
        case 0:
            labelTitle.text = NSLocalizedString(@"个人资料",nil);
            break;
        case 1:
            labelTitle.text =NSLocalizedString(@"设置",nil);
            break;
        default:
            break;
    }
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"Cell";
    static NSString *identity2 = @"cell2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:identity2];
    
    switch (indexPath.section) {
        case 0:
        {
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
                cell.accessoryType = UITableViewCellStyleDefault;
            }
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text =NSLocalizedString(@"权限",nil);
                    NSString * companyNmaeStr = [[NSUserDefaults standardUserDefaults] objectForKey:permissions];
                    if (!companyNmaeStr) {
                        companyNmaeStr = @"--";
                    }
                    cell.detailTextLabel.text =companyNmaeStr;
                }
                    break;
                case 1:
                {
                    cell.textLabel.text =NSLocalizedString(@"企业ID",nil);
                    NSString * companyIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_COMPANYID];
                    if (!companyIDStr) {
                        companyIDStr = @"--";
                    }
                    cell.detailTextLabel.text =companyIDStr;
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = NSLocalizedString(@"手机号码",nil);
                    NSString * phoneNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_PHONE];
                    if (!phoneNumStr) {
                        phoneNumStr = @"--";
                    }
                    cell.detailTextLabel.text = phoneNumStr;
                }
                    break;
                default:
                {
                    cell.textLabel.text =NSLocalizedString(@"X号码",nil);
                    NSString * xNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
                    if (!xNumStr) {
                        xNumStr = @"--";
                    }
                    cell.detailTextLabel.text =xNumStr;
                }
                    break;
            }
        }
            break;
        case 1:{
            if (cell2 == nil) {
                cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity2];
                cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            switch (indexPath.row) {
                case 0:
                {
                    cell2.textLabel.text =[self.dataArray objectAtIndex:indexPath.row];
                    NSString * phoneNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
                    if (!phoneNumStr) {
                        phoneNumStr = @"--";
                    }
                    cell2.detailTextLabel.text = phoneNumStr;
                }
                    break;
                case 1:
                {
                    cell2.textLabel.text =[self.dataArray objectAtIndex:indexPath.row];
                }
                    break;
                case 2:
                {
                    cell2.textLabel.text =[self.dataArray objectAtIndex:indexPath.row];
                    
                    NSString *callSettingsType = [[NSUserDefaults standardUserDefaults] objectForKey:VN_SERVICE];
                    NSString *callType=@"";
                    if([callSettingsType isEqualToString:@"0"]){
                        callType=NSLocalizedString(@"租车模式",nil);
                    }else{
                        callType=NSLocalizedString(@"中介模式",nil);
                    }
                    cell2.detailTextLabel.text = callType;
                }
                    break;
					
                default:
                    cell2.textLabel.text =[self.dataArray objectAtIndex:indexPath.row];
                    
                    break;
            }
        }
            break;
    }
    
    switch (indexPath.section) {
        case 0:
            return cell;
            break;
        default:
            return cell2;
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section ) {
        case 0:
        {
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    ChooseNumViewController * chooseVc = [[ChooseNumViewController alloc]init];
                    [self.navigationController pushViewController:chooseVc animated:NO];
                }
                    break;
                case 1:
                {
                    NSString *xNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
                    if (!xNumStr) {
                        [MBProgressHUD showErrorMessage:NSLocalizedString(@"请先绑定X号码",nil)];
                        return;
                    }
                    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:VN_PHONE];
                    if (!phoneNum) {
                        [MBProgressHUD showErrorMessage:NSLocalizedString(@"请先绑定手机号码",nil)];
                        return;
                    }
                    NSString *msg = [NSString stringWithFormat:@"%@ %@ ?",NSLocalizedString(@"您确定要解绑",nil),xNumStr];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:NSLocalizedString(@"取消",nil), nil];
                    alertView.tag=10086;
                    [alertView show];
                }
                    break;
                case 2:
                {
                    ChooseServiceViewController * chooseVc = [[ChooseServiceViewController alloc]init];
                    [self.navigationController pushViewController:chooseVc animated:NO];
                    
                }
                    break;
                default:
                {
//                    NSString *xNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
//                    if (!xNumStr) {
//                        [MBProgressHUD showErrorMessage:NSLocalizedString(@"请先绑定X号码",nil)];
//                        return;
//                    }
//
//                    [self sendRequestDelToTrans];
					SetLanguageViewController *langVC = [[SetLanguageViewController alloc] init];
					 [self.navigationController pushViewController:langVC animated:NO];
                }
                    break;
            }
        }
            break;
    }
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (alertView.tag == 10086)
        {
            [self sendUnBindRequest];
        }else if (alertView.tag == 122) {
            if (buttonIndex == 0) {
                [userManager DelInfo];
                KPostNotification(KNotificationLoginStateChange, @NO)
            }
        }
    }
}


/**
 发送解除解除绑定AX的请求
 */
- (void) sendUnBindRequest{
    NSString * companyIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_COMPANYID];
    NSString *xNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:VN_PHONE];
    
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
    
    NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_AX);
    NSDictionary *parameters = @{
                                 @"a": phoneNum,
                                 @"x": xNumStr,
                                 @"companyid": companyIDStr,
                                 @"companyname": NSLocalizedString(@"爱讯达",nil)
                                 } ;
    DLog(@"解绑AXparameters>>>%@",parameters);
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
            if ([[tempJSON objectForKey:@"data"] isKindOfClass:[NSArray class]])
            {
                [MBProgressHUD showErrorMessage:NSLocalizedString(@"解除绑定成功",nil)];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:VN_X];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:VN_OLDTRANS];
                [self.personalTableView reloadData];
            }
            
        }else{
            [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
        }
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"连接网络超时，请稍后再试",nil)];
    }];
}


/**
 去激活Trans
 */
-(void) sendRequestDelToTrans{
    
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
    
    NSString *xNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
    
    NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_TRANSACTION);
    NSDictionary *parameters = @{
                                 @"x": xNumStr,
                                 @"transid": @"110120170726230335339"
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
            if ([[tempJSON objectForKey:@"data"] isKindOfClass:[NSArray class]])
            {
                [MBProgressHUD showErrorMessage:NSLocalizedString(@"解除绑定成功",nil)];
                // [[NSUserDefaults standardUserDefaults]removeObjectForKey:VN_X];
                [self.personalTableView reloadData];
            }
            
        }else{
            [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
        }
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"连接网络超时，请稍后再试",nil)];
    }];
}


- (void)Delete:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure
{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain", nil];
    // 设置请求头
    [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    
    
    [manger DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
        {
            failure(error);
        }
        
    }];
}

- (void)sginOutButtonClicked:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"退出当前账号？",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:NSLocalizedString(@"取消",nil), nil];
    alertView.tag = 122;
    [alertView show];
    
}


//隐藏多余分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
