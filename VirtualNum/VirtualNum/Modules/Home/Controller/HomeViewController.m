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


@interface HomeViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,AFFNumericKeyboardDelegate>{
    UILabel *inputNumber;
    UIButton *callButton;
    UIButton *deleteButton;
    UIButton *downButton;
    BOOL isKeyBoard;
}

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

@synthesize keyboard;

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
    //     [self judgeAX];
    [self intKeyboard];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.dataArray = [[DataBase sharedDataBase] getAllCallLog];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}


-(void)intKeyboard{
    inputNumber = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, kWIDTH-100, 44)];
    inputNumber.frame = CGRectMake(50, 0, kWIDTH-100, 44);
    inputNumber.textAlignment = NSTextAlignmentCenter;
    inputNumber.textColor = [UIColor whiteColor];
    inputNumber.font = [UIFont systemFontOfSize:34.0f];
    inputNumber.adjustsFontSizeToFitWidth = YES;
    inputNumber.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:inputNumber];
    inputNumber.hidden = YES;
    
    keyboard = [[AFFNumericKeyboard alloc]init];
    keyboard.delegate = self;
    [self.view addSubview:keyboard];
    [keyboard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kHEIGHT-216-50);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(216);
    }];
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

#pragma mark -
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

#pragma mark -
#pragma mark -
#pragma mark 键盘输入和删除
//后退键
-(void)numberKeyboardStirng:(NSString *)str {
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    if ([str isEqualToString:@"1"]) {
        if (inputNumber.text.length !=0) {
            inputNumber.text = [inputNumber.text substringToIndex:inputNumber.text.length -1];
            
            if (inputNumber.text.length == 0) {
                inputNumber.text = nil;
                self.navigationItem.title = @"通话记录";
                
                inputNumber.hidden = YES;
                callButton.hidden = YES;
                downButton.hidden = YES;
                deleteButton.hidden = YES;
                
            }else {
                self.navigationItem.hidesBackButton = YES;
                inputNumber.hidden = NO;
                callButton.hidden = NO;
                deleteButton.hidden = NO;
                downButton.hidden = NO;
            }
        }
    }
    
    if ([str isEqualToString:@"2"]) {
        if (inputNumber.text.length != 0)
        {
            inputNumber.text = nil;
            inputNumber.hidden = YES;
            self.navigationItem.title = @"拨号";
            
            callButton.hidden = YES;
            deleteButton.hidden = YES;
            downButton.hidden = YES;
            
            inputNumber.hidden = YES;
            callButton.hidden = YES;
            deleteButton.hidden = YES;
            downButton.hidden = YES;
            
        }else {
            self.navigationItem.hidesBackButton = YES;
            
            inputNumber.hidden = YES;
            callButton.hidden = YES;
            downButton.hidden = YES;
            
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self seaInputNumber:inputNumber
               textDidChange:inputNumber.text];
    });
}
#pragma mark 键盘输入
///输入数字
-(void)numberKeyboardInput:(NSString*)number {
    //    NSLog(@"number=== %@",number);
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    if (inputNumber.text == nil && inputNumber.hidden) {
        self.navigationItem.title = nil;
        inputNumber.hidden = NO;
        inputNumber.text = number;
        [self createBelowView];
    }else {
        inputNumber.text = [inputNumber.text stringByAppendingString:number];
    }
    //    NSLog(@"inputNumber.text===%@",inputNumber.text);
    self.tableView.hidden = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self seaInputNumber:inputNumber
               textDidChange:inputNumber.text];
        //[SeaResultTable reloadData];
    });
}

#pragma mark  创建tabbarView
- (void)createBelowView {
    //后退删除键
    deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deleteButton.frame = [(UIButton *)self.tabBarController.tabBar.subviews[3] frame];
    [deleteButton setImage:[UIImage imageNamed:@"btn_delet"] forState:UIControlStateNormal];
    [deleteButton setTitle:@"后退" forState:UIControlStateNormal];
    deleteButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.tabBarController.tabBar addSubview:deleteButton];
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    //给rightCallButton添加一个手势监测；
    [deleteButton addGestureRecognizer:singleRecognizer];
    // 双击的 Recognizer
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    //关键语句，给rightCallButton添加一个手势监测；
    [deleteButton addGestureRecognizer:longPress];
    
    downButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame =CGRectMake(0, 0, self.view.bounds.size.width/4, 50);
    [downButton setImage:[UIImage imageNamed:@"tab_dial_ic_close"] forState:UIControlStateNormal];
    [downButton setTitle:@"收起键盘" forState:UIControlStateNormal];
    
    [downButton setTitleColor:[UIColor colorWithHexString:@"#3F9AEE"] forState:UIControlStateNormal];
    downButton.titleLabel.font = [UIFont systemFontOfSize:11];
    downButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [downButton addTarget:self action:@selector(downKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.tabBar addSubview:downButton];
    
    //    CGRect tempFrameOne = [(UIButton *)self.tabBarController.tabBar.subviews[0] frame];
    
    //呼叫键
    callButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect tempFrame = [(UIButton *)self.tabBarController.tabBar.subviews[1] frame];
    CGRect tempFrameSec = [(UIButton *)self.tabBarController.tabBar.subviews[2] frame];
    callButton.frame = CGRectMake(self.view.bounds.size.width/4, 0, tempFrame.size.width+tempFrameSec.size.width+6, 50);
    [callButton setTitle:@"发起呼叫" forState:UIControlStateNormal];
    [callButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    callButton.backgroundColor = [UIColor colorWithRed:73/255.0 green:199/255.0 blue:127/255.0 alpha:1];
    [callButton.layer setMasksToBounds:YES];
    [callButton.layer setCornerRadius:10.0f];
    [self.tabBarController.tabBar addSubview:callButton];
    
    // [callButton addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 显示或收起键盘
-(void)downKeyboard:(UIButton*)sender{
    if ([sender.titleLabel.text isEqualToString:@"收起键盘"]) {
        [downButton setImage:[UIImage imageNamed:@"tab_dial_ic_open"] forState:UIControlStateNormal];
        [downButton setTitle:@"显示键盘" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [keyboard mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(kHEIGHT);
                make.left.equalTo(self.view).with.offset(0);
                make.right.equalTo(self.view).with.offset(0);
                make.height.mas_equalTo(216);
            }];
        } completion:^(BOOL finished) {
            self.keyboard.hidden = YES;
        }];
    }else{
        
        [downButton setImage:[UIImage imageNamed:@"tab_dial_ic_close"] forState:UIControlStateNormal];
        [downButton setTitle:@"收起键盘" forState:UIControlStateNormal];
        self.keyboard.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            [keyboard mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(kHEIGHT-265);
                make.left.equalTo(self.view).with.offset(0);
                make.right.equalTo(self.view).with.offset(0);
                make.height.mas_equalTo(216);
            }];
        }];
    }
    [sender setTitleColor:[UIColor colorWithHexString:@"#3F9AEE"] forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:11];
}
#pragma mark 点击后退删除一个字符
- (void)singleTap:(UITapGestureRecognizer*)recognizer
{
    [self numberKeyboardStirng:@"1"];
}
#pragma mark 点击后退删除全部字符
- (void)longPress:(UILongPressGestureRecognizer*)recognizer
{
    [self numberKeyboardStirng:@"2"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self seaInputNumber:inputNumber
               textDidChange:inputNumber.text];
        //[SeaResultTable reloadData];
    });
}

#pragma UISearchDisplayDelegate
- (void)seaInputNumber:(UILabel *)seaInputNumber
         textDidChange:(NSString *)searchText {
    
}

#pragma mark - tabBar代理
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UITabBarItem *callItem = self.tabBarController.tabBar.items[1];
    
    if (tabBarController.selectedIndex == 1 && isKeyBoard) {
        
        tabBarController.selectedIndex = 1;
        if (self.keyboard.hidden) {
            UIImage* imageSelected = [UIImage imageNamed:@"tab_dial_ic_close"];
            callItem.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            callItem.title = @"收起键盘";
            self.keyboard.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.keyboard.frame = CGRectMake(0, kHEIGHT-265, kWIDTH, 216);}];
            
        } else {
            
            UIImage* imageSelected = [UIImage imageNamed:@"tab_dial_ic_open"];
            callItem.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            callItem.title = @"显示键盘";
            [UIView animateWithDuration:0.3 animations:^{
                self.keyboard.frame = CGRectMake(0, kHEIGHT, kWIDTH, 216);
            } completion:^(BOOL finished) {
                self.keyboard.hidden = YES;
            }];
        }
    }else{
        isKeyBoard = NO;
        callItem.title = @"通话记录";
    }
    //    } else if (tabBarController.selectedIndex == 2 || tabBarController.selectedIndex == 3) {
    //        isKeyBoard = NO;
    //        callItem.title = @"通话记录";
    //    }
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
