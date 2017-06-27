//
//  AutomaticCalculationWithWidth.h
//  Ltalk
//
//  Created by livecom on 16/3/23.
//  Copyright © 2016年 livecom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutomaticCalculationWithWidth : NSObject

/**
 *  @author livecom, 16-03-23 14:03:29
 *
 *  @brief 自动计算文本宽度
 *
 *  @param contentStr 要计算的文本
 *  @param size       label可设置的最大高度和宽度
 *
 *  @return 返回cgsize
 */
+ (CGSize)sizeForContentWithString:(NSString *)contentStr Size:(CGSize)size Fontsize:(NSInteger)fontsize;

@end
