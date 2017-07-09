//
//  CalllogCell.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/3.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "CalllogCell.h"

@implementation CalllogCell

#define TOP 5
#define LEFT 10


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
    
    self.calledNameLab = [[UILabel alloc]init];
    self.calledNameLab.textColor = [UIColor colorWithHexString:LIST_DETAIL_COLOR];//@"#4c4c4c"
    self.calledNameLab.backgroundColor = [UIColor clearColor];
    self.calledNameLab.textAlignment = NSTextAlignmentLeft;
    self.calledNameLab.font = [UIFont systemFontOfSize:CELL_CONTENT_SIZE];//10.0
    self.calledNameLab.alpha = 0.7;
    [self addSubview:self.calledNameLab];
    
    self.callPhoneNumLab = [[UILabel alloc]init];
    self.callPhoneNumLab.textColor = [UIColor colorWithHexString:LIST_DETAIL_COLOR];//@"#4c4c4c"
    self.callPhoneNumLab.backgroundColor = [UIColor clearColor];
    self.callPhoneNumLab.textAlignment = NSTextAlignmentLeft;
    self.callPhoneNumLab.font = [UIFont systemFontOfSize:CELL_DETAIL_SIZE];//10.0
    self.callPhoneNumLab.alpha = 0.7;
    [self.contentView addSubview:self.callPhoneNumLab];
    
    self.generateTimeLab = [[UILabel alloc]init];
    self.generateTimeLab.textColor = [UIColor colorWithHexString:LIST_DETAIL_COLOR];//@"#4c4c4c"
    self.generateTimeLab.backgroundColor = [UIColor clearColor];
    self.generateTimeLab.textAlignment = NSTextAlignmentRight;
    self.generateTimeLab.font = [UIFont systemFontOfSize:CELL_DETAIL_SIZE];//10.0
    self.generateTimeLab.alpha = 0.7;
    [self.contentView addSubview:self.generateTimeLab];
    
    
    self.xLab = [[UILabel alloc]init];
    self.xLab.textColor = [UIColor colorWithHexString:LIST_DETAIL_COLOR];//@"#4c4c4c"
    self.xLab.backgroundColor = [UIColor clearColor];
    self.xLab.textAlignment = NSTextAlignmentLeft;
    self.xLab.font = [UIFont systemFontOfSize:CELL_DETAIL_SIZE];//10.0
    self.xLab.alpha = 0.7;
    self.xLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.xLab];
    
    
    self.detailImgView = [[UIImageView alloc] init];
    self.detailImgView.image = [UIImage imageNamed:@"detail"];
    [self addSubview:self.detailImgView];
   
    
    [self.calledNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(TOP);
        make.left.equalTo(self).with.offset(LEFT);
        make.size.mas_equalTo(CGSizeMake(200, 25));
    }];
    
    [self.callPhoneNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(LEFT);
        make.bottom.equalTo(self).with.offset(-TOP);
        make.size.mas_equalTo(CGSizeMake(200, 25));
        
    }];

    [self.generateTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(TOP);
        make.right.equalTo(self).with.offset(-30);
        //        make.right.equalTo(self).with.offset(-TAndB);
//        make.centerY.equalTo(self.mas_centerY);
//        make.height.mas_equalTo(25);
         make.size.mas_equalTo(CGSizeMake(200, 25));
        
    }];
    
    [self.xLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-TOP);
        make.right.equalTo(self).with.offset(-30);
        //        make.right.equalTo(self).with.offset(-TAndB);
//        make.centerY.equalTo(self.mas_centerY);
//        make.height.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake(200, 25));
    }];
    
    [self.detailImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.top.equalTo(self).with.offset(TOP);
        make.right.equalTo(self).with.offset(-TOP);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
