//
//  LoginViewController.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/24.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "LoginViewController.h"
#import "QCheckBox.h"

@interface LoginViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property(strong,nonatomic) UITextField *userNameTf;
@property(strong,nonatomic) UITextField *passwordTf;
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
    self.title = @"登录";
    
    kWeakSelf(self);
    
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
        make.top.equalTo(self.view).with.offset(ImgTop);
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
    self.userNameTf.placeholder = @"请输入用户名";
    self.userNameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTf.tag = 500;
    self.userNameTf.delegate = self;
    self.userNameTf.font = [UIFont systemFontOfSize:16.0];
    
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
    self.passwordTf.placeholder = @"请输入密码";
    self.passwordTf.font = [UIFont systemFontOfSize:16.0];
    self.passwordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTf.tag = 501;
    // 密码格式
    self.passwordTf.secureTextEntry = YES;
    self.passwordTf.delegate = self;
    [pswImgView addSubview:self.passwordTf];
    
    [self.passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pswImgView).with.offset(Width);
        make.right.equalTo(pswImgView).with.offset(-TFLandR);
        make.top.equalTo(pswImgView).with.offset(TFLandR);
        make.bottom.equalTo(pswImgView).with.offset(-TFLandR);
    }];
    
    //记住密码
    self.recordPswBox = [[QCheckBox alloc]initWithDelegate:self];
    self.recordPswBox.frame = CGRectMake(userImgView.frame.origin.x, (pswImgView.frame.origin.y+55), 100, 20);
    [self.recordPswBox setTitle:@"自动登录" forState:UIControlStateNormal];
    self.recordPswBox.tag = 1001;
    [self.recordPswBox setTitleColor:[UIColor colorWithHexString:@"#919191"] forState:UIControlStateNormal];
    [self.view addSubview:self.recordPswBox];
    
    [self.recordPswBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pswImgView.mas_bottom).with.offset(ImgLandR);
        make.left.equalTo(self.view).with.offset(ImgLandR);
        make.size.mas_equalTo(CGSizeMake(100, 32));
    }];
    
    //loginBtn
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginBtn.backgroundColor =CNavBgColor;
    [loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
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
    
    // 判断用户名
    if ([self.userNameTf.text length]<2)
    {
        [MBProgressHUD showErrorMessage:@"请输入正确的用户名"];
        return;
    }
    // 判断密码
    if (!([self.passwordTf.text length]<=16 && [self.passwordTf.text length]>=1))
    {
        [MBProgressHUD showErrorMessage:@"请输入正确的密码"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"username": self.userNameTf.text,
                                 @"password": self.passwordTf.text} ;
    
    [userManager login:kUserLoginTypePwd params:parameters completion:^(BOOL success, NSString *des) {
        if (success) {
            DLog(@"登录成功");
            [self saveUserInfo];
        }else{
            DLog(@"登录失败：%@", des);
            [self showErrorLog:des];
        }
    }];
}

-(void)showErrorLog:(NSString *)errorMsg{
//    [MBProgressHUD showErrorMessage:errorMsg];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:errorMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.tag = 122;
    [alertView show];
}

-(void)saveUserInfo{
    
    self.userNameTf.text = [self.userNameTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.passwordTf.text = [self.passwordTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //    保存用户名
    [[NSUserDefaults standardUserDefaults] setObject:self.userNameTf.text forKey:userName];
    
    //    保存密码
    [[NSUserDefaults standardUserDefaults] setObject:self.passwordTf.text forKey:passWord];
    
    //    自动登录
    if(self.recordPswBox.checked ==YES){
        DLog(@"选中");
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:autoLogin];
    }else{
        DLog(@"未选中");
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:autoLogin];
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
