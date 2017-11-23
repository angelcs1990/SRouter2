//
//  SR2ErrorHandler.m
//  SRouter2Demo
//
//  Created by cs on 17/3/6.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SR2ErrorHandler.h"
#import "SR2Context.h"
#import "SR2Config.h"
#import "SR2ModuleProtocol.h"

@implementation SR2ErrorHandler

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static SR2ErrorHandler *errHandler = nil;
    dispatch_once(&onceToken, ^{
        errHandler = [[self class] new];
    });
    
    return errHandler;
}

+ (id)sendErrorCmd:(SR2ModuleErrorCmds)cmd target:(id)target
{
    id ret = nil;
    if ([SR2Config shareInstance].openModuleErrorHandle) {
        if (target && [target conformsToProtocol:@protocol(SR2ModuleProtocol)]) {
            SR2Params *tmpParams = [SR2Params parmasWithCmd:SR2ModuleErrorHandle];
            tmpParams.subCmd = [SR2Params parmasWithCmd:cmd];
            ret = [target command:tmpParams];
        }
        
        if (ret == nil) {
            if ([SR2ErrorHandler shareInstance].delegate) {
                ret = [[SR2ErrorHandler shareInstance].delegate router_ErrorHandleCmd:cmd target:target];
            }
        }
        
        return ret;
    }
    
    return nil;
}

@end
