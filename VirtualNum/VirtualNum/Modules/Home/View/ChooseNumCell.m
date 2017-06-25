//
//  ChooseNumCell.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/25.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "ChooseNumCell.h"

@implementation ChooseNumCell

#define TAndB 5

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self cellSubviews];
    }
    return self;
}

- (void)cellSubviews
{
    self.TopImgView = [[UIImageView alloc] init];
    self.TopImgView.image = [UIImage imageNamed:@"company"];
    [self addSubview:self.TopImgView];
    [self.TopImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(TAndB);
        make.left.equalTo(self).with.offset(TAndB);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.BottomImgView = [[UIImageView alloc] init];
    self.BottomImgView.image = [UIImage imageNamed:@"phoneNum"];
    [self addSubview:self.BottomImgView];
    [self.BottomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TopImgView.mas_bottom).with.offset(TAndB);
        make.left.equalTo(self).with.offset(TAndB);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.TopLab = [[UILabel alloc]init];
    self.TopLab.textColor = [UIColor colorWithHexString:LIST_DETAIL_COLOR];//@"#4c4c4c"
    self.TopLab.backgroundColor = [UIColor clearColor];
    self.TopLab.textAlignment = NSTextAlignmentLeft;
    self.TopLab.font = [UIFont systemFontOfSize:CELL_CONTENT_SIZE];//10.0
    self.TopLab.alpha = 0.7;
    [self.contentView addSubview:self.TopLab];
    
    self.BottomLab = [[UILabel alloc]init];
    self.BottomLab.textColor = [UIColor colorWithHexString:LIST_DETAIL_COLOR];//@"#4c4c4c"
    self.BottomLab.backgroundColor = [UIColor clearColor];
    self.BottomLab.textAlignment = NSTextAlignmentLeft;
    self.BottomLab.font = [UIFont systemFontOfSize:CELL_CONTENT_SIZE];//10.0
    self.BottomLab.alpha = 0.7;
    [self.contentView addSubview:self.BottomLab];
    
    [self.TopLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(TAndB);
        make.left.equalTo(self.TopImgView.mas_right).with.offset(TAndB);
        make.right.equalTo(self).with.offset(-TAndB);
        make.centerX.equalTo(self.BottomLab.mas_centerX);
    }];
    
    [self.BottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TopLab.mas_bottom).with.offset(TAndB);
        make.left.equalTo(self.BottomImgView.mas_right).with.offset(TAndB);
        make.right.equalTo(self).with.offset(-TAndB);
        make.centerX.equalTo(self.TopLab.mas_centerX);
        
    }];
    
    
    //  下边的线 代替分割线
    //    UILabel *tempGrayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height+10, self.bounds.size.width, 1)];
    //    tempGrayLabel.backgroundColor = [UIColor colorWithHexString:@"#e3e3e3"];
    //    [self addSubview:tempGrayLabel];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
