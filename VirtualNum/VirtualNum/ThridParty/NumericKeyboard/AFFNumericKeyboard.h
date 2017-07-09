//
//  CustomKeyboard.h
//  keyboard
//
//  Created by zhaowang on 14-3-25.
//  Copyright (c) 2014年 anyfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol AFFNumericKeyboardDelegate <NSObject>

- (void) numberKeyboardInput:(NSString*) number;
//- (void) numberKeyboardBackspace:(BOOL)sender;
//- (void) changeKeyboardType;

@end

@interface AFFNumericKeyboard : UIView
{
    NSArray *arrLetter;
    SystemSoundID sound;  //系统声音的id 取值范围为：1000-2000
    NSString *str;
}

@property (nonatomic,assign) id<AFFNumericKeyboardDelegate> delegate;

@end
