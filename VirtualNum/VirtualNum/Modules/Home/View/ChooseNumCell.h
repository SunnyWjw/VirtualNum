//
//  ChooseNumCell.h
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/25.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectTransDelegate <NSObject>
-(void)selectTransForAXB:(NSDictionary *)axbDic;
@end

@interface ChooseNumCell : UITableViewCell


@property(nonatomic,strong) UIImageView *TopImgView;
@property(nonatomic,strong) UILabel *TopLab;

@property(nonatomic,strong) UILabel *BottomLab;
@property(nonatomic,strong) UIImageView *BottomImgView;
@property(nonatomic,strong) UIButton *delBtn;
@property(nonatomic,assign) BOOL isShowDelBtn;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isShowDel:(BOOL)isShow;

@property(nonatomic,weak)id<SelectTransDelegate> selectTransDelegate;

@end
