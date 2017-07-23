//
//  Common.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/2.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "Common.h"

@implementation Common

#pragma mark - 隐藏多余的分割线
+ (void)setExtraCellLineHidden: (UITableView *)tableView {
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    tableView.showsVerticalScrollIndicator =NO;
}

@end
