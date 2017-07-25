//
//  ContactCell.h
//  Ltalk
//  Copyright (c) 2015年 Ltalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalllogDetailCell : UITableViewCell

///呼出时间
@property (weak, nonatomic) IBOutlet UILabel *leftTopLabel;
///通话时长
@property (weak, nonatomic) IBOutlet UILabel *leftBottomLabel;
///服务模式
@property (weak, nonatomic) IBOutlet UILabel *rightTopLabel;
///随机数
@property (weak, nonatomic) IBOutlet UILabel *rightBottomLabel;

@end
