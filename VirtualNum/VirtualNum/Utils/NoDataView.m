//
//  NoDataView.m
//  Ltalk
//
//  Created by livecom on 16/3/25.
//  Copyright © 2016年 livecom. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self CrateNodataViewWithFrame:frame];
    }
    return self;
}

-(void)CrateNodataViewWithFrame:(CGRect)frame
{
    UIView *nodataview = [[UIView alloc]initWithFrame:frame];
//    nodataview.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1];
    [self addSubview:nodataview];
    self.showLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
    self.showLab.textAlignment = NSTextAlignmentCenter;
    self.showLab.font =[UIFont systemFontOfSize:20.0f];
    self.showLab.textColor = [UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1];
    [nodataview addSubview:self.showLab];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
