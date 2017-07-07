//
//  UIButton+TopBottom.m
//  Ltalk
//
//  Created by Mark.PL on 14/12/29.
//  Copyright (c) 2014年 Ltalk. All rights reserved.
//

#define kFONT [UIFont systemFontOfSize:12.0f]

#import "UIButton+TopBottom.h"

@implementation UIButton (TopBottom)

- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    CGSize titleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kFONT,NSFontAttributeName, nil]];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-8.0,
                                               0.0,
                                               0.0,
                                              -titleSize.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:kFONT];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(30.0,
                                              -image.size.width,
                                              0.0,
                                              0.0)];
    
    [self setTitle:title forState:stateType];
}

//如果不需要上下显示，只需要横向排列的时候，就不需要设置左右偏移量了，代码如下
//- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
//    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
//    
//    CGSize titleSize = [title sizeWithFont:kFONT(12.0f)];
//    [self.imageView setContentMode:UIViewContentModeCenter];
//    [self setImageEdgeInsets:UIEdgeInsetsMake(-8.0,
//                                              0.0,
//                                              0.0,
//                                              0.0)];
//    [self setImage:image forState:stateType];
//    
//    [self.titleLabel setContentMode:UIViewContentModeCenter];
//    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
//    [self.titleLabel setFont:kFONT(12.0f)];
//    [self.titleLabel setTextColor:[UIColor blackColor]];
//    [self setTitleEdgeInsets:UIEdgeInsetsMake(30.0,
//                                              0.0,
//                                              0.0,
//                                              0.0)];
//    [self setTitle:title forState:stateType];
//}

@end
