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

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray * dataArray;
@property (nonatomic,strong) UITableView *personalTableView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"个人中心";
    [self creadTableView];
    
    //self.dataArray = @[@"设置一", @"设置二", @"设置三", @"设置四"];
    
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
    
    [self setExtraCellLineHidden:self.personalTableView];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    switch (section) {
        case 0:
            num = 3;
            break;
        case 1:
            num = 3;
            break;
    }
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
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
            labelTitle.text = @"个人资料";
            break;
        case 1:
            labelTitle.text =@"设置";
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
                    cell.textLabel.text =@"权限";
                    NSString * companyNmaeStr = [[NSUserDefaults standardUserDefaults] objectForKey:permissions];
                    if (!companyNmaeStr) {
                        companyNmaeStr = @"--";
                    }
                    cell.detailTextLabel.text =companyNmaeStr;
                }
                    break;
                case 1:
                {
                    cell.textLabel.text =@"企业ID";
                    NSString * companyIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_COMPANYID];
                    if (!companyIDStr) {
                        companyIDStr = @"--";
                    }
                    cell.detailTextLabel.text =companyIDStr;
                }
                    break;
                default:
                {
                    cell.textLabel.text =@"X号码";
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
                    cell2.textLabel.text = @"绑定X号码";
                    NSString * phoneNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
                    if (!phoneNumStr) {
                        phoneNumStr = @"--";
                    }
                    cell2.detailTextLabel.text = phoneNumStr;
                }
                    break;
                case 1:
                {
                    cell2.textLabel.text = @"修改手机号码";
                    NSString * phoneNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_PHONE];
                    if (!phoneNumStr) {
                        phoneNumStr = @"--";
                    }
                    cell2.detailTextLabel.text = phoneNumStr;
                }
                    break;
                default:
                    cell2.textLabel.text = @"服务模式";
                    
                    NSString *callSettingsType = [[NSUserDefaults standardUserDefaults] objectForKey:VN_SERVICE];
                    NSString *callType=@"";
                    if([callSettingsType isEqualToString:@"0"]){
                        callType=@"租车模式";
                    }else{
                        callType=@"中介模式";
                    }
                    cell2.detailTextLabel.text = callType;
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
                    NSString * xNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
                    if (!xNumStr) {
                        
                        ChooseNumViewController * chooseVc = [[ChooseNumViewController alloc]init];
                        [self.navigationController pushViewController:chooseVc animated:NO];
                    }else{
                        [MBProgressHUD showErrorMessage:@"已绑定号码，不可修改"];
                        return;
                    }
                }
                    break;
                case 1:
                {
                    BindPhoneViewController * bindVc = [[BindPhoneViewController alloc]init];
                    bindVc.bindTitle =@"修改手机号码";
                    bindVc.bindType = @"0";
                    [self.navigationController pushViewController:bindVc animated:NO];
                }
                    break;
                default:
                {
                    ChooseServiceViewController * chooseVc = [[ChooseServiceViewController alloc]init];
                    [self.navigationController pushViewController:chooseVc animated:NO];
                }
                    break;
            }
        }
            break;
    }
    
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
