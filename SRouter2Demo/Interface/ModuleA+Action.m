//
//  ModuleA+Action.m
//  SRouter2Demo
//
//  Created by cs on 16/12/28.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "ModuleA+Action.h"

@implementation SR2Manager (ModuleA)

+ (void)ModulaA_showToast:(UIView *)view withMsg:(NSString *)msg
{
    [SR2Manager router_TellModuleMessage:@"ModuleA" withCmd:ModuleA_ShowToast withParams:@{keySR2_Param_Cmd:@(ErrModuleSystem), keySR2_Param_Target:view, keySR2_Param_Params:msg}];
}

//-(void)moduleA_showAlertWithMessage:(nonnull NSString *)message
//                       cancelAction:(void(^__nullable)(NSDictionary *__nonnull info))cancelAction
//                      confirmAction:(void(^__nullable)(NSDictionary *__nonnull info))confirmAction{
//    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        if (cancelAction) {
//            cancelAction(@{@"alertAction":action});
//        }
//    }];
//    
//    UIAlertAction *confirmAlertAction = [UIAlertAction actionWithTitle:@"confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if (confirmAction) {
//            confirmAction(@{@"alertAction":action});
//        }
//    }];
//    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"alert from Module A" message:message preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:cancelAlertAction];
//    [alertController addAction:confirmAlertAction];
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
//}

@end
