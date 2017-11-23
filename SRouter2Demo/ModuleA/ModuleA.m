//
//  ModuleA.m
//  SRouter2Demo
//
//  Created by cs on 16/12/28.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "ModuleA.h"
#import "UIView+Toast.h"
#import "ModuleA+Action.h"
@implementation ModuleA
- (void)dealloc
{
    NSLog(@"dealloc");
}
#pragma mark - SR2ModuleProtocol
+ (id)SR2Module_ClassCommand:(SR2Params *)params stop:(BOOL *)stop
{
    switch (params.cmd) {
        case ModuleA_ShowImg:
        {
            
        }
            break;
        case ModuleA_ShowAlert:
        {}
            break;
        case ModuleA_ShowToast:
        {
            NSInteger subCmd = [[params.params objectForKey:keySR2_Param_Cmd] integerValue];
            
            [self disposeErrMessage:params.params withType:subCmd];
            *stop = YES;
        }
            break;
        default:
            break;
    }
    
    return nil;
}
- (id)SR2Module_Command:(SR2Params *)params
{
    switch (params.cmd) {
        case ModuleA_ShowImg:
        {
            
        }
            break;
        case ModuleA_ShowAlert:
        {}
            break;
        case ModuleA_ShowToast:
        {
            NSInteger subCmd = [[params.params objectForKey:keySR2_Param_Cmd] integerValue];
            
            [ModuleA disposeErrMessage:params.params withType:subCmd];
        }
            break;
        default:
            break;
    }

    return nil;
}


+ (void)disposeErrMessage:(NSDictionary *)dict withType:(ErrModuleType)type
{
    id obj = [dict objectForKey:keySR2_Param_Target];
    NSString *msg = [dict objectForKey:keySR2_Param_Params];
    switch (type) {
        case ErrModuleSystem:
        {
            NSString *msgAdd = [NSString stringWithFormat:@"system :%@", msg];
            [self showToast:obj withMsg:msgAdd];
        }
            break;
        case ErrModuleUser:
        {
            NSString *msgAdd = [NSString stringWithFormat:@"user :%@", msg];
            [self showToast:obj withMsg:msgAdd];
        }
            break;
        default:
            break;
    }
}

+ (void)showToast:(id)widget withMsg:(NSString *)msg
{
    if ([widget isKindOfClass:[UIView class]]) {
        [widget makeToast:msg];
    }
}

@end
