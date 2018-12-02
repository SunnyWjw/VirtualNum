//
//  SWNumericKeyboard.h
//  ADIntegral
//
//  Created by SunnyWu on 2018/6/4.
//  Copyright © 2018年 Livecom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol SYNumericKeyboardDelegate <NSObject>


/**
 获取键盘上输入的内容

 @param number 键盘输入的内容
 */
- (void) numberKeyboardInput:(NSString*) number;
/**
 点击了删除
 
 @param number 键盘输入的内容
 */
- (void) numberKeyboardDelete:(NSString*) number;
/**
 点击了呼叫
 */
- (void) BeginCallPhone;

/**
 进行呼叫设置模块
 */
-(void) GoSettingModule;



@end

@interface SWNumericKeyboard : UIView
{
    NSArray *arrLetter;
    SystemSoundID sound;  //系统声音的id 取值范围为：1000-2000
    NSString *str;
}

@property (nonatomic,assign) id<SYNumericKeyboardDelegate> delegate;
@property (nonatomic,assign) BOOL PlaySound;

@end
