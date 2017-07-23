//
//  UIButton+FillColor.h
//  Ltalk
//
//  Created by Mark.PL on 14/12/31.
//  Copyright (c) 2014年 Ltalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (FillColor)

//button不同状态的背景颜色（代替图片）
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;


@end
