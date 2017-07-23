//
//  ChooseServiceViewController.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/2.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "ChooseServiceViewController.h"
#import "Common.h"
#import "CallSettingsCell.h"

@interface ChooseServiceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong)NSArray *dataArray;;


@end

static NSUInteger selectInt;

@implementation ChooseServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title= @"服务模式";
    
    self.tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.bounces = NO;
    [self.view addSubview:self.tableview];
    [Common setExtraCellLineHidden:self.tableview];
    
    self.dataArray = @[@"租车模式", @"中介模式"];
    
    NSString *callSettingsType = [[NSUserDefaults standardUserDefaults] objectForKey:VN_SERVICE];
    for (int i = 0; i< self.dataArray.count; i++) {
        if ([callSettingsType isEqualToString:[NSString stringWithFormat:@"%d",i]]) {
            selectInt = i;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 28.0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"Cell";
    
    
    UINib *nib = [UINib nibWithNibName:@"CallSettingsCell" bundle:[NSBundle bundleForClass:[CallSettingsCell class]]] ;
    [tableView registerNib:nib forCellReuseIdentifier:identity] ;
    CallSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    
    if (cell == nil) {
        cell = [[CallSettingsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
        //                cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //                cell.selectionStyle = UITableViewCellStyleDefault;
    }
    cell.textNameLab.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.detailTextLab.text = @"说明";
    
    if (selectInt == indexPath.row) {
        cell.selectImg.image = [UIImage imageNamed:@"radio_select"];
    }else {
        cell.selectImg.image = [UIImage imageNamed:@"radio"];
    }
    
    return cell;
    
}

#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CallSettingsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    selectInt = indexPath.row;
    cell.selectImg.image = [UIImage imageNamed:@"radio_select"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu",(unsigned long)selectInt] forKey:VN_SERVICE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableview reloadData];
    
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
