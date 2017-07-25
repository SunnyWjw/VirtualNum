//
//  UIAlertController+PPPersonModel.m
//  VirtualNum
//
//  Created by SunnyWu on 2017/7/2.
//  Copyright © 2017年 SunnyWu. All rights reserved.
//

#import "UIAlertController+PPPersonModel.h"
#import "CallPhone.h"
#import "ChooseTransidViewController.h"

@implementation UIAlertController (PPPersonModel)

#pragma mark - public function
+(instancetype)alertControllerWithContactObject:(PPPersonModel *)contactObject ViewController:(UIViewController *)viewController
{
    
    //Set initailtal value
    NSString * title = nil;
    UIAlertControllerStyle style = UIAlertControllerStyleAlert;
    
    if (contactObject.mobileArray.count ==0)//没有phone
    {
        title = [NSString stringWithFormat:@"%@没有电话号码",contactObject.name];
    }
    
    else if(contactObject.mobileArray.count == 1)//只有一个phone
    {
        title = [NSString stringWithFormat:@"%@只有一个电话号码:%@",contactObject.name,contactObject.mobileArray.firstObject];
    }
    
    else//多个phone
    {
        title = [NSString stringWithFormat:@"%@有%@个电话号码",contactObject.name,@(contactObject.mobileArray.count)];
        style = UIAlertControllerStyleActionSheet;
        
    }
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:style];
    
    if (contactObject.mobileArray.count > 1)
    {
        [self __addSheetAction:alertController Phones:contactObject.mobileArray ContactName:contactObject.name ViewController:viewController];
    }
    
    else if (contactObject.mobileArray.count == 0){
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
    }
    
    else
    {
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
    }
    
    return alertController;
}


#pragma mark - private fucntion
+ (void)__addSheetAction:(UIAlertController *)alertController Phones:(NSMutableArray<PPPersonModel *> *)phones ContactName:(NSString *)name  ViewController:(UIViewController *)viewController
{

    for (int i= 0; i<phones.count; i++) {
        UIAlertAction * action = [UIAlertAction actionWithTitle:[phones objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
//            [CallPhone sendCallRequest:action.title ContactName:name ViewController:self];
            CallPhone *callphone = [[CallPhone alloc] init];
            [callphone sendCallRequest:action.title ContactName:name  Respone:^(NSDictionary *tempJSON, NSString *model, NSString *XNum) {
                NSString *successstr = [NSString stringWithFormat:@"%@", tempJSON[@"success"]];
                if ([successstr isEqualToString:@"1"]) {
                    if ([model isEqualToString:@"dual"]) {
                        
                        ChooseTransidViewController *ctVC = [[ChooseTransidViewController alloc] init];
                        [viewController.navigationController pushViewController:ctVC animated:YES];
                         /*
                         [callphone sendCallRequestToActivationTran];
                          */
                    }else{
                        XNum = [NSString stringWithFormat:@"%@%@",VN_CALLPREFIX,XNum];
                        NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel://%@",XNum];
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
                    }
                }else{
                    [MBProgressHUD showErrorMessage:tempJSON[@"message"]];
                }
            }];
        }];
        
        [alertController addAction:action];
    }
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alertController addAction:action];
}




@end
