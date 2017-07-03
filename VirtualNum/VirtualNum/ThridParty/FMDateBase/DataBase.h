//
//  DataBase.h
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/2.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDB.h>
#import "CallLog.h"
@class CallLog;


@interface DataBase : NSObject

@property(nonatomic,strong) CallLog *callLog;


+ (instancetype)sharedDataBase;



#pragma mark - Person
/**
 *  添加callLog
 *
 */
- (void)addCallLog:(CallLog *)callLog;
/**
 *  删除callLog
 *
 */
- (void)deleteCallLog:(CallLog *)callLog;
/**
 *  更新callLog
 *
 */
- (void)updateCallLog:(CallLog *)callLog;

/**
 *  获取所有数据
 *
 */
- (NSMutableArray *)getAllCallLog;

/**
 获取前多少条数据
 
 @param howMuch 需要获取的条数
 @return 返回前多少条记录
 */
- (NSMutableArray *)getTopNumCallLog:(NSNumber *)howMuch;

@end
