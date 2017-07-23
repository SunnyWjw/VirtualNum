//
//  NoDataView.h
//  Ltalk
//
//  Created by livecom on 16/3/25.
//  Copyright © 2016年 livecom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataView : UIView

/**
 *  @author livecom, 16-03-25 12:03:51
 *
 *  @brief 无数据时，显示的文字
 */
@property (nonatomic,strong)UILabel *showLab;

- (id)initWithFrame:(CGRect)frame;

@end
