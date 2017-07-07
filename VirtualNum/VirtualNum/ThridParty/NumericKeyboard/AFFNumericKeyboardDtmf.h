//
//  CustomKeyboard.h
//  keyboard
//
//  Created by zhaowang on 14-3-25.
//  Copyright (c) 2014年 anyfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol AFFNumericKeyboardDtmfDelegate <NSObject>

- (void) numberKeyboardInput:(NSString*) number;
//- (void) numberKeyboardBackspace:(BOOL)sender;


@end

@interface AFFNumericKeyboardDtmf : UIView
{
    NSArray *arrLetter;
    NSString *str;
}

@property (nonatomic,assign) id<AFFNumericKeyboardDtmfDelegate> delegate;

@end
