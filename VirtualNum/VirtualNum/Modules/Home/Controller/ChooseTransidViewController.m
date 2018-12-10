//
//  ChooseTransidViewController.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/17.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "ChooseTransidViewController.h"
#import "ChooseNumCell.h"
#import "CallPhone.h"

@interface ChooseTransidViewController ()<UITableViewDataSource,UITableViewDelegate,SelectTransDelegate>

@property (nonatomic,strong) CallPhone *callphone;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;


@property (nonatomic,assign) int curPage;
@property (nonatomic,assign) int totalCount;

@end

@implementation ChooseTransidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"选择TransID",nil);
    // 设置导航控制器的代理为self
    //self.navigationController.delegate = self;
    //    self.navigationController.navigationBar.hidden = YES;
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.curPage = 1;
    [self creadTableView];
    
    [self SendRequestWithPage:self.curPage];
    
    //[self SendRequestToCall];
}

-(void)creadTableView{
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = self.view.bounds;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
		[Common setExtraCellLineHidden:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    //默认block方法：设置下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf stopPull];
    }];
    
    //默认block方法：设置上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [weakSelf stopInfinite];
    }];}

#pragma mark -
#pragma mark 上拉加载
- (void)stopInfinite
{
    self.curPage = self.curPage+1;
    int pageCount = ceil(self.totalCount / 10.0);
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


-(void)SendRequestWithPage:(int)page{
    NSString *comPanyIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_COMPANYID];
    if (!comPanyIDStr) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"获取信息失败，请重新登录",nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定",nil), nil];
        [alertView show];
        
        [userManager DelInfo];
        KPostNotification(KNotificationLoginStateChange, @NO);
        return;
    }
    
    NSString *strPhone = [[NSUserDefaults standardUserDefaults] objectForKey:VN_PHONE];
    
    NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_AXB);
    NSDictionary *parameters = @{
                                 @"page": [NSString stringWithFormat:@"%d",page],
                                 @"pageSize": @"10",//[NSString stringWithFormat:@"%d",10 * page],
                                 @"a":strPhone
                                 } ;
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

    DLog(@" 获取AXB.... URL>>>%@ \n parameters>>%@",baseUrl,parameters);
    //    NSDictionary *newParam = [SBAPIurl TextCodeBase64:parameters];
    [MBProgressHUD showActivityMessageInView:NSLocalizedString(@"请求中...",nil)];
    [[AFNetAPIClient sharedJsonClient].setRequest(baseUrl).RequestType(Post).HTTPHeader(headerDic).Parameters(parameters) startRequestWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUD];
        
        [self endRefresh];
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
        cell = [[ChooseNumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID isShowDel:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
	cell.selectTransDelegate = self;
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    cell.TopLab.text = [NSString stringWithFormat:@"X:%@, Trans:%@",dic[@"x"],dic[@"t"]];
    cell.BottomLab.text = [NSString stringWithFormat:@"B:%@, MODE:%@",dic[@"b"],dic[@"mode"]];
	
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
    NSString *mode =dic[@"mode"];
    NSString *trans =dic[@"t"];
    
    if (mode.length == 0 || ![mode isEqualToString:@"dual"]) {
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"请选择MODE为dual的数据！",nil)];
        return;
    }
    if (trans.length == 0) {
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"请选择trans不为空的数据!",nil)];
        return;
    }
     //[self sendDualCallWithOldDic:dic];
	
    [self.callphone sendCallRequestToActivationTran:trans];
}

#pragma mark - selectTransDelegate
-(void)selectTransForAXB:(NSDictionary *)axbDic{
	[self.callphone DelBindAXB:axbDic Respone:^(NSDictionary *tempJSON, NSString *model, NSString *XNum) {
		NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
		if ([successstr isEqualToString:@"1"]) {
			[MBProgressHUD showErrorMessage:@"删除成功"];
			[self.dataArray removeAllObjects];
			self.curPage = 1;
			[self SendRequestWithPage:self.curPage];
		}else{
			[MBProgressHUD showErrorMessage:tempJSON[@"message"]];
		}
	}];
}

#pragma mark -
-(void)sendDualCallWithOldDic:(NSDictionary *)oldDic{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *randomNum = [numberFormatter numberFromString:[TimeAndTimeStamps getNowDateTimeFoMillisecond]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",randomNum] forKey:VN_TRANS];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:oldDic[@"a"] forKey:@"a"];
    [dictionary setValue:oldDic[@"x"] forKey:@"x"];
    [dictionary setValue:oldDic[@"b"] forKey:@"b"];
    [dictionary setValue:[NSString stringWithFormat:@"%@",randomNum] forKey:@"t"];
    [dictionary setValue:oldDic[@"mode"] forKey:@"mode"];
//    [dictionary setValue:oldDic[@"companyid"] forKey:@"companyid"];
//    [dictionary setValue:oldDic[@"companyname"] forKey:@"companyname"];
    
    
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
    
    NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_AXB);
    NSDictionary *parameters = @{
                                 @"newItem": dictionary,
                                 @"oldItem": oldDic,
                                 @"type": @"update"
                                 } ;
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
        NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
        if ([successstr isEqualToString:@"1"]) {
            NSString * xNumStr = [NSString stringWithFormat:@"%@%@",VN_CALLPREFIX,oldDic[@"x"]];
            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel://%@",xNumStr];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
        }else{
            [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
        }
    } progress:^(NSProgress *progress) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"连接网络超时，请稍后再试",nil)];
    }];
    
}


-(CallPhone *)callphone{
	if (!_callphone) {
		_callphone = [[CallPhone alloc] init];
	}
	return _callphone;
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
