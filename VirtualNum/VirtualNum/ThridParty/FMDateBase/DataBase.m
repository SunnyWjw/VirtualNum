//
//  DataBase.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/2.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "DataBase.h"


static DataBase *_DBCtl = nil;


@interface DataBase()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
    
}

@end



@implementation DataBase



+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[DataBase alloc] init];
        
        [_DBCtl initDataBase];
        
    }
    
    return _DBCtl;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [super allocWithZone:zone];
        
    }
    
    return _DBCtl;
    
}

-(id)copy{
    
    return self;
    
}

-(id)mutableCopy{
    
    return self;
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    return self;
    
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    return self;
    
}


-(void)initDataBase{
    // 获得Documents目录路径
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"CallLog.sqlite"];
    
    // 实例化FMDataBase对象
    
    _db = [FMDatabase databaseWithPath:filePath];
    
    
    
    if ([self isExistTable:@"CallLog"] == 0) {
        // 初始化数据表
        NSString *callLogSql = @"CREATE TABLE 'CallLog' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'calledName' VARCHAR(255),'CallingName' VARCHAR(255),'CallPhoneNum' VARCHAR(255),'XNum' VARCHAR(32),'randomNum' VARCHAR(128),'durationTime' VARCHAR(32),'serviceType' varchar(10),generateTime DATETIME,'generatorPersonnel' VARCHAR(255)) ";
        [_db open];
        [_db executeUpdate:callLogSql];
        [_db close];
    }
    
    
    
}

- (int)isExistTable:(NSString *)tableName
{
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"CallLog.sqlite"];
    NSString *name =nil;
    int isExistTable =0;
    FMDatabase *db = [FMDatabase databaseWithPath:filePath];
    if ([db open]) {
        NSString * sql = [[NSString alloc]initWithFormat:@"select name from sqlite_master where type = 'table' and name = '%@'",tableName];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            name = [rs stringForColumn:@"name"];
            
            if ([name isEqualToString:tableName])
            {
                isExistTable =1;
            }
        }
        [db close];
    }
    return isExistTable;
}



/**
 *  添加callLog
 *
 */
- (void)addCallLog:(CallLog *)callLog{
    [_db open];
    
    //    NSNumber *maxID = @(0);
    //
    //    FMResultSet *res = [_db executeQuery:@"SELECT * FROM CallLog "];
    //    //获取数据库中最大的ID
    //    while ([res next]) {
    //        if ([maxID integerValue] < [[res stringForColumn:@"person_id"] integerValue]) {
    //            maxID = @([[res stringForColumn:@"person_id"] integerValue] ) ;
    //        }
    //
    //    }
    //    maxID = @([maxID integerValue] + 1);
    
    
    [_db executeUpdate:@"INSERT INTO CallLog(calledName,CallingName,CallPhoneNum,XNum,randomNum,durationTime,serviceType,generateTime,generatorPersonnel)VALUES(?,?,?,?,?,?,?,datetime('now','+8 hour') ,?)",callLog.calledName,callLog.CallingName,callLog.CallPhoneNum,callLog.XNum,callLog.randomNum,callLog.durationTime,callLog.serviceType,callLog.generatorPersonnel];
    
    
    
    [_db close];
}
/**
 *  删除callLog
 *
 */
- (void)deleteCallLog:(CallLog *)callLog{
    
}
/**
 *  更新callLog
 *
 */
- (void)updateCallLog:(CallLog *)callLog{
    [_db open];
    
    [_db executeUpdate:@"UPDATE 'CallLog' SET durationTime = ?  WHERE randomNum = ? ",callLog.durationTime,callLog.randomNum];
    
    [_db close];
}

/**
 *  获取所有数据
 *
 */
- (NSMutableArray *)getAllCallLog{
    [_db open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT strftime('%H:%M:%S',generateTime) as CreateTime,count(CallPhoneNum)as CallCount,* FROM CallLog GROUP BY CallPhoneNum order by generateTime desc"];
    
    while ([res next]) {
        CallLog *callLog = [[CallLog alloc] init];
        callLog.ID =@([[res stringForColumn:@"id"] integerValue]);
        callLog.calledName=[res stringForColumn:@"calledName"];
        callLog.CallingName=[res stringForColumn:@"CallingName"];
        callLog.CallPhoneNum=[res stringForColumn:@"CallPhoneNum"];
        callLog.XNum=[res stringForColumn:@"XNum"];
        callLog.randomNum=[res stringForColumn:@"randomNum"];
        callLog.durationTime=[res stringForColumn:@"durationTime"];
        callLog.serviceType=[res stringForColumn:@"serviceType"];
        callLog.generateTime=[res stringForColumn:@"CreateTime"];
        callLog.generatorPersonnel=[res stringForColumn:@"generatorPersonnel"];
        callLog.callCount =[res stringForColumn:@"CallCount"];
        
        [dataArray addObject:callLog];
        
    }
    
    [_db close];
    
    return dataArray;
}


/**
 获取前多少条数据
 
 @param howMuch 需要获取的条数
 @return 返回前多少条记录
 */
- (NSMutableArray *)getTopNumCallLog:(NSNumber *)howMuch {
    [_db open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *querySql = [NSString stringWithFormat:@" limit 0,%@",howMuch];
    
    NSString *tempA = @"SELECT strftime('%H:%M:%S',generateTime) as CreateTime,count(CallPhoneNum)as CallCount,* FROM CallLog GROUP BY CallPhoneNum order by generateTime desc ";
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"%@%@",tempA,querySql]];
    
    while ([res next]) {
        CallLog *callLog = [[CallLog alloc] init];
        callLog.ID =@([[res stringForColumn:@"id"] integerValue]);
        callLog.calledName=[res stringForColumn:@"calledName"];
        callLog.CallingName=[res stringForColumn:@"CallingName"];
        callLog.CallPhoneNum=[res stringForColumn:@"CallPhoneNum"];
        callLog.XNum=[res stringForColumn:@"XNum"];
        callLog.randomNum=[res stringForColumn:@"randomNum"];
        callLog.durationTime=[res stringForColumn:@"durationTime"];
        callLog.serviceType=[res stringForColumn:@"serviceType"];
        callLog.generateTime=[res stringForColumn:@"CreateTime"];
        callLog.generatorPersonnel=[res stringForColumn:@"generatorPersonnel"];
        callLog.callCount =[res stringForColumn:@"CallCount"];
        
        [dataArray addObject:callLog];
        
    }
    
    [_db close];
    
    return dataArray;
}


- (NSMutableArray *)queryAllCallLog:(NSString *)CallPhoneNum XNum:(NSString *)xNum TopNumber:(NSString *)howMuch{
    [_db open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSString *querySql = @"";
    if (howMuch.length > 0) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *numTemp = [numberFormatter numberFromString:howMuch];
        querySql = [NSString stringWithFormat:@" CallPhoneNum = '%@' and generatorPersonnel = '%@' order by generateTime desc limit 0,%@",CallPhoneNum,xNum,numTemp];
     
    }else{
        querySql = [NSString stringWithFormat:@" CallPhoneNum = '%@' and generatorPersonnel = '%@' order by generateTime desc",CallPhoneNum,xNum];
    }
    NSString *tempA = @"SELECT strftime('%H:%M:%S',generateTime) as CreateTime,* FROM CallLog where";
  
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"%@%@",tempA,querySql]];
    while ([res next]) {
        CallLog *callLog = [[CallLog alloc] init];
        callLog.ID =@([[res stringForColumn:@"id"] integerValue]);
        callLog.calledName=[res stringForColumn:@"calledName"];
        callLog.CallingName=[res stringForColumn:@"CallingName"];
        callLog.CallPhoneNum=[res stringForColumn:@"CallPhoneNum"];
        callLog.XNum=[res stringForColumn:@"XNum"];
        callLog.randomNum=[res stringForColumn:@"randomNum"];
        callLog.durationTime=[res stringForColumn:@"durationTime"];
        callLog.serviceType=[res stringForColumn:@"serviceType"];
        callLog.generateTime=[res stringForColumn:@"generateTime"];
        callLog.generatorPersonnel=[res stringForColumn:@"generatorPersonnel"];
        
        [dataArray addObject:callLog];
        
    }
    
   
    
    [_db close];
    
    return dataArray;
}

@end
