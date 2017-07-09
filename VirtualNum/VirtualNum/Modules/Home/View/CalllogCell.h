//
//  CalllogCell.h
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/3.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalllogCell : UITableViewCell


/**
 被叫人姓名
 */
@property(nonatomic,strong) UILabel *calledNameLab;
/**
 被叫人电话
 */
@property(nonatomic,strong) UILabel *callPhoneNumLab;
/**
 通话记录创建时间
 */
@property(nonatomic,strong) UILabel *generateTimeLab;

/**
 随机数
 */
@property(nonatomic,strong) UILabel *xLab;

/**
 详情
 */
@property(nonatomic,strong) UIImageView *detailImgView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;



@end
