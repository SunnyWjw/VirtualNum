//
//  BindPhoneViewController.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/9/12.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "BindPhoneViewController.h"

@interface BindPhoneViewController ()
    
@property(strong,nonatomic) UITextField *userNameTf;

@end

#define ImgLandR 20
#define TFLandR 5
#define Width 45

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定手机号码";
    [self createBindView];
}
    
-(void) createBindView{
    self.userNameTf = [[UITextField alloc]init];
    [self.view addSubview:self.userNameTf];
    self.userNameTf.placeholder = @"请输入手机号码";
    self.userNameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTf.tag = 500;
    self.userNameTf.font = [UIFont systemFontOfSize:16.0];
    
    [self.userNameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(Width);
        make.right.equalTo(self).with.offset(-TFLandR);
        make.top.equalTo(self).with.offset(TFLandR);
        make.bottom.equalTo(self).with.offset(-TFLandR);
    }];
    
    //loginBtn
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginBtn.backgroundColor =CNavBgColor;
    [loginBtn setTitle:@"绑  定" forState:UIControlStateNormal];
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
