//
//  UIAlertController+PPPersonModel.h
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/2.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPersonModel.h"

@interface UIAlertController (PPPersonModel)


/**
 根据RITLContactObject初始化AlertController
 
 @param contactObject RITLContactObject对象
 
 @return 创建好的UIAlertController对象
 */
+(instancetype)alertControllerWithContactObject:(PPPersonModel *)contactObject;



@end
