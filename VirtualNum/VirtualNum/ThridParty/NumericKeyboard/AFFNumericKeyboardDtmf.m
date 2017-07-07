//
//  CustomKeyboard.m
//  keyboard
//
//  Created by zhaowang on 14-3-25.
//  Copyright (c) 2014年 anyfish. All rights reserved.
//

#import "AFFNumericKeyboardDtmf.h"

#define kLineWidth 0.6
#define kNumFont [UIFont systemFontOfSize:27]
@implementation AFFNumericKeyboardDtmf

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = CGRectMake(0, 0, kWIDTH, kHEIGHT);
        
        arrLetter = [NSArray arrayWithObjects:@"ABC",@"DEF",@"GHI",@"JKL",@"MNO",@"PQRS",@"TUV",@"WXYZ", nil];
        for (int i=0; i<4; i++)
        {
            for (int j=0; j<3; j++)
            {
                UIButton *button = [self creatButtonWithX:i Y:j];
                [self addSubview:button];
            }
        }
        
        UIColor *color = [UIColor colorWithRed:188/255.0 green:192/255.0 blue:199/255.0 alpha:1];
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake((kWIDTH-2*kLineWidth)/3, 0, kLineWidth, 216)];
        line1.backgroundColor = color;
        
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake((kWIDTH-2*kLineWidth)/3*2+kLineWidth, 0, kLineWidth, 216)];
        line2.backgroundColor = color;
        [self addSubview:line2];
        
        for (int i=0; i<=3; i++)
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54*i, kWIDTH, kLineWidth)];
            line.backgroundColor = color;
            [self addSubview:line];
        }
    }
    return self;
}

-(UIButton *)creatButtonWithX:(NSInteger) x Y:(NSInteger) y
{
    UIButton *button = [[UIButton alloc]init];
    CGFloat frameX;
    CGFloat frameW;
    switch (y)
    {
        case 0:
            frameX = 0.0;
            frameW = (kWIDTH-2*kLineWidth)/3+kLineWidth;
            break;
        case 1:
            frameX = (kWIDTH-2*kLineWidth)/3+kLineWidth;
            frameW = (kWIDTH-2*kLineWidth)/3+kLineWidth;
            break;
        case 2:
            frameX = (kWIDTH-2*kLineWidth)/3*2+2*kLineWidth;
            frameW = (kWIDTH-2*kLineWidth)/3+kLineWidth;
            break;
            
        default:
            break;
    }
    CGFloat frameY = 54*x;
    
    button.frame = CGRectMake(frameX, frameY, frameW, 54);
    NSInteger num = y+3*x+1;
    button.tag = num;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIColor *colorNormal = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    UIColor *colorHightlighted = [UIColor colorWithRed:186.0/255 green:189.0/255 blue:194.0/255 alpha:1.0];
    
    button.backgroundColor = colorNormal;
    CGSize imageSize = CGSizeMake(frameW, 54);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [colorHightlighted set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [button setImage:pressedColorImg forState:UIControlStateHighlighted];
    
    if (num<10)
    {
        UILabel *labelNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frameW, 54)];
        labelNum.text = [NSString stringWithFormat:@"%ld",(long)num];
        labelNum.textColor = [UIColor blackColor];
        labelNum.textAlignment = NSTextAlignmentCenter;
        labelNum.font = kNumFont;
        [button addSubview:labelNum];
        if (num != 1)
        {
            UILabel *labelLetter = [[UILabel alloc] initWithFrame:CGRectMake(frameW/2+8, 27, frameW/2-8, 10)];
            labelLetter.text = [arrLetter objectAtIndex:num-2];
            labelLetter.textColor = [UIColor grayColor];
            labelLetter.textAlignment = NSTextAlignmentLeft;
            labelLetter.font = [UIFont systemFontOfSize:10];
            [button addSubview:labelLetter];
        }
    }
    else if (num == 11)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        label.text = @"0";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kNumFont;
        [button addSubview:label];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(frameW/2+8, 27, frameW/2-8, 10)];
        label2.text = @"+";
        label2.textColor = [UIColor grayColor];
        label2.textAlignment = NSTextAlignmentLeft;
        label2.font = [UIFont systemFontOfSize:16];
        [button addSubview:label2];
    }
    else if (num == 10)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, frameW, 34)];
        label.text = @"*";
        label.font = [UIFont systemFontOfSize:50];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
    }
    else
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, frameW, 17)];
        label.text = @"#";
        label.font = kNumFont;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
    }
    
    return button;
}


-(void)clickButton:(UIButton *)sender
{
    NSString *numStr;
    if (sender.tag == 10)
    {
        str = [NSString stringWithFormat:@"dtmf-star"];
        numStr = @"*";
    }
    else if(sender.tag == 12)
    {
        
        str = [NSString stringWithFormat:@"dtmf-pound"];
        numStr = @"#";
        NSLog(@"这里面有没有走？");
    }
    else
    {
        long num = sender.tag;
        numStr = [@(num) stringValue];
        if (sender.tag == 11)
        {
            num = 0;
            numStr = @"0";
        }
        
        str = [NSString stringWithFormat:@"dtmf-%ld", (long)num];
        
    }
    [self.delegate numberKeyboardInput:numStr];
    NSLog(@"正在通话中的按键：numstr == %@",numStr);
}
@end
