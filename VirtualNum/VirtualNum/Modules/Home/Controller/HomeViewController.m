//
//  HomeViewController.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/24.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "HomeViewController.h"
#import "ChooseNumViewController.h"

@interface HomeViewController ()<UIAlertViewDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"首页";
    //    [self creadTableView];
    [self judgeAX];
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
        make.top.equalTo(self.view).with.offset(64);
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];
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
