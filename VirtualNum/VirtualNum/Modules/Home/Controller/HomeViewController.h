//
//  HomeViewController.h
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/24.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "RootViewController.h"
#import "AFFNumericKeyboard.h"

@interface HomeViewController : RootViewController
{
    AFFNumericKeyboard *keyboard;
}

@property (nonatomic, strong) AFFNumericKeyboard *keyboard;

@end
