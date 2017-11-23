//
//  SR2Manager.m
//  SRouter2Demo
//
//  Created by cs on 16/12/26.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SR2Manager.h"
#import "SR2Macro.h"
#import "SR2Launcher.h"
#import "NSObject+SRouter2.h"


@implementation SR2Manager

+ (void)router_InitWithHandler:(NSString *)handler finish:(SR2Finish)finishBlk error:(SR2Error)errorBlk
{
    BOOL bRet = [[SR2Launcher shareInstance] registerCoreServer:handler];
    
    if (bRet) {
        if ([SR2Config shareInstance].autoLoadPlist) {
            [[SR2Launcher shareInstance] startAutoload:[SR2Config shareInstance].moduleConfigName finish:finishBlk error:errorBlk];
        } else {
            finishBlk(0);
        }
    } else {
        if (errorBlk) {
            errorBlk(0);
        }
    }
}

+ (id)router_InstanceClass:(NSString *)className
{
    if (className == nil || [className isEqualToString:@""]) {
        return nil;
    }
    
    id retValue = [[NSClassFromString(className) alloc] init];
    
    if (retValue == nil) {
        SR2String(info, @"%@:不存在该类，无法实例化", className);
        SR2Log(info);
    }
    
//    [retValue addAutoRelease];
    
    return retValue;
}

+ (nullable id)router_handleMsg:(SR2ServerCmds)cmd params:(nullable SR2Params *)params from:(SR2CmdFrom)from
{
    SR2HandleContext *ctx = [SR2HandleContext new];
    ctx.from = from;
    ctx.params = params;
    ctx.cmd = cmd;
    
    if ([SR2Launcher shareInstance].coreServer == nil) {
        SR2Log(@"没有初始化核心服务，请先调用初始化方法");
        return nil;
    }
    return [[SR2Launcher shareInstance].coreServer handleCommand:ctx];
}
#pragma mark - 界面跳转
+ (NSDictionary *)paramsWithName:(NSString *)targetClass params:(NSDictionary *)params
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:targetClass forKey:keySR2_Param_Target];
    
    return dict;
}

+ (nullable id)router_Push:(nonnull NSString *)targetClassName params:(nullable NSDictionary *)params handler:(nullable SR2BlockHandler)blk
{
    return [self router_Push:targetClassName sourceVC:nil params:params handler:blk];
}

+ (id)router_Push:(nonnull NSString *)targetClassName sourceVC:(UIViewController *)sourceVC params:(NSDictionary *)params handler:(SR2BlockHandler)blk
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2JumpPush];
    NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
    [dictParams setObject:targetClassName forKey:keySR2_Param_Target];
    if (sourceVC) {
        [dictParams setObject:sourceVC forKey:keySR2_Param_Source];
    }
    if (params) {
        [dictParams setObject:params forKey:keySR2_Param_Params];
    }
    subParams.params = dictParams;
    subParams.block = blk;
    
    return [self router_handleMsg:SR2HandleJump params:subParams from:SR2CmdFromLocal];
}

+ (id)router_Push:(nonnull NSString *)targetClassName params:(NSDictionary *)params protocol:(id<SR2Protocol>)prol
{
    return [self router_Push:targetClassName sourceVC:nil params:params protocol:prol];
}

+ (id)router_Push:(nonnull NSString *)targetClassName sourceVC:(UIViewController *)sourceVC params:(NSDictionary *)params protocol:(id<SR2Protocol>)prol
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2JumpPush];
    NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
    [dictParams setObject:targetClassName forKey:keySR2_Param_Target];
    if (sourceVC) {
        [dictParams setObject:sourceVC forKey:keySR2_Param_Source];
    }
    if (params) {
        [dictParams setObject:params forKey:keySR2_Param_Params];
    }
    subParams.params = dictParams;
    subParams.delegate = prol;
    
    return [self router_handleMsg:SR2HandleJump params:subParams from:SR2CmdFromLocal];
}

+ (BOOL)router_OpenRemoteUrl:(NSURL *)url comletion:(void (^)(NSDictionary *))completion
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2JumpOther];
    NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
    if (url) {
        [dictParams setObject:url forKey:keySR2_Param_Url];
    }
    subParams.params = dictParams;
    subParams.block = completion;

    return [[self router_handleMsg:SR2HandleJump params:subParams from:SR2CmdFromRemote] boolValue];
}

+ (id)router_Present:(nonnull NSString *)targetClassName params:(NSDictionary *)params handler:(SR2BlockHandler)blk
{
    return [self router_Present:targetClassName sourceVC:nil params:params handler:blk];
}

+ (id)router_Present:(nonnull NSString *)targetClassName sourceVC:(UIViewController *)sourceVC params:(NSDictionary *)params handler:(SR2BlockHandler)blk
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2JumpPresent];
    NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
    [dictParams setObject:targetClassName forKey:keySR2_Param_Target];
    if (sourceVC) {
        [dictParams setObject:sourceVC forKey:keySR2_Param_Source];
    }
    if (params) {
        [dictParams setObject:params forKey:keySR2_Param_Params];
    }
    subParams.params = dictParams;
    subParams.block = blk;
    
    return [self router_handleMsg:SR2HandleJump params:subParams from:SR2CmdFromLocal];
}

+ (id)router_Present:(nonnull NSString *)targetClassName params:(NSDictionary *)params protocol:(id<SR2Protocol>)prol
{
    return [self router_Present:targetClassName sourceVC:nil params:params protocol:prol];
}

+ (id)router_Present:(nonnull NSString *)targetClassName sourceVC:(UIViewController *)sourceVC params:(NSDictionary *)params protocol:(id<SR2Protocol>)prol
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2JumpPresent];
    NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
    [dictParams setObject:targetClassName forKey:keySR2_Param_Target];
    if (sourceVC) {
        [dictParams setObject:sourceVC forKey:keySR2_Param_Source];
    }
    if (params) {
        [dictParams setObject:params forKey:keySR2_Param_Params];
    }
    subParams.params = dictParams;
    subParams.delegate = prol;
    
    return [self router_handleMsg:SR2HandleJump params:subParams from:SR2CmdFromLocal];
}

#pragma mark - 消息订阅
+ (void)router_SubscribMsg:(NSInteger)msg withName:(NSString *)className handler:(SR2BlockHandler)block
{
    [self router_SubscribMsg:msg withName:className handler:block recvCount:-1];
}

+ (void)router_SubscribMsg:(NSInteger)msg withName:(NSString *)className handler:(SR2BlockHandler)block recvCount:(NSInteger)count
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2SubscribRegiste];
    subParams.params = @{keySR2_Param_Target: className};
    subParams.block = block;
    subParams.subCmd = [SR2Params parmasWithCmd:msg];
    subParams.subCmd.params = @{keySR2_Param_Params:@(count), keySR2_Param_Target: @""};
    
    [self router_handleMsg:SR2HandleSubscribe params:subParams from:SR2CmdFromLocal];
}

+ (void)router_SubscribMsg:(NSInteger)msg withName:(NSString *)className
{
    [self router_SubscribMsg:msg withName:className handler:nil recvCount:1];
}

//+ (void)router_SubscribMsg:(NSInteger)msg handler:(SR2BlockHandler)block
//{
//    [self router_SubscribMsg:msg withName:@"" handler:block recvCount:1];
//}


+ (void)router_SubscribMsg:(NSInteger)msg srcName:(NSString *)srcName desName:(NSString *)desName handler:(SR2BlockHandler)block
{
    [self router_SubscribMsg:msg srcName:srcName desName:desName countLimit:-1 handler:block];
}

+ (void)router_SubscribMsg:(NSInteger)msg srcName:(NSString *)srcName desName:(NSString *)desName countLimit:(NSInteger)count handler:(SR2BlockHandler)block
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2SubscribRegiste];
    subParams.params = @{keySR2_Param_Target: srcName};
    subParams.block = block;
    subParams.subCmd = [SR2Params parmasWithCmd:msg];
    subParams.subCmd.params = @{keySR2_Param_Params:@(count), keySR2_Param_Target: desName};
    
    [self router_handleMsg:SR2HandleSubscribe params:subParams from:SR2CmdFromLocal];
}

//+ (void)router_SubscribMsg:(NSInteger)msg desName:(NSString *)desName handler:(SR2BlockHandler)block
//{
//    [self router_SubscribMsg:msg srcName:@"" desName:desName countLimit:1 handler:block];
//}

+ (void)router_SubscribMsg:(NSInteger)msg srcName:(NSString *)srcName desName:(NSString *)desName
{
    [self router_SubscribMsg:msg srcName:srcName desName:desName countLimit:1 handler:nil];
}

+ (void)router_Notify:(NSInteger)msg withParams:(NSDictionary *)params
{
    [self router_Notify:msg withSrcName:@"" withParams:params];
}

+ (void)router_Notify:(NSInteger)msg withSrcName:(NSString *)srcName withParams:(NSDictionary *)params
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2SubscribNotify];
    subParams.subCmd = [SR2Params parmasWithCmd:msg];
    subParams.params = @{keySR2_Param_Target: srcName};
    subParams.subCmd.params = params;
    
    [self router_handleMsg:SR2HandleSubscribe params:subParams from:SR2CmdFromLocal];
}

+ (void)router_CancelSubscribMsg:(NSInteger)msg withName:(NSString *)className
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2SubscribUnregiste];
    subParams.params = @{keySR2_Param_Target: className};
    subParams.subCmd = [SR2Params parmasWithCmd:msg];
    
    [self router_handleMsg:SR2HandleSubscribe params:subParams from:SR2CmdFromLocal];
}

#pragma mark - 模块消息传递
+ (id)router_TellModuleMessage:(NSString *)targetClass withCmd:(NSInteger)cmd withParams:(NSDictionary *)params
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2OtherTellMsg];
    subParams.params = @{keySR2_Param_Target: targetClass};
    subParams.subCmd = [SR2Params parmasWithCmd:cmd];
    subParams.subCmd.params = params;
    
    return [self router_handleMsg:SR2HandleOther params:subParams from:SR2CmdFromLocal];
}

+ (void)router_TellAllModulesMessage:(NSInteger)cmd withParams:(NSDictionary *)params
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2OtherTellAllMsg];
    subParams.subCmd = [SR2Params parmasWithCmd:cmd];
    subParams.subCmd.params = params;
    
    [self router_handleMsg:SR2HandleOther params:subParams from:SR2CmdFromLocal];
}

+ (id)router_TellModule:(NSString *)targetClass withMessage:(SR2Params *)params
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2OtherTellMsg];
    subParams.params = @{keySR2_Param_Target: targetClass};
    subParams.subCmd = params;
    return [self router_handleMsg:SR2HandleOther params:subParams from:SR2CmdFromLocal];
}

+ (void)router_TellAllModulesMessage:(SR2Params *)params
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2OtherTellAllMsg];
    subParams.subCmd = params;
    [self router_handleMsg:SR2HandleOther params:subParams from:SR2CmdFromLocal];
}

#pragma mark - 注册相关、查询


+ (id)router_QueryInstance:(NSString *)key
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2QueryObject];
    subParams.params = @{keySR2_Param_Target:key};
    
    return [self router_handleMsg:SR2HandleQuery params:subParams from:SR2CmdFromLocal];
}



#pragma mark - 服务类相关
+ (id)router_RegisteServer:(NSString *)servClass
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2RegisteService];
    subParams.params = @{keySR2_Param_Target:servClass};
    
    return [self router_handleMsg:SR2HandleRegiste params:subParams from:SR2CmdFromLocal];
}

+ (void)router_UnregisteServer:(NSString *)servClass
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2UnregisteServer];
    subParams.params = @{keySR2_Param_Target:servClass};
    
    [self router_handleMsg:SR2HandleUnregiste params:subParams from:SR2CmdFromLocal];
}

+ (id)router_QueryServer:(NSString *)servClass
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2QueryServer];
    subParams.params = @{keySR2_Param_Target:servClass};
    
    return [self router_handleMsg:SR2HandleQuery params:subParams from:SR2CmdFromLocal];
}

#pragma mark - plist规则相关
+ (BOOL)router_RegisteRules:(NSString *)plistName
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2RegisteRules];
    subParams.params = @{keySR2_Param_Target:plistName};
    
    [self router_handleMsg:SR2HandleRegiste params:subParams from:SR2CmdFromLocal];
    
    return YES;
}

+ (void)router_UnregisteRules:(NSString *)plistName
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2UnregisteRules];
    subParams.params = @{keySR2_Param_Target:plistName};
    
    [self router_handleMsg:SR2HandleUnregiste params:subParams from:SR2CmdFromLocal];
}

#pragma mark - 
+ (void)router_printServers
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2OtherPrintServers];

    [self router_handleMsg:SR2HandleOther params:subParams from:SR2CmdFromLocal];
}


+ (void)router_printSubscribe
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2OtherPrintSubscribe];
    
    [self router_handleMsg:SR2HandleOther params:subParams from:SR2CmdFromLocal];
}


//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    if (aSelector == @selector(tableView:heightForRowAtIndexPath:) || aSelector == @selector(cs_tableView:heightForRowAtIndexPath:)) {
//        return self;
//    }
//    if (aSelector == @selector(tableView:willDisplayCell:forRowAtIndexPath:) || aSelector == @selector(cs_tableView:willDisplayCell:forRowAtIndexPath:)) {
//        return self;
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}
//+ (BOOL)resolveInstanceMethod:(SEL)sel
//{
//    if (sel == @selector(tableView:heightForRowAtIndexPath:) || sel == @selector(cs_tableView:heightForRowAtIndexPath:)) {
//        NSLog(@"sdfs");
//    }
//    return [super resolveInstanceMethod:sel];
//}
//+ (BOOL)resolveClassMethod:(SEL)sel
//{
//    NSLog(@"ss");
//    return [super resolveClassMethod:sel];
//}

//+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)selector
//{
//    return nil;
//}
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
//{
//    @synchronized([self class])
//    {
//        //look up method signature
//        NSMethodSignature *signature = [super methodSignatureForSelector:selector];
//        if (!signature)
//        {
//            if ([SR2RuntimeMethodHelper instanceMethodForSelector:@selector(notFound)]) {
//                signature = [SR2RuntimeMethodHelper instanceMethodSignatureForSelector:@selector(notFound)];
//            }
//        }
//        return signature;
//    }
//}
//
//- (void)forwardInvocation:(NSInvocation *)invocation
//{
//    invocation.target = nil;
//    [invocation invoke];
//}

+ (NSDictionary *)SR2ModuleNotifyParams:(SR2Params *)params
{
    return params.subCmd.params;
}
@end
