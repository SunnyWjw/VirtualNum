//
//  UIButton+TopBottom.h
//  Ltalk
//
//  Created by Mark.PL on 14/12/29.
//  Copyright (c) 2014年 Ltalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TopBottom)

//button中图片文字上下排列
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;

@end
