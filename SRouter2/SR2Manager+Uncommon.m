//
//  SR2Manager+Uncommon.m
//  SRouter2Demo
//
//  Created by cs on 17/3/2.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SR2Manager+Uncommon.h"
#import "SR2Macro.h"

@implementation SR2Manager (Uncommon)

+ (BOOL)router_RegisteBlock:(SR2BlockHandler)block name:(NSString *)keyName
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2RegisteBlock];
    subParams.params = @{keySR2_Param_Target:keyName, keySR2_Param_Block:block};
    
    [self router_handleMsg:SR2HandleRegiste params:subParams from:SR2CmdFromLocal];
    
    return YES;
}

+ (BOOL)router_RegisteProtocol:(Protocol *)keyProtocol withInstance:(id)inst
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2RegisteBlock];
    subParams.params = @{keySR2_Param_Target:inst, keySR2_Param_Protocol:keyProtocol};
    
    [self router_handleMsg:SR2HandleRegiste params:subParams from:SR2CmdFromLocal];
    
    return YES;
}

+ (id)router_QueryProtocol:(Protocol *)protocol
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2QueryProtocol];
    subParams.params = @{keySR2_Param_Target:protocol};
    
    return [self router_handleMsg:SR2HandleQuery params:subParams from:SR2CmdFromLocal];
}

+ (id)router_QueryBlock:(NSString *)key
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2QueryBlock];
    subParams.params = @{keySR2_Param_Target:key};
    
    return [self router_handleMsg:SR2HandleQuery params:subParams from:SR2CmdFromLocal];
}

#pragma mark - 反注册
+ (void)router_UnregisteBlock:(NSString *)keyName
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2UnregisteBlock];
    subParams.params = @{keySR2_Param_Target:keyName};
    
    [self router_handleMsg:SR2HandleUnregiste params:subParams from:SR2CmdFromLocal];
}

+ (void)router_UnregisteProtocol:(Protocol *)protocol
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2UnregisteProtocol];
    subParams.params = @{keySR2_Param_Protocol:protocol};
    
    [self router_handleMsg:SR2HandleUnregiste params:subParams from:SR2CmdFromLocal];
}

@end
