//
//  LoginViewController.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/24.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "LoginViewController.h"
#import "QCheckBox.h"
#import "MyMd5.h"

@interface LoginViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property(strong,nonatomic) UITextField *userNameTf;
@property(strong,nonatomic) UITextField *passwordTf;
@property(strong,nonatomic) UITextField *companyTf;
@property(strong,nonatomic) QCheckBox *recordPswBox;
@property(strong,nonatomic) QCheckBox *autoLoginBox;


@end

#define ImgTop 84
#define ImgLandR 20
#define TFLandR 5
#define Width 45


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"登录",nil);
    
    kWeakSelf(self);
	
	/*
    YYLabel *skipBtn = [[YYLabel alloc] initWithFrame:CGRectMake(0, 400, 150, 60)];
    skipBtn.text = @"跳过登录";
    skipBtn.font = SYSTEMFONT(20);
    skipBtn.textColor = KBlueColor;
    skipBtn.backgroundColor = KClearColor;
    skipBtn.textAlignment = NSTextAlignmentCenter;
    skipBtn.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    skipBtn.centerX = KScreenWidth/2;
    
    skipBtn.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //        [MBProgressHUD showTopTipMessage:NSStringFormat(@"%@马上开始",str) isWindow:YES];
        
        [weakself skipAction];
    };
    [self.view addSubview:skipBtn];
	 */
    
    [self createLoginView];
}

- (void)createLoginView
{
    //regBtn 注册
    UIImageView *userImgView = [[UIImageView alloc]init];
    [self.view addSubview:userImgView];
    [userImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(ImgLandR);
        make.right.equalTo(self.view).with.offset(-ImgLandR);
        make.top.equalTo(self.view).with.offset(kTopHeight+20);
        make.height.mas_equalTo(Width);
    }];
    userImgView.image = [UIImage imageNamed:@"username0"];
    userImgView.layer.borderColor =  BorderColor;
    userImgView.layer.borderWidth = 0.5;
    userImgView.layer.cornerRadius = 3.0;
    userImgView.clipsToBounds = YES;
    userImgView.userInteractionEnabled = YES;
    [self.view addSubview:userImgView];
    
    self.userNameTf = [[UITextField alloc]init];
    [userImgView addSubview:self.userNameTf];
    self.userNameTf.placeholder = NSLocalizedString(@"请输入用户名",nil);
    self.userNameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTf.tag = 500;
    self.userNameTf.delegate = self;
    self.userNameTf.font = [UIFont systemFontOfSize:16.0];
	self.userNameTf.text = @"admin";
    
    [self.userNameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userImgView).with.offset(Width);
        make.right.equalTo(userImgView).with.offset(-TFLandR);
        make.top.equalTo(userImgView).with.offset(TFLandR);
        make.bottom.equalTo(userImgView).with.offset(-TFLandR);
    }];
    
    
    UIImageView *pswImgView = [[UIImageView alloc]init];
    pswImgView.image = [UIImage imageNamed:@"password0"];
    pswImgView.layer.borderColor = BorderColor;
    pswImgView.layer.borderWidth = 0.5;
    //pswImgView.layer.cornerRadius = 3.0;
    pswImgView.clipsToBounds = YES;
    pswImgView.userInteractionEnabled = YES;
    [self.view addSubview:pswImgView];
    [pswImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userImgView.mas_bottom).with.offset(ImgLandR);
        make.left.equalTo(self.view).with.offset(ImgLandR);
        make.right.equalTo(self.view).with.offset(-ImgLandR);
        make.height.mas_equalTo(Width);
    }];
    
    self.passwordTf = [[UITextField alloc]init];
    self.passwordTf.placeholder = NSLocalizedString(@"请输入密码",nil);
    self.passwordTf.font = [UIFont systemFontOfSize:16.0];
    self.passwordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTf.tag = 501;
    // 密码格式
    self.passwordTf.secureTextEntry = YES;
    self.passwordTf.delegate = self;
	self.passwordTf.text = @"livecom";
    [pswImgView addSubview:self.passwordTf];
    
    [self.passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pswImgView).with.offset(Width);
        make.right.equalTo(pswImgView).with.offset(-TFLandR);
        make.top.equalTo(pswImgView).with.offset(TFLandR);
        make.bottom.equalTo(pswImgView).with.offset(-TFLandR);
    }];
    
    
    
    UIImageView *companyImgView = [[UIImageView alloc]init];
    companyImgView.image = [UIImage imageNamed:@"password0"];
    companyImgView.layer.borderColor = BorderColor;
    companyImgView.layer.borderWidth = 0.5;
    //pswImgView.layer.cornerRadius = 3.0;
    companyImgView.clipsToBounds = YES;
    companyImgView.userInteractionEnabled = YES;
    [self.view addSubview:companyImgView];
    [companyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pswImgView.mas_bottom).with.offset(ImgLandR);
        make.left.equalTo(self.view).with.offset(ImgLandR);
        make.right.equalTo(self.view).with.offset(-ImgLandR);
        make.height.mas_equalTo(Width);
    }];
    
    self.companyTf = [[UITextField alloc]init];
    self.companyTf.placeholder = NSLocalizedString(@"请输入企业ID",nil);
    self.companyTf.font = [UIFont systemFontOfSize:16.0];
    self.companyTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.companyTf.tag = 501;
    // 密码格式
//    self.companyTf.secureTextEntry = YES;
    self.companyTf.delegate = self;
	self.companyTf.text = @"1101";
    [companyImgView addSubview:self.companyTf];
    
    [self.companyTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyImgView).with.offset(Width);
        make.right.equalTo(companyImgView).with.offset(-TFLandR);
        make.top.equalTo(companyImgView).with.offset(TFLandR);
        make.bottom.equalTo(companyImgView).with.offset(-TFLandR);
    }];
    
    
    //记住密码
    self.recordPswBox = [[QCheckBox alloc]initWithDelegate:self];
    self.recordPswBox.frame = CGRectMake(userImgView.frame.origin.x, (companyImgView.frame.origin.y+55), 100, 20);
    [self.recordPswBox setTitle:NSLocalizedString(@"自动登录",nil) forState:UIControlStateNormal];
	self.recordPswBox.titleLabel.font = [UIFont systemFontOfSize:13];
    self.recordPswBox.tag = 1001;
    [self.recordPswBox setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
    [self.view addSubview:self.recordPswBox];
    
    [self.recordPswBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(companyImgView.mas_bottom).with.offset(ImgLandR);
        make.left.equalTo(self.view).with.offset(ImgLandR);
        make.size.mas_equalTo(CGSizeMake(100, 32));
    }];
    
    //loginBtn
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginBtn.backgroundColor =CNavBgColor;
    [loginBtn setTitle:NSLocalizedString(@"登  录",nil) forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 3.0;
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recordPswBox.mas_bottom).with.offset(ImgLandR);
        make.left.equalTo(self.view).with.offset(ImgLandR);
        make.right.equalTo(self.view).with.offset(-ImgLandR);
        make.height.mas_equalTo(Width);
    }];
    
    
}


- (void)loginClick
{
    [self.view endEditing:YES];
    
    //  发请求
    [self sendLoginRequest];
    
}

-(void)sendLoginRequest{
    
    self.userNameTf.text = [self.userNameTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.passwordTf.text = [self.passwordTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.companyTf.text = [self.companyTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // 判断用户名
    if ([self.userNameTf.text length]<2)
    {
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"请输入正确的用户名",nil)];
        return;
    }
    // 判断密码
    if (!([self.passwordTf.text length]<=16 && [self.passwordTf.text length]>=1))
    {
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"请输入正确的密码",nil)];
        return;
    }
    if (self.companyTf.text.length < 1) {
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"请输入企业ID",nil)];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"companyId": self.companyTf.text,
                                 @"username":self.userNameTf.text,
                                 @"password": [MyMd5 md5_lowerStr:self.passwordTf.text],
                                 } ;
    
    [userManager login:kUserLoginTypePwd params:parameters completion:^(BOOL success, NSString *des) {
        if (success) {
            DLog(@"登录成功");
            [self saveUserInfo];
            KPostNotification(KNotificationLoginStateChange, @YES);
        }else{
            DLog(@"登录失败：%@", des);
            [self showErrorLog:des];
        }
    }];
}

-(void)showErrorLog:(NSString *)errorMsg{
//    [MBProgressHUD showErrorMessage:errorMsg];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示",nil) message:errorMsg delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
    alertView.tag = 122;
    [alertView show];
}


/**
 保存用户名密码
 */
-(void)saveUserInfo{
    
   NSString *userName = [self.userNameTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   NSString *psw = [MyMd5 md5_lowerStr:[self.passwordTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    NSString *companyID = [self.companyTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //    保存用户名
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:VN_USERNAME];
    //    保存密码
    [[NSUserDefaults standardUserDefaults] setObject:psw forKey:VN_PASSWORD];
    //    保存企业ID
    [[NSUserDefaults standardUserDefaults] setObject:companyID forKey:VN_COMPANYID];
    
    //    自动登录
    if(self.recordPswBox.checked ==YES){
        DLog(@"选中");
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:VN_AUTOLOGIN];
    }else{
        DLog(@"未选中");
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:VN_AUTOLOGIN];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)skipAction{
    KPostNotification(KNotificationLoginStateChange, @YES);
}


/**
 隐藏键盘
 
 @param touches <#touches description#>
 @param event <#event description#>
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.passwordTf resignFirstResponder];
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
