//
//  AutomaticCalculationWithWidth.m
//  Ltalk
//
//  Created by livecom on 16/3/23.
//  Copyright © 2016年 livecom. All rights reserved.
//

#import "AutomaticCalculationWithWidth.h"

@implementation AutomaticCalculationWithWidth

#pragma mark - 自动计算高度
+ (CGSize)sizeForContentWithString:(NSString *)contentStr Size:(CGSize)size Fontsize:(NSInteger)fontsize
{
    // label可设置的最大高度和宽度
    //    CGSize size = CGSizeMake(320-20-30, MAXFLOAT);
    
    // 获取当前文本的属性
    UIFont *tFont = [UIFont fontWithName:@"Arial" size:fontsize];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tFont,NSFontAttributeName,nil];
    
    CGSize actualsize =[contentStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    
    return actualsize;
}


@end
