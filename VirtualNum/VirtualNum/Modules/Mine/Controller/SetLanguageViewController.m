//
//  SetLanguageViewController.m
//  ADIntegral
//
//  Created by SunnyWu on 2018/8/6.
//  Copyright © 2018年 Livecom. All rights reserved.
//

#import "SetLanguageViewController.h"
#import "CallSettingsCell.h"
#import "DAConfig.h"
#import "NSBundle+DAUtils.h"
#import "MineViewController.h"

@interface SetLanguageViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic, strong) NSArray *CallArrayData;
@property (nonatomic,strong) UITableView *tableview;

@end


@implementation SetLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"语言设置",nil);
    
	self.tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.tableview.delegate = self;
	self.tableview.dataSource = self;
	self.tableview.bounces = NO;
	[self.view addSubview:self.tableview];
	[Common setExtraCellLineHidden:self.tableview];
	
    self.CallArrayData = @[NSLocalizedString(@"跟随系统",nil), @"简体中文",@"English"];
}

- (void)viewWillAppear:(BOOL)animated
{
	self.tabBarController.tabBar.hidden=YES;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	self.tabBarController.tabBar.hidden=NO;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.CallArrayData.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 28.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
    }
    // Configure the cell...
    //用户没有自己设置的语言，则跟随手机系统
    if (![DAConfig userLanguage].length) {
        cell.accessoryType = indexPath.row == 0 ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else {
        if ([NSBundle isChineseLanguage]) {
            //简体中文
            if (indexPath.row == 1) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            if ([self.CallArrayData[indexPath.row] isEqualToString:@"English"] && [[NSBundle currentLanguage] isEqualToString:@"en"]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else if ([self.CallArrayData[indexPath.row] isEqualToString:@"繁體中文"] && [[NSBundle currentLanguage] isEqualToString:@"zh-Hant"]){
                 cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else  if ([self.CallArrayData[indexPath.row] isEqualToString:NSLocalizedString(@"跟随系统",nil)] && [[NSBundle currentLanguage] isEqualToString:@"en-US"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    cell.textLabel.text = self.CallArrayData[indexPath.row];
    return cell;
}

#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        return;
    }
    for (UITableViewCell *acell in tableView.visibleCells) {
        acell.accessoryType = acell == cell ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    
    if (indexPath.row == 0) {
        [DAConfig setUserLanguage:nil];
    } else if (indexPath.row == 1) {
        [DAConfig setUserLanguage:@"zh-Hans"];
    } else if (indexPath.row == 2) {
        [DAConfig setUserLanguage:@"en"];
    } else {
        [DAConfig setUserLanguage:@"zh-Hant"];
    }
    //更新当前storyboard
    [self resetRootViewController];
}

//重新设置
-(void)resetRootViewController
{
    MainTabBarController *tab = [[MainTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tab;
    // 跳转到设置页
    tab.selectedIndex = 2;
	
	SetLanguageViewController *setLangVc = [[SetLanguageViewController alloc] init];
	
	UINavigationController *nvc = tab.selectedViewController;
    NSMutableArray *vcs = nvc.viewControllers.mutableCopy;
    [vcs addObject:setLangVc];
    //解决奇怪的动画bug。异步执行
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
        nvc.viewControllers = vcs;
        NSLog(@"已切换到语言2222 %@", [NSBundle currentLanguage]);
    });
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
