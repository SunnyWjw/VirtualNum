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
@property (nonatomic,strong)NSMutableArray *dataArray;;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *chooseLab;
@property (strong, nonatomic) UITextField *phoneTF;
@property (strong, nonatomic) UIButton *popBtn;

@property (nonatomic,strong)NSDictionary *dictionary;
@property (nonatomic,assign) int curPage;
@property (nonatomic,assign) int pageSizeCount;


@end

static BOOL InfiniteBool;   //上拉加载
static BOOL PullBool;   //下拉刷新

@implementation ChooseNumViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择X号码";
    // 设置导航控制器的代理为self
    //self.navigationController.delegate = self;
//    self.navigationController.navigationBar.hidden = YES;
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.curPage = 1;
    [self creadTableView];
    
    InfiniteBool = NO;
    PullBool = YES;
    
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
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(0);
//        make.left.equalTo(self.view).with.offset(0);
//        make.right.equalTo(self.view).with.offset(0);
//        make.bottom.equalTo(self.view).with.offset(0);
//    }];
    
    __weak ChooseNumViewController *weakself=self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakself stopPull];
    }];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakself stopInfinite];
    }];
}

#pragma mark -
#pragma mark 上拉加载
- (void)stopInfinite
{
    if (self.curPage >= self.pageSizeCount) {
        [self.tableView.infiniteScrollingView stopAnimating];
        [MBProgressHUD showErrorMessage:@"这是最后一页了！"];
        return;
    }
    InfiniteBool = YES;
    PullBool = NO;
    // 停止上拉加载
    [self.tableView.pullToRefreshView stopAnimating];
    self.curPage = self.curPage+1;
    //    //开始刷新数据
    [self SendRequestWithPage:self.curPage];
}

#pragma mark 下拉刷新
- (void)stopPull
{
    self.curPage = 1;
    InfiniteBool = NO;
    PullBool = YES;
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    [self SendRequestWithPage:self.curPage];
    [self.tableView.pullToRefreshView stopAnimating];
}


-(void)SendRequestWithPage:(int)page{
    NSString *comPanyIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_COMPANYID];
    if (!comPanyIDStr) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"获取信息失败，请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
        [userManager DelInfo];
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    
    NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_phone);
    //    NSDictionary *parameters = @{
    //                                 @"companyid": comPanyIDStr,
    //                                 } ;
    
    NSDictionary *parameters = @{
                                 @"page": [NSString stringWithFormat:@"%d",page],
                                 @"pageSize": @"15"
                                 } ;
    
    DLog(@"URL>>>%@ \n parameters>>%@",baseUrl,parameters);
    //    NSDictionary *newParam = [SBAPIurl TextCodeBase64:parameters];
    [MBProgressHUD showActivityMessageInView:@"请求中..."];
    [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Post).Parameters(parameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        
        if (InfiniteBool) {
            [self.tableView.infiniteScrollingView stopAnimating];
        }else{
           [self.tableView.pullToRefreshView stopAnimating];
        }
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if([[AFNetAPIClient sharedJsonClient] parseJSONData:result] == nil){
            [MBProgressHUD showErrorMessage:@"服务器繁忙，请稍后再试"];
            return;
        }
        
        NSDictionary* tempJSON = [[AFNetAPIClient sharedJsonClient] parseJSONData:result];
        //DLog(@"tempJSON>>>%@",tempJSON);
        NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
        if ([successstr isEqualToString:@"1"]) {
            if ([[tempJSON objectForKey:@"data"] isKindOfClass:[NSArray class]])
            {
                [self.dataArray addObjectsFromArray:[tempJSON objectForKey:@"data"]];
            }
            self.pageSizeCount = [[tempJSON[@"page"] objectForKey:@"pageSize"] intValue];
            
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
        }
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (InfiniteBool) {
            [self.tableView.infiniteScrollingView stopAnimating];
        }else{
            [self.tableView.pullToRefreshView stopAnimating];
        }
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:@"连接网络超时，请稍后再试"];
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
    cell.TopLab.text=dic[@"companyid"];//dic[@"companyname"];
    cell.BottomLab.text=[NSString stringWithFormat:@"X: %@,companyid: %@",dic[@"xs"],dic[@"companyid"]]; //dic[@"xs"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _dictionary = [self.dataArray objectAtIndex:indexPath.row];
    NSString * xNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
    if (!xNumStr) {
        [self showPopView:_dictionary];
    }else{
        [MBProgressHUD showErrorMessage:@"已绑定号码，不可修改"];
        return;
    }
}

-(void)showPopView:(NSDictionary *)dic{
    NSString *msgStr =[NSString stringWithFormat:@"您确定绑定 ‘%@’ 号码",dic[@"xs"]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msgStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil, nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];//UIAlertViewStyleLoginAndPasswordInput];
    UITextField *nameField = [alert textFieldAtIndex:0];
    nameField.placeholder = @"请输入需要绑定的手机号码";
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *phoneField = [alertView textFieldAtIndex:0];
        //TODO
        DLog(@"phoneField>>%@",phoneField.text);
        if (phoneField.text.length == 0) {
            [MBProgressHUD showErrorMessage:@"手机号不能为空"];
            return;
        }
        
        if (![phoneField.text checkPhoneNumInput:phoneField.text]) {
            [MBProgressHUD showErrorMessage:@"请输入正确的手机号"];
            return;
        }
        [self sendBingRequest:phoneField.text OtherDic:self.dictionary];
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
    //    [dictionary setObject:companyInfo[@"xs"] forKey:@"x"];
    [dictionary setObject:@"80246994" forKey:@"x"];
    [dictionary setObject:companyInfo[@"companyid"] forKey:@"companyid"];
    [dictionary setObject:companyInfo[@"companyname"] forKey:@"companyname"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"15900000794" forKey:@"a"];
    //    [dictionary setObject:companyInfo[@"xs"] forKey:@"x"];
    [dic setObject:@"80246994" forKey:@"x"];
    [dic setObject:companyInfo[@"companyid"] forKey:@"companyid"];
    [dic setObject:companyInfo[@"companyname"] forKey:@"companyname"];
    
    
    NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_AX);
    NSDictionary *updateParameters = @{
                                       @"newItem": dictionary,
                                       @"oldItem": dic,
                                       @"type": @"update"
                                       } ;
    //    NSDictionary *cretateParameters = @{
    //                                       @"newItem": dictionary,
    //                                       @"oldItem": @{},
    //                                       @"type": @"create"
    //                                       } ;
    DLog(@"parameters>>>%@",updateParameters);
    [MBProgressHUD showActivityMessageInView:@"请求中..."];
    [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Put).Parameters(updateParameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
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
            if ([[tempJSON objectForKey:@"data"] isKindOfClass:[NSArray class]])
            {
                [MBProgressHUD showErrorMessage:@"绑定成功"];
                [[NSUserDefaults standardUserDefaults] setObject:@"80246994" forKey:VN_X];
                [[NSUserDefaults standardUserDefaults] setObject:phoneNumStr forKey:VN_PHONE];
                [[NSUserDefaults standardUserDefaults]setObject:companyInfo[@"companyname"] forKey:VN_COMPANYNAME];
            }
            
        }else{
            [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
        }
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:@"连接网络超时，请稍后再试"];
    }];
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
