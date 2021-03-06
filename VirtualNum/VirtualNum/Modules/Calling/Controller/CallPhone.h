//
//  CallPhone.h
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/2.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPPersonModel.h"

typedef void(^CallResponeBlcok) (NSDictionary * tempJSON,NSString * model,NSString * XNum);//1

@interface CallPhone : NSObject

//@property (nonatomic,copy)CallResponeBlcok callPhonekBlcok;//2

+(instancetype)allocWithZone:(struct _NSZone *)zone;//单例


- (void) sendCallRequestForBindAXB:(NSString *)phoneNum ContactName:(NSString *)contactName
                Respone:( CallResponeBlcok )respone;

/**
 激活Transecation进行呼叫
 */
- (void) sendCallRequestToActivationTran:(NSString *)transid;

/**
 解绑transID
 */
-(void)unBindTrans:(NSString *)oldTrans;

/**
 激活transID

 @param transidStr 
 */
-(void)RequestToActivationTran:(NSString *)transid;

- (void) DelBindAXB:(NSDictionary *)dic Respone:( CallResponeBlcok )respone;


@end
