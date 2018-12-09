//
//  BindPhoneViewController.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/2.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "BindPhoneViewController.h"

@interface BindPhoneViewController ()<UITextFieldDelegate>
@property(strong,nonatomic) UITextField *userNameTf;


@end

#define ImgLandR 20
#define TFLandR 5
#define Width 45

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.bindTitle;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    
    if ([self.bindType isEqualToString:@"0"]) {
        //修改
        [self updatePhoneNum];
    }else{
        self.title = NSLocalizedString(@"绑定手机号码",nil);
        //绑定
        [self bindPhoneNum];
    }
}
-(void) viewWillAppear:(BOOL)animated{
//    [self.navigationItem setHidesBackButton:YES];
    [super viewWillAppear:YES];
    
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
    
}

-(void)updatePhoneNum{
    
}

- (void)backBtnClicked{
    [self BindClick];
}

-(void)bindPhoneNum{
    
    self.userNameTf = [[UITextField alloc]init];
    self.userNameTf.layer.masksToBounds = YES;
    self.userNameTf.layer.cornerRadius = 3.0;
    [self.view addSubview:self.userNameTf];
    self.userNameTf.placeholder = NSLocalizedString(@"请输入手机号码",nil);
    self.userNameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTf.tag = 500;
    self.userNameTf.font = [UIFont systemFontOfSize:16.0];
    self.userNameTf.backgroundColor = [UIColor whiteColor];
    self.userNameTf.delegate = self;
    self.userNameTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.userNameTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.userNameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(TFLandR);
        make.right.equalTo(self.view).with.offset(-TFLandR);
        make.top.equalTo(self.view).with.offset(100);
        make.height.mas_equalTo(Width);
    }];
    
    //loginBtn
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginBtn.backgroundColor =CNavBgColor;
    [loginBtn setTitle:NSLocalizedString(@"绑  定",nil) forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(BindClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 3.0;
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameTf.mas_bottom).with.offset(ImgLandR);
        make.left.equalTo(self.view).with.offset(ImgLandR);
        make.right.equalTo(self.view).with.offset(-ImgLandR);
        make.height.mas_equalTo(Width);
    }];
}

- (void)BindClick{
    if(self.userNameTf.text.length == 0){
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"请输入手机号完成绑定",nil)];
        return;
    }
//    if (![self.userNameTf.text checkPhoneNumInput:self.userNameTf.text]) {
//        [MBProgressHUD showErrorMessage:NSLocalizedString(@"请输入正确的手机号",nil)];
//        return;
//    }
     [[NSUserDefaults standardUserDefaults] setObject:self.userNameTf.text forKey:VN_PHONE];
//     [MBProgressHUD showErrorMessage:@"绑定成功!"];
	[self showAlertForTitle:NSLocalizedString(@"绑定成功",nil) Message:@""];
	
}

-(void)showAlertForTitle:(NSString *)title Message:(NSString *)Msgstr{
	UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:Msgstr delegate:self cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil, nil];
	alertView.tag = 122;
	[alertView show];
}
#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

	if (alertView.tag == 122)
	{
		if (buttonIndex == 0) {
			[self.navigationController popViewControllerAnimated:NO];
			return;
		}
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

- (void) textFieldDidChange:(UITextField *)textField{
    if (textField.markedTextRange == nil) {
        //NSLog(@"text:%@", textField.text);
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
