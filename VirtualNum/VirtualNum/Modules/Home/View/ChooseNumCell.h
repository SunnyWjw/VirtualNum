//
//  ChooseNumCell.h
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/25.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseNumCell : UITableViewCell


@property(nonatomic,strong) UIImageView *TopImgView;
@property(nonatomic,strong) UILabel *TopLab;

@property(nonatomic,strong) UILabel *BottomLab;
@property(nonatomic,strong) UIImageView *BottomImgView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;



@end
