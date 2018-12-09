//
//  ChooseNumViewController.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/25.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "ChooseNumViewController.h"
#import "ChooseNumCell.h"
#import "HWPopTool.h"

@interface ChooseNumViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *chooseLab;
@property (strong, nonatomic) UITextField *phoneTF;
@property (strong, nonatomic) UIButton *popBtn;

@property (nonatomic,strong)NSDictionary *dictionary;
@property (nonatomic,assign) int curPage;
@property (nonatomic,assign) int totalCount;


@end


@implementation ChooseNumViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"选择X号码",nil);
    // 设置导航控制器的代理为self
    //self.navigationController.delegate = self;
    //    self.navigationController.navigationBar.hidden = YES;
    self.dataArray = [[NSMutableArray alloc]init];
    
    self.curPage = 1;
    [self creadTableView];
    
    [self SendRequestWithPage:self.curPage];
}


- (void)viewDidAppear:(BOOL)animated {
    
}

-(void)creadTableView{
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = self.view.bounds;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    //默认block方法：设置下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf stopPull];
    }];
    
    //默认block方法：设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [weakSelf stopInfinite];
    }];
}

#pragma mark -
#pragma mark 上拉加载
- (void)stopInfinite
{
    self.curPage = self.curPage+1;
    int pageCount = ceil(self.totalCount / 15.0);
    if (self.curPage > pageCount) {
        [self endRefresh];
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"这是最后一页了！",nil)];
        return;
    }
    //    //开始刷新数据
    [self SendRequestWithPage:self.curPage];
}

#pragma mark 下拉刷新
- (void)stopPull
{
    self.curPage = 1;
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    [self SendRequestWithPage:self.curPage];
}
/**
 *  停止刷新
 */
-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

///获取可选择的X
-(void)SendRequestWithPage:(int)page{
    NSString *comPanyIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_COMPANYID];
    if (!comPanyIDStr) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"获取信息失败，请重新登录",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
        [userManager DelInfo];
        KPostNotification(KNotificationLoginStateChange, @NO);
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
    NSString *strPhone = [[NSUserDefaults standardUserDefaults] objectForKey:VN_PHONE];
    
    NSDictionary *headerDic = @{
                                @"token":token,
                                @"version":VN_APIVERSION
                                };
    NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_phone);
//        NSDictionary *parameters = @{
//                                     @"companyid": comPanyIDStr,
//                                     } ;
    NSDictionary *parameters = @{
                                 @"page": [NSString stringWithFormat:@"%d",page],
                                 @"pageSize": @"10",
                                 @"a":strPhone
                                 } ;
    DLog(@"URL>>>%@ \n parameters>>%@",baseUrl,parameters);
    //    NSDictionary *newParam = [SBAPIurl TextCodeBase64:parameters];
    [MBProgressHUD showActivityMessageInView:@""];
    [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Post).HTTPHeader(headerDic).Parameters(parameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        
        [self endRefresh];
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
            [MBProgressHUD showErrorMessage:NSLocalizedString(@"服务器繁忙，请稍后再试",nil)];
            return;
        }
        
        NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
        DLog(@"tempJSON>>>%@",tempJSON);
        NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
        if ([successstr isEqualToString:@"1"]) {
            if ([[tempJSON objectForKey:@"data"] isKindOfClass:[NSArray class]])
            {
                [self.dataArray addObjectsFromArray:[tempJSON objectForKey:@"data"]];
            }
            self.totalCount = [[tempJSON[@"page"] objectForKey:@"total"] intValue];
            
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
        }
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefresh];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"连接网络超时，请稍后再试",nil)];
    }];
}


#pragma mark -
#pragma mark UITableView dataSourse数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.dataArray count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellId";
    
    ChooseNumCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[ChooseNumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    cell.TopLab.text = dic[@"xs"];//dic[@"companyname"];
    cell.BottomLab.text = [NSString stringWithFormat:@"companyname: %@,companyid: %@",dic[@"companyname"],dic[@"companyid"]]; //dic[@"xs"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _dictionary = [self.dataArray objectAtIndex:indexPath.row];
    NSString *msgStr =[NSString stringWithFormat:@"%@ ‘%@’ %@",NSLocalizedString(@"您确定绑定",nil),_dictionary[@"xs"],NSLocalizedString(@"号码",nil)];
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msgStr delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"确定",nil),nil, nil];
    alert.tag = 10009;
    [alert show];
    //NSString * xNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
//    if (!xNumStr) {
//        [self showPopView:_dictionary];
//    }else{
//        [MBProgressHUD showErrorMessage:@"已绑定号码，不可修改"];
//        return;
//    }
}

-(void)showPopView:(NSDictionary *)dic{
    NSString *msgStr = [NSString stringWithFormat:@"%@ ‘%@’ %@",NSLocalizedString(@"您确定绑定",nil),dic[@"xs"],NSLocalizedString(@"号码",nil)];
    
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msgStr delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"确定",nil),nil, nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];//UIAlertViewStyleLoginAndPasswordInput];
    UITextField *nameField = [alert textFieldAtIndex:0];
    nameField.placeholder = NSLocalizedString(@"请输入需要绑定的手机号码",nil);
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10009) {
        if (buttonIndex == 1) {
            [self sendBingRequest:[[NSUserDefaults standardUserDefaults]objectForKey:VN_PHONE] OtherDic:self.dictionary];
			return;
        }
    }
	if (alertView.tag == 122)
	{
		if (buttonIndex == 0) {
			[self.navigationController popViewControllerAnimated:NO];
			return;
		}
	}
	
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *phoneField = [alertView textFieldAtIndex:0];
        //TODO
        DLog(@"phoneField>>%@",phoneField.text);
        if (phoneField.text.length == 0) {
            [MBProgressHUD showErrorMessage:NSLocalizedString(@"手机号不能为空",nil)];
            return;
        }
        
//        if (![phoneField.text checkPhoneNumInput:phoneField.text]) {
//            [MBProgressHUD showErrorMessage:NSLocalizedString(@"请输入正确的手机号",nil)];
//            return;
//        }
        [self sendBingRequest:phoneField.text OtherDic:self.dictionary];
		return;
    }
}


/**
 绑定AX
 @param phoneNumStr 需要绑定的手机号码
 @param companyInfo 企业相关信息
 */
-(void)sendBingRequest:(NSString *)phoneNumStr OtherDic:(NSDictionary *)companyInfo{
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:phoneNumStr forKey:@"a"];
    [dictionary setObject:companyInfo[@"xs"] forKey:@"x"];
    //[dictionary setObject:@"80246994" forKey:@"x"];
    [dictionary setObject:companyInfo[@"companyid"] forKey:@"companyid"];
    [dictionary setObject:companyInfo[@"companyname"] forKey:@"companyname"];

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
    NSDictionary *cretateParameters = @{
                                        @"newItem": dictionary,
                                        @"oldItem": @{},
                                        @"type": @"create"
                                        };
    DLog(@"baseUrl>>>%@",baseUrl);
    DLog(@"parameters>>>%@",cretateParameters);
    [MBProgressHUD showActivityMessageInView:NSLocalizedString(@"请求中...",nil)];
    [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Put).HTTPHeader(headerDic).Parameters(cretateParameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
            [MBProgressHUD showErrorMessage:NSLocalizedString(@"服务器繁忙，请稍后再试",nil)];
            return;
        }
        
        NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
        DLog(@"tempJSON>>>%@",tempJSON);
        NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
        if ([successstr isEqualToString:@"1"]) {
            if ([[tempJSON objectForKey:@"data"] isKindOfClass:[NSArray class]])
            {
//                [MBProgressHUD showErrorMessage:@"绑定成功"];
                //                [[NSUserDefaults standardUserDefaults] setObject:@"80246994" forKey:VN_X];
                [[NSUserDefaults standardUserDefaults] setObject:companyInfo[@"xs"] forKey:VN_X];
                
                [[NSUserDefaults standardUserDefaults] setObject:phoneNumStr forKey:VN_PHONE];
                [[NSUserDefaults standardUserDefaults]setObject:companyInfo[@"companyname"] forKey:VN_COMPANYNAME];
                
//                [self.navigationController popViewControllerAnimated:NO];
				[self showAlertForTitle:NSLocalizedString(@"绑定成功",nil) Message:@""];
            }
            
        }else{
            [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
        }
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"error>>>%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"连接网络超时，请稍后再试",nil)];
    }];
}


-(void)showAlertForTitle:(NSString *)title Message:(NSString *)Msgstr{
	UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:Msgstr delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
	alertView.tag = 122;
	[alertView show];
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
