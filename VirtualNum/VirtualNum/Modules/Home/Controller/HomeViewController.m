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
#import "UIButton+TopBottom.h"
#import "NoDataView.h"
#import "PPGetAddressBook.h"
#import "CallPhone.h"
#import "CallLogDetailViewController.h"


@interface HomeViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,AFFNumericKeyboardDelegate>{
    UILabel *inputNumber;
    UIButton *callButton;
    UIButton *deleteButton;
    UIButton *downButton;
    BOOL isKeyBoard;
    UITableView *SeaResultTable;  //输入数字后出现的搜索tableview
    NSMutableArray *searchResults;
    NSMutableDictionary *contactMutableDic;//联系人字典
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
@property (nonatomic,strong)NoDataView *nodataview;

@property (nonatomic, copy) NSDictionary *contactPeopleDict;
@property (nonatomic, copy) NSArray *keys;

@end

@implementation HomeViewController

@synthesize keyboard;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"呼叫记录";
    [self creadTableView];
    
    self.tabBarController.delegate = self;
    
    [self initCompanyID];
    [self intKeyboard];
    //[self initAddressBook];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.dataArray = [[DataBase sharedDataBase] getAllCallLog];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
    isKeyBoard = YES;
}

#pragma mark - 初始化CompanyID
-(void)initCompanyID{
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

#pragma mark 初始化拔号键盘
-(void)intKeyboard{
    isKeyBoard = YES;
    
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
        make.top.equalTo(self.view).with.offset(kHEIGHT-216-49);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(216);
    }];
    
    SeaResultTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWIDTH, kHEIGHT-113)];
    SeaResultTable.delegate = self;
    SeaResultTable.dataSource = self;
    [self.view addSubview:SeaResultTable];
    [SeaResultTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
    }];
    [Common setExtraCellLineHidden:SeaResultTable];
    SeaResultTable.hidden = YES;
}

#pragma mark 初始化通讯录
-(void)initAddressBook{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake(0, 0, 80, 80);
    indicator.center = CGPointMake([UIScreen mainScreen].bounds.size.width*0.5, [UIScreen mainScreen].bounds.size.height*0.5-80);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    indicator.clipsToBounds = YES;
    indicator.layer.cornerRadius = 6;
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    //获取按联系人姓名首字拼音A~Z排序(已经对姓名的第二个字做了处理)
    [PPGetAddressBook getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        [indicator stopAnimating];
        
        //装着所有联系人的字典
        self.contactPeopleDict = addressBookDict;
        //联系人分组按拼音分组的Key值
        self.keys = nameKeys;
        DLog("keys>>>%@",self.keys);
        [self ChangeContact:self.keys ContactDic:self.contactPeopleDict];
        // [SeaResultTable reloadData];
    } authorizationFailure:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在iPhone的“设置-隐私-通讯录”选项中，允许虚拟号访问您的通讯录"
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
        [alert show];
    }];
    
    SeaResultTable.rowHeight = 60;
}

-(void)ChangeContact:(NSArray *)nameKeys ContactDic:(NSDictionary *) contactDic{
    contactMutableDic = [[NSMutableDictionary alloc] init];
    
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
    self.tableView.hidden = NO;
    
    _nodataview = [[NoDataView alloc]init ];
    [self.tableView addSubview:_nodataview];
    [_nodataview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView).with.offset(0);
        make.left.equalTo(self.tableView).with.offset(0);
        make.right.equalTo(self.tableView).with.offset(0);
        make.bottom.equalTo(self.tableView).with.offset(0);
    }];
    if (self.dataArray.count == 0) {
        self.tableView.hidden = NO;
        _nodataview.hidden = NO;
        _nodataview.showLab.center = CGPointMake(kAppDelegate.window.frame.size.width/2, 150);
        _nodataview.showLab.text = @"暂无通话记录";
    }else{
        _nodataview.hidden = YES;
        self.tableView.hidden = NO;
    }
}

- (void)chooseClick
{
    ChooseNumViewController * chooseVc = [[ChooseNumViewController alloc]init];
    [self.navigationController pushViewController:chooseVc animated:NO];
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

#pragma mark 发起呼叫call
- (void)call {
    [CallPhone sendCallRequest:inputNumber.text ContactName:@""];
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
    cell.calledNameLab.text = [NSString stringWithFormat:@"x号码: %@",callLog.XNum];
    cell.callPhoneNumLab.text = [NSString stringWithFormat:@"被叫号码: %@ (%@)",callLog.CallPhoneNum,callLog.callCount];
    cell.generateTimeLab.text = [NSString stringWithFormat:@"%@",callLog.generateTime];
    cell.xLab.text =[NSString stringWithFormat:@"%@",callLog.randomNum];
    
    return cell;
}

#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CallLog *callLog = self.dataArray[indexPath.row];
    CallLogDetailViewController * detailVc = [[CallLogDetailViewController alloc]init];
    detailVc.callLog = callLog;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - UIAlertView delegate
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


#pragma mark -
#pragma mark 键盘输入和删除
//后退键
-(void)numberKeyboardStirng:(NSString *)str {
    
    if ([str isEqualToString:@"1"]) {
        if (inputNumber.text.length !=0) {
            inputNumber.text = [inputNumber.text substringToIndex:inputNumber.text.length -1];
            
            if (inputNumber.text.length == 0) {
                inputNumber.text = nil;
                self.navigationItem.title = @"通话记录";
                [self HiddenORShow:YES];
                [self.tableView setHidden:NO];
            }else {
                [self HiddenORShow:NO];
                [self.tableView setHidden:YES];
            }
        }
    }
    
    if ([str isEqualToString:@"2"]) {
        if (inputNumber.text.length != 0)
        {
            inputNumber.text = nil;
            self.navigationItem.title = @"拨号";
            [self HiddenORShow:YES];
             [self.tableView setHidden:NO];
        }else {
            [self HiddenORShow:YES];
             [self.tableView setHidden:NO];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self seaInputNumber:inputNumber
               textDidChange:inputNumber.text];
    });
}

-(void)HiddenORShow:(BOOL)sh{
    inputNumber.hidden = sh;
    callButton.hidden = sh;
    deleteButton.hidden = sh;
    downButton.hidden = sh;
    SeaResultTable.hidden = sh;
    
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
    self.tableView.hidden = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self seaInputNumber:inputNumber
               textDidChange:inputNumber.text];
        //[SeaResultTable reloadData];
    });
}

#pragma mark  创建tabbarView
- (void)createBelowView {
    
    downButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame =CGRectMake(0, 0, self.view.bounds.size.width/4, 50);
    [downButton setImage:[UIImage imageNamed:@"tab_dial_ic_close"] withTitle:@"收起键盘" forState:UIControlStateNormal];
    [downButton setTitleColor:[UIColor colorWithHexString:@"#3F9AEE"] forState:UIControlStateNormal];
    downButton.titleLabel.font = [UIFont systemFontOfSize:11];
    downButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [downButton addTarget:self action:@selector(downKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.tabBar addSubview:downButton];
    
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
    
    [callButton addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    
    //后退删除键
    deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deleteButton.frame = [(UIButton *)self.tabBarController.tabBar.subviews[3] frame];
    [deleteButton setImage:[UIImage imageNamed:@"btn_delet"] withTitle:@"后退" forState:UIControlStateNormal];
    deleteButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.tabBarController.tabBar addSubview:deleteButton];
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [deleteButton addGestureRecognizer:singleRecognizer];
    // 双击的 Recognizer
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [deleteButton addGestureRecognizer:longPress];
}

#pragma mark 显示或收起键盘
-(void)downKeyboard:(UIButton*)sender{
    if ([sender.titleLabel.text isEqualToString:@"收起键盘"]) {
        [downButton setImage:[UIImage imageNamed:@"tab_dial_ic_open"] withTitle:@"显示键盘" forState:UIControlStateNormal];
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
        [downButton setImage:[UIImage imageNamed:@"tab_dial_ic_close"] withTitle:@"收起键盘" forState:UIControlStateNormal];
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
        // [self.tableView reloadData];
    });
}

#pragma UISearchDisplayDelegate
- (void)seaInputNumber:(UILabel *)seaInputNumber
         textDidChange:(NSString *)searchText {
    
    //    searchResults = [[NSMutableArray alloc] init];
    //
    //    if (inputNumber.text.length>0){
    //        for(NSString *phone in _contactPeopleDict) {
    //            NSString *tempPhone = [[[phone description] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    //            NSRange range = [tempPhone rangeOfString:inputNumber.text];
    //            NSInteger location = range.location;
    //            NSDictionary *temp = _contactPeopleDict[phone];
    //            if(location == 0){
    //                NSDictionary *myClassDict;
    //                myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
    //                               temp[@"name"], @"name",
    //                               phone, @"phone",
    //                               nil];
    ////                [searchResults addObject:myClassDict];
    //            }
    //        }
    //    }
    
    //    NSString *key = _keys[section];
    //    return [_contactPeopleDict[key] count];
}

#pragma mark - tabBar代理
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UITabBarItem *callItem = self.tabBarController.tabBar.items[0];
    
    if (tabBarController.selectedIndex == 0 && isKeyBoard) {
        
        tabBarController.selectedIndex = 0;
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
