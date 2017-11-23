//
//  SR2Frame.m
//  SRouter2Demo
//
//  Created by cs on 16/12/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SR2Launcher.h"
#import "SR2Macro.h"
#import "SR2ModuleProtocol.h"
#import <objc/runtime.h>
#import "SR2Cache.h"
#import "SR2SubscribedMsgMgr.h"
#import "SR2Manager.h"
#import "SR2ModuleCommands.h"

id (*SR2Method)(id, SEL, SR2Params *);
id (*SR2Method2)(id, SEL, SR2Params *, BOOL *);

@interface SR2Launcher ()
@end

@implementation SR2Launcher

+ (instancetype)shareInstance
{
    static SR2Launcher *frame = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        frame = [SR2Launcher new];
    });
    
    return frame;
}

- (id)tellModuleMessage:(NSString *)targetClass withParams:(SR2Params *)params
{
    //plist中对比效验
    BOOL bRet = [self checkValidWithClassName:targetClass from:SR2CmdFromLocal];
    if (!bRet) {
        SR2String(info, @"(tellModuleMessage)验证没有通过:%@", targetClass);
        SR2Log(info);
        return nil;
    }
    
    //查找已注册的服务类实例,没有就return
    if (targetClass) {
        BOOL bStop = NO;
        Class tmpClass = NSClassFromString(targetClass);
        Method md = class_getClassMethod(tmpClass, @selector(SR2Module_ClassCommand:stop:));
        if (md) {
            SR2Method2 = (id(*)(id, SEL, SR2Params *, BOOL *))method_getImplementation(md);
            id retValue = SR2Method2(tmpClass, @selector(SR2Module_ClassCommand:stop:), params, &bStop);
            if (bStop) {
                return retValue;
            }
        }
        

        if ((md = class_getInstanceMethod(tmpClass, @selector(SR2Module_Command:)))) {
            id<SR2ModuleProtocol> targetImp = [self targetForName:targetClass];
            if (targetImp) {
                SR2Method = (id(*)(id, SEL, SR2Params *))method_getImplementation(md);
                return SR2Method(targetImp, @selector(SR2Module_Command:), params);
            } else {
                SR2String(info, @"%@:未注册服务类，或是该类不存在", targetClass);
                SR2Log(info);
            }
        } else {
            SR2String(info, @"%@:未实现SR2ModuleProtocol协议", targetClass);
            SR2Log(info);
        }
        
    }

    return nil;
}

- (void)tellAllModulesMessage:(SR2Params *)params
{
    NSDictionary *allServers = [[SR2Cache shareInstance] allServers];
    [allServers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj && [obj respondsToSelector:@selector(SR2Module_Command:)]) {
            [obj SR2Module_Command:params];
        }
    }];
}

- (id)targetForName:(NSString *)className
{
    id svr = [[SR2Cache shareInstance] instanceForName:className];
    
    if (svr == nil) {
        if ([SR2Config shareInstance].strictCheck == NO) {
            if ([SR2Config shareInstance].autoRegisteSvr) {
                svr = [[SR2Cache shareInstance] registeService:className];
                SR2String(info, @"自动注册了服务类:%@", className);
                SR2Log(info);
            } else {
                svr = [[NSClassFromString(className) alloc] init];
                SR2String(info, @"临时创建了:%@", className);
                SR2Log(info);
            }
        }
    }
    
    return svr;
}

- (BOOL)registerCoreServer:(NSString *)servName
{
    if (servName == nil) {
        servName = @"SR2CoreServer";
    }
    
    id serv = [[NSClassFromString(servName) alloc] init];
    
    if (serv == nil || ![serv conformsToProtocol:@protocol(SR2ServerProtocol)]) {
        SR2Log(@"注册核心服务出错");
        return NO;
    }
    
    _coreServer = serv;
    
    return YES;
}

- (BOOL)checkValidWithClassName:(NSString *)className from:(SR2CmdFrom)from
{
    if (className == nil) {
        return YES;
    }
    
    if (NSClassFromString(className) == Nil) {
        return NO;
    }
    
    if ([SR2Config shareInstance].checkAll == NO) {
        return YES;
    }
    
    
    if ([SR2Config shareInstance].checkLocal) {
        if (from == SR2CmdFromLocal) {
            SR2ModuleRuleContext *ctx = [[SR2Cache shareInstance] moduleFromName:className];
            return (ctx ? YES : NO);
        }
        
        return YES;
    }
    
    if ([SR2Config shareInstance].checkRemote) {
        if (from == SR2CmdFromRemote) {
            SR2ModuleRuleContext *ctx = [[SR2Cache shareInstance] moduleFromName:className];
            return (ctx ? YES : NO);
        }
        
        return YES;
    }
    
    SR2ModuleRuleContext *ctx = [[SR2Cache shareInstance] moduleFromName:className];
    return (ctx ? YES : NO);
}

- (void)startAutoload:(NSString *)plistName finish:(SR2Finish)finishBlk error:(SR2Error)errorBlk
{
    if (plistName == nil) {
        return;
    }
    
    NSString *moduelPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    if (moduelPath == nil) {
        SR2String(info, @"找不到%@配置文件", plistName);
        SR2Log(info);
        return;
    }
    
    @try {
        NSDictionary<NSString *, NSString *> *plistData = [[NSDictionary alloc] initWithContentsOfFile:moduelPath];
        
        if ([SR2Config shareInstance].asyncLoadPlist) {
            
            dispatch_queue_t queue = dispatch_queue_create("com.srourter.cs.v2", NULL);
            dispatch_async(queue, ^{
                [plistData enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                    [self loadModulesWithPlist:key];
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [SR2Manager router_TellAllModulesMessage:SR2ModuleDidInit withParams:nil];
                    if (finishBlk) {
                        finishBlk(0);
                    }
                });
            });
        } else {
            [plistData enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                [self loadModulesWithPlist:key];
            }];
//            [SR2Manager router_TellAllModulesMessage:SR2ModuleDidInit withParams:nil];
            if (finishBlk) {
                finishBlk(0);
            }
        }
        
        
    } @catch (NSException *exception) {
        SR2String(info, @"模块载入出错了:%@", plistName);
        SR2Log(info);
        
        if (errorBlk) {
            errorBlk(0);
        }
    }
}

- (void)loadModulesWithPlist:(NSString *)plistName
{
    NSString *moduelPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    if (moduelPath == nil) {
        SR2String(info, @"找不到%@配置文件", plistName);
        SR2Log(info);
        return;
    }
    
    if (![plistName hasPrefix:SR2DefaultPlist] && ![plistName hasPrefix:[SR2Config shareInstance].plistPrefix]) {
        SR2String(info, @"配置文件验证失败:%@", plistName);
        SR2Log(info);
        return;
    }
    
    NSArray *plistData = [[NSArray alloc] initWithContentsOfFile:moduelPath];
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    @try {
        for (int i = 0; i < plistData.count; ++i) {
            SR2ModuleRuleContext *ctx = [SR2ModuleRuleContext new];
            NSDictionary *obj = plistData[i];
            
            ctx.className = [obj objectForKey:@"moduleName"];
            ctx.macroName = [obj objectForKey:@"macroName"];
            ctx.desc = nil;
            ctx.shortName = [obj objectForKey:@"shortName"];
            ctx.moduleType = [[obj objectForKey:@"moduleType"] integerValue];
            ctx.supportRemote = [[obj objectForKey:@"supportRemote"] boolValue];
            
            [tmpArray addObject:ctx];
            
            //根据全局变量决定是否自动加载服务类
            switch (ctx.moduleType) {
                case SR2ModuleServer:
                {
                    [[SR2Cache shareInstance] registeService:ctx.className];
                }
                    break;
//                case SR2ModuleSubscriber:
//                {
//                    
//                }
//                    break;
                case SR2ModuleModule:
                {}
                    break;
                case SR2ModuleNormal:
                {}
                    break;
                case SR2ModuleOther:
                default:
                    break;
            }
        }
        
        [[SR2Cache shareInstance] addModuleRules:tmpArray];
    } @catch (NSException *exception) {
        SR2String(info, @"模块载入出错了:%@", plistName);
        SR2Log(info);
    }
}


#pragma mark - 懒加载

@end
