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


@interface HomeViewController ()<UIAlertViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *popBtn;
@property (strong, nonatomic) UITextField *idTF;
@property (strong, nonatomic) UILabel *promptLab;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"呼叫记录";
    //    [self creadTableView];
   // [self judgeAX];
    
    __block HomeViewController/*主控制器*/ *weakSelf = self;
    NSString *companyidStr =[[NSUserDefaults standardUserDefaults] objectForKey:companyid];
    if (!companyidStr) {
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
//        
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            [weakSelf popViewShow];
//        });
       // [NSThread sleepForTimeInterval:2.0];
        [weakSelf popViewShow];
    }
    NSString *xStr =[[NSUserDefaults standardUserDefaults] objectForKey:X];
    if (!xStr) {
        [self judgeAX];
    }
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
    
    UIButton * cancelBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame =CGRectMake(10, 90, 80, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.backgroundColor= CNavBgColor;
    [cancelBtn addTarget:self action:@selector(closeAndBack) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:cancelBtn];
    
    UIButton * sureBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame =CGRectMake(110, 90, 80, 40);
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
}
-(void)sureAndBack{
   
    self.idTF.text = [self.idTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // 判断用户名
    if ([self.idTF.text length] == 0)
    {
        _promptLab.text =@"请输入您的CompanyID";
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.idTF.text forKey:companyid];
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
