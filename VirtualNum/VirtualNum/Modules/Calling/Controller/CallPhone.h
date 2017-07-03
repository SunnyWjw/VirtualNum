//
//  CallPhone.h
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/2.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PPPersonModel.h"

@interface CallPhone : NSObject

+(void) sendCallRequest:(NSString *)phoneNum ContactName:(NSString *)contactName;

@end
