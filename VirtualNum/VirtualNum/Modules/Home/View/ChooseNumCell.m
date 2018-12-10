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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isShowDel:(BOOL)isShow
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.isShowDelBtn = isShow;
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
	
	self.delBtn = [[UIButton alloc] init];
	[self.delBtn setTitle:@"删除" forState:UIControlStateNormal];
	[self.delBtn setTitleColor:CNavBgColor forState:UIControlStateNormal];
	self.delBtn.titleLabel.font = [UIFont systemFontOfSize:14];
	self.delBtn.layer.borderWidth = 1.f;
	self.delBtn.layer.borderColor = CNavBgColor.CGColor;
	[self.contentView addSubview:self.delBtn];
	self.delBtn.hidden = YES;
	[self.delBtn addTarget:self action:@selector(clickDelBtn:) forControlEvents:UIControlEventTouchUpInside];
	if (self.isShowDelBtn) {
		self.delBtn.hidden = NO;
	}
	
    [self.TopLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(TAndB);
        make.left.equalTo(self.TopImgView.mas_right).with.offset(TAndB);
        make.right.equalTo(self).with.offset(-TAndB);
        make.centerX.equalTo(self.BottomLab.mas_centerX);
    }];
    
    [self.BottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.TopLab.mas_bottom).with.offset(TAndB);
        make.left.equalTo(self.BottomImgView.mas_right).with.offset(TAndB);
//        make.right.equalTo(self).with.offset(-TAndB);
//        make.centerX.equalTo(self.TopLab.mas_centerX);
//		 make.width.mas_equalTo(300);
    }];
	[self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.TopLab.mas_bottom).with.offset(TAndB);
		make.right.equalTo(self).with.offset(-TAndB);
		make.width.mas_equalTo(40);
	}];
    
    
    //  下边的线 代替分割线
    //    UILabel *tempGrayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height+10, self.bounds.size.width, 1)];
    //    tempGrayLabel.backgroundColor = [UIColor colorWithHexString:@"#e3e3e3"];
    //    [self addSubview:tempGrayLabel];
}

-(void)clickDelBtn:(UIButton *)sender{
	
	NSArray *topArray = [self.TopLab.text componentsSeparatedByString:@", Trans:"]; //从字符A中分隔成2个元素的数组
	NSArray *bottomArray = [self.BottomLab.text componentsSeparatedByString:@", MODE:"]; //从字符A中分隔成2个元素的数组
	
	NSString *xStr = [topArray[0] substringFromIndex:2];
	NSString *transStr = topArray[1];
	NSString *bStr = [bottomArray[0] substringFromIndex:2];
	NSString *modeStr = bottomArray[1];
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	[dic setValue:xStr forKey:@"X"];
	[dic setValue:transStr forKey:@"TRANS"];
	[dic setValue:bStr forKey:@"B"];
	[dic setValue:modeStr forKey:@"MODE"];
	
	if (self.selectTransDelegate && [self.selectTransDelegate respondsToSelector:@selector(selectTransForAXB:)])
	{
		// 调用代理方法
		[self.selectTransDelegate selectTransForAXB:dic];
	}
}

- (void)ShowDelBtn:(BOOL)isShow{
	self.isShowDelBtn = isShow;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
