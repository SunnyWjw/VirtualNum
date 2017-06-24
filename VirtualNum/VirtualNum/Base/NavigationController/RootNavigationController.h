//
//  RootNavigationController.h
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/24.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RxWebViewNavigationViewController.h"

/**
 导航控制器基类
 */
@interface RootNavigationController : RxWebViewNavigationViewController

/*!
 *  返回到指定的类视图
 *
 *  @param ClassName 类名
 *  @param animated  是否动画
 */
-(BOOL)popToAppointViewController:(NSString *)ClassName animated:(BOOL)animated;

@end