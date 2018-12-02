//
//  SWNumericKeyboard.m
//  ADIntegral
//
//  Created by SunnyWu on 2018/6/4.
//  Copyright © 2018年 Livecom. All rights reserved.
//

#import "SWNumericKeyboard.h"

#define kLineWidth 0.6
#define kNumFont [UIFont systemFontOfSize:27]
#define kDetailFont [UIFont systemFontOfSize:10]
#define klineViewHeight 270



@implementation SWNumericKeyboard




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.bounds = CGRectMake(0, 0, kWIDTH, kHEIGHT);
        self.frame = frame;
        arrLetter = [NSArray arrayWithObjects:@"ABC",@"DEF",@"GHI",@"JKL",@"MNO",@"PQRS",@"TUV",@"WXYZ", nil];
        for (int i=0; i<5; i++)
        {
            for (int j=0; j<3; j++)
            {
                UIButton *button = [self creatButtonWithX:i Y:j];
                [self addSubview:button];
            }
        }
        
        UIColor *color = [UIColor colorWithRed:188/255.0 green:192/255.0 blue:199/255.0 alpha:1];
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake((kWIDTH-2*kLineWidth)/3, 0, kLineWidth, klineViewHeight)];
        line1.backgroundColor = color;
        
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake((kWIDTH-2*kLineWidth)/3*2+kLineWidth, 0, kLineWidth, klineViewHeight)];
        line2.backgroundColor = color;
        [self addSubview:line2];
        
        for (int i=0; i<=4; i++)
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
    UIButton *button;
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
            frameX = 0.0;
            frameW = 0.0;
            break;
    }
    CGFloat frameY = 54*x;
    
    //点击数字
    button = [[UIButton alloc] initWithFrame:CGRectMake(frameX, frameY, frameW, 54)];
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
            labelLetter.font = kDetailFont;
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
        label2.font = kDetailFont;
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
    else if (num == 12)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, frameW, 28)];
        label.text = @"#";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kNumFont;
        [button addSubview:label];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(frameW/2+8, 27, frameW/2-8, 10)];
        label2.text = @"粘贴";
        label2.textColor = [UIColor grayColor];
        label2.textAlignment = NSTextAlignmentLeft;
        label2.font = kDetailFont;
        [button addSubview:label2];
        
        //添加一个长按的手势，用于粘贴功能
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        //长手势识别成功所需要的时间
        longPress.minimumPressDuration = 1.0;
        [button addGestureRecognizer:longPress];
    }else if (num == 13)
    {
        [button setImage:[UIImage imageNamed:@"dial-more_50x50"] forState:UIControlStateNormal];
    }
    else if (num == 14)
    {
        [button setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"btn_delet_select"] forState:UIControlStateNormal];
        // 单击的 Recognizer
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletSingleTap:)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        //给rightCallButton添加一个手势监测；
        [button addGestureRecognizer:singleRecognizer];
        // 双击的 Recognizer
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deletLongPress:)];
        //关键语句，给rightCallButton添加一个手势监测；
        [button addGestureRecognizer:longPress];
    }
    
    return button;
}

-(void)clickButton:(UIButton *)sender
{
    NSString *numStr;
    if (sender.tag < 10) {
        long num = sender.tag;
        numStr = [@(num) stringValue];
        str = [NSString stringWithFormat:@"dtmf-%ld", (long)num];
        [self playSystemSoundWithName:str SoundType:@"caf"];
        if (![numStr  isEqual: @""]) {
            [self.delegate numberKeyboardInput:numStr];
        }
        
    }else if (sender.tag == 10)
    {
        //[self.delegate changeKeyboardType];
        str = [NSString stringWithFormat:@"dtmf-star"];
        [self playSystemSoundWithName:str SoundType:@"caf"];
        numStr = @"*";
        if (![numStr  isEqual: @""]) {
            [self.delegate numberKeyboardInput:numStr];
        }
    }
    else if (sender.tag == 11)
    {
        //[self.delegate changeKeyboardType];
        long num = 0;
        str = [NSString stringWithFormat:@"dtmf-%ld", (long)num];
        [self playSystemSoundWithName:str SoundType:@"caf"];
        numStr = @"0";
        if (![numStr  isEqual: @""]) {
            [self.delegate numberKeyboardInput:numStr];
        }
    }
    else if(sender.tag == 12)
    {
        //[self.delegate numberKeyboardBackspace];
        str = [NSString stringWithFormat:@"dtmf-pound"];
        [self playSystemSoundWithName:str SoundType:@"caf"];
        
        numStr = @"#";
        if (![numStr  isEqual: @""]) {
            [self.delegate numberKeyboardInput:numStr];
        }
    }
    else if(sender.tag == 13)
    {
        //进入功能模块
        [self.delegate GoSettingModule];
    }
    else if(sender.tag == 14)
    {
        //点击了呼叫
        [self.delegate BeginCallPhone];
    }else{
        //删除
    }
}

- (void)longPress:(UILongPressGestureRecognizer*)recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        NSString *numStr;
        //剪贴板
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSString * string = pasteboard.string;
        string = [string stringByReplacingOccurrencesOfString:@"+" withString:@"00"];
        string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *straaa =[self onlyWrite:string ContentStr:kNumbers];
        if ([straaa isEqualToString:@""] || straaa.length == 0) {
            numStr = @"";
        }
        else
        {
            numStr = straaa;
        }
        if (![numStr  isEqual: @""]) {
            [self.delegate numberKeyboardInput:numStr];
        }
    }
}

- (void)deletSingleTap:(UITapGestureRecognizer*)recognizer
{
    [self.delegate numberKeyboardDelete:@"1"];
}
- (void)deletLongPress:(UILongPressGestureRecognizer*)recognizer
{
    [self.delegate numberKeyboardDelete:@"2"];
}

#pragma mark -- 播放键盘音
- (void)playSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType
{
    NSString *playSystemSound = [[NSUserDefaults standardUserDefaults] objectForKey:PLANSYSTEMSOUND];
    if(playSystemSound.length == 0){
        self.PlaySound = YES;
    }else{
        if ([playSystemSound isEqualToString:@"YES"]) {
            self.PlaySound = YES;
        }else{
            self.PlaySound = NO;
        }
    }
    if (self.PlaySound) {
        
        if (![[NSString iphoneType] isEqualToString:@"iPhone Simulator"]) {
            NSString *path= @"";
            if (IOS10_OR_LATER) {
                path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/nano/%@.%@",soundName,soundType];
            }else{
                path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
            }
            
            //音效声音的唯一标示ID
            SystemSoundID soundID = 0;
            if (path) {
                OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
                if (error == kAudioServicesNoError) {
                    //开始播放音效
                    AudioServicesPlaySystemSound(soundID);
                }
            }
        }
    }
}

#pragma mark 限制输入内容
//限制输入内容
- (BOOL)onlyWrite:(NSString *)string contentStr:(NSString *)contenStr
{
    NSCharacterSet *cs;
    
    cs = [[NSCharacterSet characterSetWithCharactersInString:contenStr] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL basic = [string isEqualToString:filtered];
    
    return basic;
}

- (NSString *)onlyWrite:(NSString *)string  ContentStr:(NSString *)contenStr
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:contenStr] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return filtered;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
