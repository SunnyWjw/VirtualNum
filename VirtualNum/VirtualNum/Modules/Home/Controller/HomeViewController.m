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
#import "ChooseTransidViewController.h"
#import "BindPhoneViewController.h"
#import "SWNumericKeyboard.h"


@interface HomeViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,SYNumericKeyboardDelegate>{
    UIButton *callButton;
    UIButton *deleteButton;
    UIButton *downButton;
    BOOL isKeyBoard;
//    UITableView *SeaResultTable;  //输入数字后出现的搜索tableview
    NSMutableArray *searchResults;
    NSMutableDictionary *contactMutableDic;//联系人字典
}
@property (nonatomic, strong) SWNumericKeyboard *keyboard;
@property (nonatomic, strong) UILabel *inputNumber;
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

#define SWNumericKeyboardHEIGHT 270

@implementation HomeViewController

@synthesize keyboard;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"通话记录",nil);
    self.tabBarController.delegate = self;
    
    //自动登录
    [userManager autoLoginToServer:^(BOOL success, NSString *des) {
        if (success) {
            [self creadTableView];
            NSString *phoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_PHONE];
            if (phoneStr) {
                [self judgeAX];
            }
            [self intKeyboard];
            [self initAddressBook];
        }else{
            [MBProgressHUD showErrorMessage:NSStringFormat(@"自动登录失败：%@",des)];
            KPostNotification(KNotificationLoginStateChange, @NO)
            return ;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self BindPhone];
	if (self.dataArray.count == 0) {
		  self.dataArray = [[DataBase sharedDataBase] getAllCallLog];
	}
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
    isKeyBoard = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSString *callSettingsType = [[NSUserDefaults standardUserDefaults] objectForKey:VN_SERVICE];
    if ([callSettingsType isEqualToString: @"0"]) {
        self.inputNumber.text = @"";
        self.navigationItem.title = NSLocalizedString(@"通话记录",nil);
//        [self HiddenORShow:YES];
        [self.tableView setHidden:NO];
        
    }
    keyboard.hidden = YES;
}

-(void)initTransID{
    ChooseTransidViewController *ctVC = [[ChooseTransidViewController alloc] init];
    [self.navigationController pushViewController:ctVC animated:NO];
}

#pragma mark 初始化拔号键盘
-(void)intKeyboard{
	isKeyBoard = YES;
//	self.inputNumber = [[UILabel alloc] init];
//	self.inputNumber.frame = CGRectMake(50, 0, kWIDTH-100, 44);
//	self.inputNumber.textAlignment = NSTextAlignmentCenter;
//	self.inputNumber.textColor = [UIColor whiteColor];
//	self.inputNumber.font = [UIFont systemFontOfSize:34.0f];
//	self.inputNumber.adjustsFontSizeToFitWidth = YES;
//	self.inputNumber.text = @"";
//	[self.navigationController.navigationBar addSubview:self.inputNumber];
	
	self.keyboard = [[SWNumericKeyboard alloc] initWithFrame:CGRectMake(0, kHEIGHT-SWNumericKeyboardHEIGHT-SafeAreaTabbarHeight, kWIDTH, SWNumericKeyboardHEIGHT)];
	self.keyboard.delegate = self;
	[self.view addSubview:self.keyboard];
}

-(UILabel *)inputNumber{
	if (!_inputNumber) {
		_inputNumber = [[UILabel alloc] init];
		_inputNumber.frame = CGRectMake(50, 0, kWIDTH-100, 44);
		_inputNumber.textAlignment = NSTextAlignmentCenter;
		_inputNumber.textColor = [UIColor whiteColor];
		_inputNumber.font = [UIFont systemFontOfSize:34.0f];
		_inputNumber.adjustsFontSizeToFitWidth = YES;
		_inputNumber.text = @"";
		[self.navigationController.navigationBar addSubview:_inputNumber];
	}
	return _inputNumber;
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
        [self ChangeContact:self.keys ContactDic:self.contactPeopleDict];
    } authorizationFailure:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil)
                                                        message:NSLocalizedString(@"请在iPhone的“设置-隐私-通讯录”选项中，允许虚拟号访问您的通讯录",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"知道了",nil)
                                              otherButtonTitles:nil];
        [alert show];
    }];
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
    _idTF.placeholder = NSLocalizedString(@"请输入您的CompanyID",nil);
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
    [sureBtn setTitle:NSLocalizedString(@"确定",nil) forState:UIControlStateNormal];
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
        _nodataview.showLab.text = NSLocalizedString(@"暂无通话记录",nil);
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
        [self.navigationController popViewControllerAnimated:NO];
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
        _promptLab.text = NSLocalizedString(@"请输入您的CompanyID",nil);
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.idTF.text forKey:VN_COMPANYID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self closeAndBack];
}

-(void)judgeAX{
    NSString *axStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
    if (axStr) {
        DLog(@"已经绑定号码");
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"温馨提示",nil) message:NSLocalizedString(@"您暂未选择号码，请选择号码进入绑定!",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"确定",nil), nil];
        alertView.tag=1001;
        [alertView show];
    }
}


/**
  判断是否绑定手机号码
 */
- (void) BindPhone {
    NSString *phoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_PHONE];
    if (phoneStr) {
        DLog(@"已经绑定号码");
    }else{
        BindPhoneViewController * BindVc = [[BindPhoneViewController alloc]init];
        [self.navigationController pushViewController:BindVc animated:NO];
    }
}

#pragma mark 发起呼叫call
- (void)call {
    
    CallPhone *callphone = [[CallPhone alloc] init];
    [callphone sendCallRequest:self.inputNumber.text ContactName:@"" Respone:^(NSDictionary *tempJSON, NSString *model, NSString *XNum) {
        NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
        if ([successstr isEqualToString:@"1"]) {
            if ([model isEqualToString:@"dual"]) {
                ChooseTransidViewController *ctVC = [[ChooseTransidViewController alloc] init];
                [self.navigationController pushViewController:ctVC animated:NO];
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
    cell.calledNameLab.text = [NSString stringWithFormat:@"x%@: %@",NSLocalizedString(@"号码",nil),callLog.XNum];
    cell.callPhoneNumLab.text = [NSString stringWithFormat:@"%@: %@ (%@)",NSLocalizedString(@"被叫号码",nil),callLog.CallPhoneNum,callLog.callCount];
    cell.generateTimeLab.text = [NSString stringWithFormat:@"%@",callLog.randomNum];
    cell.xLab.text =[NSString stringWithFormat:@"%@",callLog.generateTime];
    
    return cell;
}

#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CallLog *callLog = self.dataArray[indexPath.row];
    CallLogDetailViewController * detailVc = [[CallLogDetailViewController alloc]init];
    detailVc.callLog = callLog;
    [self.navigationController pushViewController:detailVc animated:NO];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == 1001)
        {
			//选择X号码
            ChooseNumViewController * chooseVc = [[ChooseNumViewController alloc]init];
            [self.navigationController pushViewController:chooseVc animated:NO];
            return;
        }
        if (alertView.tag == 1002)
        {
            BindPhoneViewController * BindVc = [[BindPhoneViewController alloc]init];
            [self.navigationController pushViewController:BindVc animated:NO];
            return;
        }
    }
}


#pragma mark -

#pragma mark - SWNumericKeyboard代理
//获取键盘输入的内容
- (void) numberKeyboardInput:(NSString*)number{
//	self.inputNumber.hidden = NO;
	self.navigationItem.title = @"";
	self.inputNumber.text = [self.inputNumber.text stringByAppendingString:number];
	
}
//点击了删除按钮
- (void) numberKeyboardDelete:(NSString*) number{
	if([number isEqualToString:@"1"]){
		//删除单个字符
		if (self.inputNumber.text.length !=0) {
			self.inputNumber.text = [self.inputNumber.text substringToIndex:self.inputNumber.text.length -1];
		}
	}else{
		//删除全部字符
		self.inputNumber.text = @"";
	}
}
- (void) BeginCallPhone{
	[self call];
}
-(void)GoSettingModule{
//	  [MBProgressHUD showErrorMessage:NSStringFormat(NSLocalizedString(@"该功能暂未开放",nil))];
	[self test];
}

-(void)test{
	NSString *xNumStr = [[NSUserDefaults standardUserDefaults] objectForKey:VN_X];
	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:VN_TOKEN];
	NSString *oldTrans = @"110120181207170736885";//[[NSUserDefaults standardUserDefaults] objectForKey:VN_OLDTRANS];
	
	NSDictionary *headerDic = @{
								@"token":token,
								@"version":VN_APIVERSION
								};
	
	NSString *baseUrl = NSStringFormat(@"%@%@",URL_main,URL_TRANSACTION);
	NSDictionary *parameters = @{
								 @"x": xNumStr,
								 @"transid":oldTrans
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
		DLog(@"解绑Trans__tempJSON>>>%@",tempJSON);
		NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
		if ([successstr isEqualToString:@"1"]) {
			[MBProgressHUD showTopTipMessage:@"解绑Trans：%@成功" isWindow:YES];
//			if ([[tempJSON objectForKey:@"data"] isKindOfClass:[NSArray class]])
//			{
//				[self RequestToActivationTran:transid];
//			}else{
//				[self RequestToActivationTran:transid];
//			}
		}else{
			[MBProgressHUD showTopTipMessage:tempJSON[@"message"] isWindow:YES];
//			[self RequestToActivationTran:transid];
			//            [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
			//			return;
		}
	} progress:^(NSProgress *progress) {
		
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		[MBProgressHUD hideHUD];
		[MBProgressHUD showErrorMessage:NSLocalizedString(@"连接网络超时，请稍后再试",nil)];
	}];
	
}



/*
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
                //                [self.tableView setHidden:YES];
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
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self seaInputNumber:inputNumber
    //               textDidChange:inputNumber.text];
    //    });
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
 */

#pragma mark - 显示或收起键盘
-(void)downKeyboard:(UIButton*)sender{
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"收起键盘",nil)]) {
        [downButton setImage:[UIImage imageNamed:@"tab_dial_ic_open"] withTitle:NSLocalizedString(@"显示键盘",nil) forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            [keyboard mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(kHEIGHT);
                make.left.equalTo(self.view).with.offset(0);
                make.right.equalTo(self.view).with.offset(0);
                make.height.mas_equalTo(SWNumericKeyboardHEIGHT);
            }];
        } completion:^(BOOL finished) {
            self.keyboard.hidden = YES;
        }];
    }else{
        [downButton setImage:[UIImage imageNamed:@"tab_dial_ic_close"] withTitle:NSLocalizedString(@"收起键盘",nil) forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.3 animations:^{
            [keyboard mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).with.offset(kHEIGHT-265);
                make.left.equalTo(self.view).with.offset(0);
                make.right.equalTo(self.view).with.offset(0);
                make.height.mas_equalTo(SWNumericKeyboardHEIGHT);
            }];
        } completion:^(BOOL finished) {
            self.keyboard.hidden = NO;
        }];
    }
    [sender setTitleColor:[UIColor colorWithHexString:@"#3F9AEE"] forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:11];
}

#pragma UISearchDisplayDelegate
- (void)seaInputNumber:(UILabel *)seaInputNumber
         textDidChange:(NSString *)searchText {
    
        searchResults = [[NSMutableArray alloc] init];
	
        if (seaInputNumber.text.length>0){
            for(NSString *phone in _contactPeopleDict) {
                NSString *tempPhone = [[[phone description] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSRange range = [tempPhone rangeOfString:seaInputNumber.text];
                NSInteger location = range.location;
                NSDictionary *temp = _contactPeopleDict[phone];
                if(location == 0){
                    NSDictionary *myClassDict;
                    myClassDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   temp[@"name"], @"name",
                                   phone, @"phone",
                                   nil];
                }
            }
        }
}

#pragma mark - tabBar代理
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UITabBarItem *callItem = self.tabBarController.tabBar.items[0];
    
    if (tabBarController.selectedIndex == 0 && isKeyBoard) {
//		self.inputNumber.hidden = NO;
        tabBarController.selectedIndex = 0;
        if (self.keyboard.hidden) {
            UIImage* imageSelected = [UIImage imageNamed:@"tab_dial_ic_close"];
            callItem.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            callItem.title = NSLocalizedString(@"收起键盘",nil);
            self.keyboard.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.keyboard.frame = CGRectMake(0, kHEIGHT-SWNumericKeyboardHEIGHT-SafeAreaTabbarHeight, kWIDTH, SWNumericKeyboardHEIGHT);}];
            
        } else {
            
            UIImage* imageSelected = [UIImage imageNamed:@"tab_dial_ic_open"];
            callItem.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            callItem.title = NSLocalizedString(@"显示键盘",nil);
            
            [UIView animateWithDuration:0.3 animations:^{
                self.keyboard.frame = CGRectMake(0, kHEIGHT, kWIDTH, SWNumericKeyboardHEIGHT);
            } completion:^(BOOL finished) {
                self.keyboard.hidden = YES;
            }];
        }
    }else{
        isKeyBoard = NO;
        callItem.title = NSLocalizedString(@"通话记录",nil);
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
   
