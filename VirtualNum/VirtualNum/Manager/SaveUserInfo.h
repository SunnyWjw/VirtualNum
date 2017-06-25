//
//  SaveUserInfo.h
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/25.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveUserInfo : NSObject

#pragma mark ————— 保存/删除用户信息 —————
+(void)SaveInfo:(NSDictionary *)userDic;

+(void)DelInfo;

@end
