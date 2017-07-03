//
//  CallLog.h
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/2.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CallLog : NSObject

@property(nonatomic,strong) NSNumber *ID;
/*
 被叫方
 */
@property(nonatomic,copy) NSString *calledName;
/*
 当前呼叫人
 */
@property(nonatomic,copy) NSString *CallingName;
/*
 被叫方号码
 */
@property(nonatomic,copy) NSString *CallPhoneNum;
/*
 X号码
 */
@property(nonatomic,copy) NSNumber *XNum;
/*
 随机数
 */
@property(nonatomic,copy) NSNumber *randomNum;
/*
 通话时长
 */
@property(nonatomic,copy) NSNumber *durationTime;
/*
 服务方式
 */
@property(nonatomic,copy) NSString *serviceType;
/*
 数据生成时间
 */
@property(nonatomic,copy) NSString *generateTime;
/*
 数据创建者
 */
@property(nonatomic,copy) NSString *generatorPersonnel;



@end
