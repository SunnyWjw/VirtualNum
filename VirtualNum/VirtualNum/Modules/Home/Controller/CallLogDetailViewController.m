//
//  CallLogDetailViewController.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/9.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "CallLogDetailViewController.h"
#import "DataBase.h"
#import "CalllogDetailCell.h"
#import "ContactCell.h"
#import "UIImage+EditImage.h"
#import "CallPhone.h"
#import "ChooseTransidViewController.h"


@interface CallLogDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray * dataArray;
@property (nonatomic,strong) UITableView *detailTable;

@end

@implementation CallLogDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"通话详情";
    _dataArray = [[NSArray alloc] init];
    [self creadTableView];
    self.dataArray = [[DataBase sharedDataBase] queryAllCallLog:_callLog.CallPhoneNum XNum:[NSString stringWithFormat:@"%@", _callLog.generatorPersonnel] TopNumber:@""];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)creadTableView{
    self.detailTable = [[UITableView alloc]init];
    self.detailTable.delegate = self;
    self.detailTable.dataSource = self;
    [self.view addSubview:self.detailTable];
    [self.detailTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
    }];
    
    [Common setExtraCellLineHidden:self.detailTable];
}

#pragma mark -允许数据源告知必须加载到Table View中的表的Section数。
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma mark -设置表格的行数为数组的元素个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 1;
            break;
            
        default:
            return _dataArray.count;
            break;
    }
}


// 设置section的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 60;
            break;
            
        default:
            return 65;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellIdentifier = @"ContactCell";
            ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                NSArray *cellBundleAry = [[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil];
                cell = [cellBundleAry lastObject];
            }
            switch (indexPath.row) {
                case 0:
                {
                    cell.leftLabel.text = [NSString stringWithFormat:@"%@ %@",_callLog.calledName,_callLog.CallPhoneNum];
                    [cell.callButton setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
                }
                    break;
            }
            return cell;
        }
            break;
            
        default:
        {
            static NSString *cellIdentifier = @"CalllogDetailCell";
            CalllogDetailCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell2 == nil) {
                NSArray *cellBundleAry = [[NSBundle mainBundle] loadNibNamed:@"CalllogDetailCell" owner:self options:nil];
                cell2 = [cellBundleAry lastObject];
            }
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            
            CallLog *detailCallLog = self.dataArray[indexPath.row];
            cell2.leftTopLabel.text =[NSString stringWithFormat:@"呼出 %@",detailCallLog.generateTime];
            NSString *strDurationTime = @"0";
            if (detailCallLog.durationTime.length > 0) {
                strDurationTime = detailCallLog.durationTime;
            }
            cell2.rightTopLabel.text = [NSString stringWithFormat:@"%@秒",strDurationTime];
            NSString *mode = [detailCallLog.serviceType isEqual:@"0" ] ? @"租车模式-dual" : @"中介模式-single";
            cell2.leftBottomLabel.text = [NSString stringWithFormat:@"%@",mode];
            cell2.rightBottomLabel.text = [NSString stringWithFormat:@"%@",detailCallLog.randomNum];
            
            
            return cell2;
        }
            
            break;
    }
}

#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
        
            CallPhone *callphone = [[CallPhone alloc] init];
            [callphone sendCallRequest:_callLog.CallPhoneNum ContactName:_callLog.calledName Respone:^(NSDictionary *tempJSON, NSString *model, NSString *XNum) {
                NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
                if ([successstr isEqualToString:@"1"]) {
                    if ([model isEqualToString:@"dual"]) {
                        
                        ChooseTransidViewController *ctVC = [[ChooseTransidViewController alloc] init];
                        [self.navigationController pushViewController:ctVC animated:NO];
                        /*
                        [callphone sendCallRequestToActivationTran];
                         */
                    }else{
                        XNum = [NSString stringWithFormat:@"%@%@",VN_CALLPREFIX,XNum];
                        NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel://%@",XNum];
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
                    }
                }else{
                    [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
                }
            }];
        }
    }
}


-(void)SendRequestToCall{
    NSString *strX = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *randomNum = [numberFormatter numberFromString:[TimeAndTimeStamps getNowDateTimeFoMillisecond]];
    NSString *strCompany = [[NSUserDefaults standardUserDefaults] objectForKey:VN_COMPANYID];
    
    NSString * strTransid =[NSString stringWithFormat:@"%@%@",strCompany,randomNum] ;
    [[NSUserDefaults standardUserDefaults] setObject:strTransid forKey:VN_TRANS];
    
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
                                 @"transid":strTransid
                                 } ;
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
