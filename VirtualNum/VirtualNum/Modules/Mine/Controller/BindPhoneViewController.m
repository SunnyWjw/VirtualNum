//
//  BindPhoneViewController.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/2.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "BindPhoneViewController.h"

@interface BindPhoneViewController ()

@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.bindTitle;
    
    if ([self.bindType isEqualToString:@"0"]) {
        //修改
        [self updatePhoneNum];
    }else{
        //绑定
        [self bindPhoneNum];
    }
}

-(void)updatePhoneNum{
    
}


-(void)bindPhoneNum{
    
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
