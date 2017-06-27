//
//  SettingViewController.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/24.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "SettingViewController.h"
#import "ChooseNumViewController.h"

@interface SettingViewController ()<UIAlertViewDelegate>

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"设置";
    [self createView];
    
    
}

-(void)createView{
    
    UIButton *chooseBtn = [[UIButton alloc]init];
    chooseBtn.backgroundColor =CNavBgColor;
    [chooseBtn setTitle:@"选择号码" forState:UIControlStateNormal];
    chooseBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(chooseClick) forControlEvents:UIControlEventTouchUpInside];
    chooseBtn.layer.masksToBounds = YES;
    chooseBtn.layer.cornerRadius = 3.0;
    [self.view addSubview:chooseBtn];
    [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(104);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitBtn setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
    [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    exitBtn.backgroundColor=[UIColor grayColor];
    [self.view addSubview:exitBtn];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-100);
        make.left.equalTo(self.view).with.offset(100);
        make.right.equalTo(self.view).with.offset(-100);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)chooseClick
{
    ChooseNumViewController * chooseVc = [[ChooseNumViewController alloc]init];
    [self.navigationController pushViewController:chooseVc animated:NO];
}


#pragma mark 退出当前账号
- (void)exitBtnClick
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"退出当前账号？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.tag = 122;
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 122)
    {
        if (buttonIndex == 0) {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"USERNAME"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PASSWORD"];
            KPostNotification(KNotificationLoginStateChange, @NO)
        }
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
