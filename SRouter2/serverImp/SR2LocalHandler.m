//
//  SR2LocalHandler.m
//  SRouter2Demo
//
//  Created by cs on 16/12/24.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SR2LocalHandler.h"
#import "SR2Context.h"
#import "SR2Launcher.h"
#import "SR2Cache.h"
#import "SR2Macro.h"
#import "SR2ServerCommands.h"
#import "SR2ModuleProtocol.h"
#import "SR2ModuleCommands.h"
#import "SR2SubscribedMsgMgr.h"
#import <UIKit/UIKit.h>
#import "SR2Manager+Extension.h"
#import "NSObject+SRouter2.h"

@implementation SR2LocalHandler

- (id)handleCommand:(SR2HandleContext *)context
{
    switch (context.cmd) {
        case SR2HandleJump:
        {
            return [self handleJump:context.params];
        }
            break;
        case SR2HandleQuery:
        {
            return [self handleQuery:context.params];
        }
            break;
        case SR2HandleRegiste:
        {
            return [self handleRegiste:context.params];
        }
            break;
        case SR2HandleSubscribe:
        {
            [self handleSubscribe:context.params];
        }
            break;
        case SR2HandleUnregiste:
        {
            [self handleUnregiste:context.params];
        }
            break;
        case SR2HandleOther:
        {
            return [self handleOther:context.params];
        }
            break;
        default:
            break;
    }
    
    return nil;
}

#pragma mark - 私有函数（拆解）
- (id)viewControllerCheckTarget:(id)target
{
    if (![target isKindOfClass:[UIViewController class]]) {
        if ([target conformsToProtocol:@protocol(SR2ModuleProtocol)]) {
            id retValue = [target SR2Module_Command:[SR2Params parmasWithCmd:SR2ModuleQueryInstance]];
            if ([retValue isKindOfClass:[UIViewController class]]) {
                target = retValue;
            } else {
                target = nil;
            }
        }
    }
    
    return target;
}

- (void)passParams:(SR2Params *)context target:(id)target
{
    NSDictionary *paramsDic = [context.params objectForKey:keySR2_Param_Params];
    if (![paramsDic isKindOfClass:[NSNull class]] && (paramsDic != nil || context.block || context.delegate)) {
        SR2Params *passParams = [SR2Params parmasWithCmd:SR2ModulePassParams];
        passParams.params = paramsDic;
        passParams.block = context.block;
        passParams.delegate = context.delegate;
        
        if ([target respondsToSelector:@selector(SR2Module_Command:)])
        {
            [target SR2Module_Command:passParams];
        } else {
            SR2String(info, @"%@:未实现SR2ModuleProtocol协议，无法传参", NSStringFromClass([target class]));
            SR2Log(info);
        }
    }
}

- (id)queryTarget:(id)tmpTarget
{
    id target = nil;
    if ([tmpTarget isKindOfClass:[NSString class]]) {
        target = [[SR2Cache shareInstance] instanceForName:tmpTarget];
        if (target == nil) {
            target = [[NSClassFromString(tmpTarget) alloc] init];
        }
    } else {
        target = tmpTarget;
    }
    
    return target;
}

- (NSString *)targetClassForParams:(SR2Params *)context
{
    id tmpTarget = [context.params objectForKey:keySR2_Param_Target];
    if (tmpTarget == nil) {
        return nil;
    }
    
    NSString *targetClass = nil;
    if ([tmpTarget isKindOfClass:[NSString class]]) {
        targetClass = tmpTarget;
    } else {
        targetClass = NSStringFromClass([tmpTarget class]);
    }
    
    if (targetClass == nil) {
        SR2Log(@"获取不到对象名字");
        return nil;
    }
    
    return targetClass;
}

- (NSString *)checkTargetForContext:(SR2Params *)context byWho:(NSString *)who
{
    if (context.cmd == SR2SubscribNotify) {
        return @"";
    }
    
    NSString *targetClass = [self targetClassForParams:context];
    if (targetClass) {
        BOOL bRet = [[SR2Launcher shareInstance] checkValidWithClassName:targetClass from:SR2CmdFromLocal];
        if (!bRet) {
            SR2String(info, @"(%@)验证没有通过:%@", who, targetClass);
            SR2Log(info);
            return nil;
        }
        
        return targetClass;
    }
    
    return nil;
}

- (UIViewController *)currentViewControllerForContext:(SR2Params *)context
{
    id sourceImp = [context.params objectForKey:keySR2_Param_Source];
    if (sourceImp == nil || ![sourceImp isKindOfClass:[UIViewController class]]) {
        sourceImp = [SR2Manager currentViewController];
    }
    
    if (sourceImp == nil) {
        return nil;
    }
    
    return sourceImp;
}

#pragma mark - 私有处理函数
- (id)handleOther:(SR2Params *)context
{
    switch (context.cmd) {
        case SR2OtherTellMsg:
        {
            NSString *targetClass = [context.params objectForKey:keySR2_Param_Target];
            BOOL bRet = [[SR2Launcher shareInstance] checkValidWithClassName:targetClass from:SR2CmdFromLocal];
            if (!bRet) {
                SR2String(info, @"(handleOther)验证没有通过:%@", targetClass);
                SR2Log(info);
                return nil;
            }
            return [[SR2Launcher shareInstance] tellModuleMessage:targetClass withParams:context.subCmd];
        }
            break;
        case SR2OtherTellAllMsg:
        {
            [[SR2Launcher shareInstance] tellAllModulesMessage:context.subCmd];
        }
            break;
        case SR2OtherPrintServers:
        {
            NSDictionary *servers = [[SR2Cache shareInstance] allServers];
            __block NSUInteger idx = 0;
            [servers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                SR2String(info, @"序号：%ld(%@:%@)", idx, key, obj)
                SR2Log(info);
                idx++;
            }];
        }
            break;
        case SR2OtherPrintSubscribe:
        {
            [[SR2SubscribedMsgMgr shareInstance] printDebug];
        }
        default:
            break;
    }
    
    return nil;
}

- (id)handleUnregiste:(SR2Params *)context
{
    if ([self checkTargetForContext:context byWho:@"handleUnregiste"] == nil) {
        return nil;
    }
    
    switch (context.cmd) {
        case SR2UnregisteBlock:
        {
            NSString *targetClass = [context.params objectForKey:keySR2_Param_Target];
            [[SR2Cache shareInstance] unregisteBlock:targetClass];
        }
            break;
        case SR2UnregisteRules:
        {
            NSString *targetClass = [context.params objectForKey:keySR2_Param_Target];
            [[SR2Cache shareInstance] removeModuleRule:targetClass];
        }
            break;
        case SR2UnregisteServer:
        {
            NSString *targetClass = [context.params objectForKey:keySR2_Param_Target];
            [[SR2Cache shareInstance] unregisteService:targetClass];
        }
            break;
        case SR2UnregisteProtocol:
        {
            Protocol *tmpProtocol = [context.params objectForKey:keySR2_Param_Protocol];
            [[SR2Cache shareInstance] unregisteProtocol:tmpProtocol withInstance:nil];
        }
            break;
        case SR2UnregisteOther:
        default:
            break;
    }
    return nil;
}

- (id)handleQuery:(SR2Params *)context
{
    if ([self checkTargetForContext:context byWho:@"handleQuery"] == nil) {
        return nil;
    }
    
    switch (context.cmd) {
        case SR2QueryObject:
        {
            NSString *targetClass = [context.params objectForKey:keySR2_Param_Target];
            id target = [[SR2Launcher shareInstance] targetForName:targetClass];
            if (target && [target conformsToProtocol:@protocol(SR2ModuleProtocol)]) {
                SR2Params *tmpParams = [SR2Params parmasWithCmd:SR2ModuleQueryInstance];
                tmpParams.params = context.params;
                return [target SR2Module_Command:tmpParams];
            }
        }
            break;
        case SR2QueryServer:
        {
            NSString *targetClass = [context.params objectForKey:keySR2_Param_Target];
            id target = [[SR2Cache shareInstance] instanceForName:targetClass];
            return target;
        }
            break;
        case SR2QueryBlock:
        {
            NSString *targetClass = [context.params objectForKey:keySR2_Param_Target];
            return [[SR2Cache shareInstance] blockForName:targetClass];
        }
            break;
        case SR2QueryProtocol:
        {
            Protocol *targetClass = [context.params objectForKey:keySR2_Param_Target];
            return [[SR2Cache shareInstance] instanceForProtocol:targetClass];
        }
            break;
        case SR2QueryOther:
        default:
            break;
    }
    
    return nil;
}

- (void)handleSubscribe:(SR2Params *)context
{
    NSString *targetClass = [self checkTargetForContext:context byWho:@"handleSubscribe"];
    if (targetClass == nil) {
        return;
    }
    
    switch (context.cmd) {
        case SR2SubscribNotify:
        {
            [[SR2SubscribedMsgMgr shareInstance] notify:context];
        }
            break;
        case SR2SubscribRegiste:
        {
            [[SR2SubscribedMsgMgr shareInstance] subscribMsg:context.subCmd.cmd srcName:targetClass desName:[context.subCmd.params objectForKey:keySR2_Param_Target]  handler:context.block countLimit:[[context.subCmd.params objectForKey:keySR2_Param_Params] integerValue]];
        }
            break;
        case SR2SubscribUnregiste:
        {
            [[SR2SubscribedMsgMgr shareInstance] cancelSubscribMsg:context.subCmd.cmd withName:targetClass];
        }
            break;
        default:
            break;
    }
}

- (id)handleRegiste:(SR2Params *)context
{
    id target = nil;
    BOOL bImp = NO;
    
    NSString *targetClass = [self checkTargetForContext:context byWho:@"handleRegiste"];
    if (targetClass == nil) {
        return nil;
    } else {
        target = [context.params objectForKey:keySR2_Param_Target];
        if (![target isKindOfClass:[NSString class]]) {
            bImp = YES;
        }
    }
    
    
    switch (context.cmd) {
        case SR2RegisteBlock:
        {
            SR2BlockHandler blkHandler = [context.params objectForKey:keySR2_Param_Block];
            [[SR2Cache shareInstance] registeBlock:blkHandler name:targetClass];
        }
            break;
        case SR2RegisteRules:
        {
            [[SR2Launcher shareInstance] loadModulesWithPlist:targetClass];
        }
            break;
        case SR2RegisteProtocl:
        {
            Protocol *tmpProtocol = [context.params objectForKey:keySR2_Param_Protocol];
            [[SR2Cache shareInstance] registeProtocol:tmpProtocol withInstance:target];
        }
            break;
        case SR2RegisteService:
        {
            if (bImp) {
                [[SR2Cache shareInstance] registeServiceImp:target];
            } else {
                id retValue = [[SR2Cache shareInstance] registeService:targetClass];
                if (retValue == nil) {
                    SR2String(info, (targetClass ? @"%@:无法创建该类": @"无效类名%@"), targetClass);
                    SR2Log(info);
                }
                return retValue;
            }
        }
            break;
        case SR2RegisteOther:
        default:
            break;
    }
    return nil;
}

- (id)handleJump:(SR2Params *)context
{
    NSString *targetClass = [self checkTargetForContext:context byWho:@"handleJump"];
    if (targetClass == nil) {
        return nil;
    }
    

    id tmpTarget = [context.params objectForKey:keySR2_Param_Target];
    id target = [self queryTarget:tmpTarget];
    
    target = [self viewControllerCheckTarget:target];
    if (target == nil) {
        SR2Log(@"目标viewcontroller为空");
        return nil;
    }
    
    
    UIViewController *sourceImp = [self currentViewControllerForContext:context];
    if (sourceImp == nil) {
        SR2Log(@"获取不到源controller");
        return nil;
    }
    
    [self passParams:context target:target];
    
    switch (context.cmd) {
        case SR2JumpPush:
        {
            [sourceImp.navigationController pushViewController:target animated:YES];
        }
            break;
        case SR2JumpPresent:
        {
            [sourceImp presentViewController:target animated:YES completion:nil];
        }
            break;
        case SR2JumpOther:
        default:
            break;
    }
    
    [target addAutoRelease];
    
    return target;
}

@end
