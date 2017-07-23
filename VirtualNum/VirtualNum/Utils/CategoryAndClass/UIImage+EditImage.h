//
//  UIImage+EditImage.h
//  Ltalk
//
//  Created by Mark.PL on 15/1/6.
//  Copyright (c) 2015年 Ltalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (EditImage)

//改变图片颜色
- (UIImage *)imageWithImage:(UIImage *)image Color:(UIColor *)color;

//改变图片大小,不是真
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

@end
