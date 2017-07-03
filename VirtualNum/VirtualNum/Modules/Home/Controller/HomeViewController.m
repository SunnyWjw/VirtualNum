//
//  HomeViewController.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/24.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "HomeViewController.h"
#import "ChooseNumViewController.h"
#import "HWPopTool.h"
#import "DataBase.h"
#import "CallLog.h"
#import "CalllogCell.h"


@interface HomeViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *popBtn;
@property (strong, nonatomic) UITextField *idTF;
@property (strong, nonatomic) UILabel *promptLab;

/**
 *  数据源
 */
@property(nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"呼叫记录";
    [self creadTableView];
    
    __block HomeViewController/*主控制器*/ *weakSelf = self;
    NSString *companyidStr =[[NSUserDefaults standardUserDefaults] objectForKey:VN_COMPANYID];
    if (!companyidStr) {
        [weakSelf popViewShow];
    }
    else{
        NSString *xStr =[[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
        if (!xStr) {
            [self judgeAX];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.dataArray = [[DataBase sharedDataBase] getAllCallLog];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}


- (void)popViewShow {
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    _contentView.center = CGPointMake(self.view.bounds.size.width/2-5, 50);
    _contentView.layer.borderColor =  BorderColor;
    _contentView.layer.borderWidth = 0.5;
    _contentView.layer.cornerRadius = 10.0;
    _contentView.clipsToBounds = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    
    //    看看pop效果把下面这一句加上
    //[_contentView addSubview:_popBtn];
    
    _idTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 20, _contentView.frame.size.width-20, 40)];
    _idTF.placeholder = @"请输入您的CompanyID";
    _idTF.delegate = self;
    _idTF.layer.borderColor =  BorderColor;
    _idTF.layer.borderWidth = 0.5;
    _idTF.layer.cornerRadius = 3.0;
    _idTF.clipsToBounds = YES;
    [_contentView addSubview:_idTF];
    
    _promptLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, _contentView.frame.size.width-20, 20)];
    _promptLab.font= [UIFont systemFontOfSize:12.0];
    _promptLab.textColor = [UIColor redColor];
    [_contentView addSubview:_promptLab];
    
    //    UIButton * cancelBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    //    cancelBtn.frame =CGRectMake(10, 90, 80, 40);
    //    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    //    cancelBtn.backgroundColor= CNavBgColor;
    //    [cancelBtn addTarget:self action:@selector(closeAndBack) forControlEvents:UIControlEventTouchUpInside];
    //    [_contentView addSubview:cancelBtn];
    
    UIButton * sureBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame =CGRectMake(10, 90, 180, 40);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.backgroundColor= CNavBgColor;
    [sureBtn addTarget:self action:@selector(sureAndBack) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:sureBtn];
    
    
    [[HWPopTool sharedInstance] setTapOutsideToDismiss:NO];
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
    [[HWPopTool sharedInstance] showWithPresentView:_contentView animated:YES];
    
}

- (void)closeAndBack {
    [[HWPopTool sharedInstance] closeWithBlcok:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    NSString *xStr =[[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
    if (!xStr) {
        [self judgeAX];
    }
}
-(void)sureAndBack{
    
    self.idTF.text = [self.idTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // 判断用户名
    if ([self.idTF.text length] == 0)
    {
        _promptLab.text =@"请输入您的CompanyID";
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.idTF.text forKey:VN_COMPANYID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self closeAndBack];
}

-(void)judgeAX{
    NSString *axStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"AX"];
    if (axStr) {
        DLog(@"已经绑定号码");
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您暂未选择号码，请选择号码进入绑定!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag=1001;
        [alertView show];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identity = @"detail" ;
    CalllogCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];

    if (cell == nil)
    {
        cell = [[CalllogCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    
    CallLog *callLog = self.dataArray[indexPath.row];
    cell.calledNameLab.text = callLog.calledName;
    cell.callPhoneNumLab.text = callLog.CallPhoneNum;
    cell.generateTimeLab.text = callLog.generateTime;
    
    return cell;
}

#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -
#pragma mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == 1001)
        {
            ChooseNumViewController * chooseVc = [[ChooseNumViewController alloc]init];
            [self.navigationController pushViewController:chooseVc animated:NO];
        }
    }
}


-(void)creadTableView{
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
    }];
    [Common setExtraCellLineHidden:self.tableView];
}

- (void)chooseClick
{
    ChooseNumViewController * chooseVc = [[ChooseNumViewController alloc]init];
    [self.navigationController pushViewController:chooseVc animated:NO];
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
