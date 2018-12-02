//
//  NSArray+MyLog.m
//  VirtualNum
//
//  Created by SunnyWu on 2018/1/7.
//  Copyright © 2018年 SunnyWu. All rights reserved.
//

#import "NSArray+MyLog.h"

@implementation NSArray (MyLog)


- (NSString*)descriptionWithLocale:(id)locale {
    
    NSMutableString *str = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL*stop) {
        
        [str appendFormat:@"\t%@,\n", obj];
        
    }];
    
    [str appendString:@")"];
    
    return str;
    
}

@end

@implementation NSDictionary (MyLog)

- (NSString*)descriptionWithLocale:(id)locale {
    
    NSMutableString * str = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key,id obj,BOOL *stop) {
        
        [str appendFormat:@"\t%@ = %@;\n", key, obj];
        
    }];
    
    [str appendString:@"}\n"];
    
    return str;
    
}

@end

