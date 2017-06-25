//
//  SaveUserInfo.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/6/25.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "SaveUserInfo.h"

@implementation SaveUserInfo


+(void)SaveInfo:(NSDictionary *)userDic{
    
}


+(void)DelInfo{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERNAME"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PASSWORD"];
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zidongdenglu"];
}

@end


