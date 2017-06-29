//
//  MineViewController.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/24.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "MineViewController.h"
#import "ChooseNumViewController.h"

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
    
    self.dataArray = @[@"设置一", @"设置二", @"设置三", @"设置四"];
    
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



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num;
    switch (section) {
        case 0:
            num = 3;
            break;
        case 1:
            num = 1;
            break;
            break;
        default:
            num = self.dataArray.count;
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
            labelTitle.text =@"section";
            break;
        case 2:
            labelTitle.text =@"section";
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
    static NSString *identity3 = @"cell3";
    static NSString *identity4 = @"cell4";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:identity2];
    UITableViewCell *cell4 = [tableView dequeueReusableCellWithIdentifier:identity4];
    
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
                    NSString * companyIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:companyid];
                    if (!companyIDStr) {
                        companyIDStr = @"--";
                    }
                    cell.detailTextLabel.text =companyIDStr;
                }
                    break;
                default:
                {
                    cell.textLabel.text =@"X号码";
                    NSString * xNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:X];
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
            cell2.textLabel.text = @"修改号码";
            NSString * phoneNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:phone];
            if (!phoneNumStr) {
                phoneNumStr = @"--";
            }
            cell2.detailTextLabel.text = phoneNumStr;
        }
            break;
        default :
        {
            if (cell4 == nil) {
                cell4 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity3];
                //cell4.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell4.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell4.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
        }
            break;
    }
    
    switch (indexPath.section) {
        case 0:
            return cell;
            break;
        case 1:
            return cell2;
            break;
        default:
            return cell4;
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
                  ChooseNumViewController * chooseVc = [[ChooseNumViewController alloc]init];
                [self.navigationController pushViewController:chooseVc animated:NO];
        }
            break;
        default:{
            
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
