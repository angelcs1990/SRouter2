//
//  SR2Cache.m
//  SRouter2Demo
//
//  Created by cs on 16/12/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SR2Cache.h"
#import "SR2ServerProtocol.h"
#import "SR2Macro.h"
#import <objc/runtime.h>

@implementation SR2WeakProxy

- (void)dealloc
{
    [[SR2Cache shareInstance] removeAutoReleaseObjectName:self.router_weakObjectKeyName];
}

@end

@implementation SR2WeakObject

- (SR2WeakObject *)_router_addWeakBag:(SR2WeakObject *)weakObj
{
    SR2WeakObject *bag = objc_getAssociatedObject(self, _cmd);
    if (!bag && weakObj) {
        //        bag = [[SR2WeakObject alloc] init];
        objc_setAssociatedObject(self, _cmd, weakObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return bag;
}

@end


@interface SR2Cache()

SR2LockDefine(lockSvr);
SR2LockDefine(lockRule);
SR2LockDefine(lockBlock);
SR2LockDefine(lockProtocol);

@property (nonatomic, strong) NSMutableDictionary *dictServer;
@property (nonatomic, strong) NSMutableDictionary *dictModuleRules;
@property (nonatomic, strong) NSMutableDictionary *dictMapName;

@property (nonatomic, strong) NSMutableDictionary *dictBlock;
@property (nonatomic, strong) NSMutableDictionary *dictProtocol;

@property (nonatomic, strong) NSMutableDictionary *dictTmpObject;

@end

@implementation SR2Cache

+ (instancetype)shareInstance
{
    static SR2Cache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [SR2Cache new];
    });
    
    return cache;
}
#pragma mark - block
- (BOOL)registeBlock:(SR2BlockHandler)block name:(NSString *)keyName
{
    if (block == nil || keyName == nil) {
        return NO;
    }
    
    SR2Lock(self.lockBlock);
    [self.dictBlock setObject:[block copy] forKey:keyName];
    SR2Unlock(self.lockBlock);
    
    return YES;
}

- (void)unregisteBlock:(NSString *)keyName
{
    SR2Lock(self.lockBlock);
    [self.dictBlock removeObjectForKey:keyName];
    SR2Unlock(self.lockBlock);
}

- (SR2BlockHandler)blockForName:(NSString *)keyName
{
    SR2Lock(self.lockBlock);
    SR2BlockHandler blkHandler = [self.dictBlock objectForKey:keyName];
    SR2Unlock(self.lockBlock);
    
    return blkHandler;
}

#pragma mark - protocl
- (BOOL)registeProtocol:(Protocol *)keyProtocol withInstance:(id)inst
{
    if (keyProtocol == nil || inst == nil) {
        return NO;
    }
    
    NSString *protocol = NSStringFromProtocol(keyProtocol);
    
    if ([inst conformsToProtocol:keyProtocol]) {
        SR2Lock(self.lockProtocol);
        [self.dictProtocol setObject:inst forKey:protocol];
        SR2Unlock(self.lockProtocol);
        
        return YES;
    } else {
        SR2String(info, @"%@没有实现协议：%@", NSStringFromClass([inst class]), protocol);
        SR2Log(info);
    }
    
    return NO;
}

- (void)unregisteProtocol:(Protocol *)keyPRotocol withInstance:(id)inst
{
    NSString *protocol = NSStringFromProtocol(keyPRotocol);
    
    SR2Lock(self.lockProtocol);
    [self.dictProtocol removeObjectForKey:protocol];
    SR2Unlock(self.lockProtocol);
}

- (id)instanceForProtocol:(Protocol *)keyProtocol
{
    NSString *protocol = NSStringFromProtocol(keyProtocol);
    
    SR2Lock(self.lockProtocol);
    id retValue = [self.dictProtocol objectForKey:protocol];
    SR2Unlock(self.lockProtocol);
    
    return retValue;
}

#pragma mark - plist模块加载规则
- (void)addModuleRules:(NSArray<SR2ModuleRuleContext *> *)rules
{
    SR2Lock(self.lockRule);
    
    [rules enumerateObjectsUsingBlock:^(SR2ModuleRuleContext * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.className != nil) {
            if ([self.dictModuleRules objectForKey:obj.className] != nil) {
                SR2String(info, @"重复添加:%@", obj.className);
                SR2Log(info);
            } else {
                [self.dictModuleRules setObject:obj forKey:obj.className];
                if (obj.shortName != nil) {
                    [self.dictMapName setObject:obj.className forKey:obj.shortName];
                }
            }
        } else {
            SR2Log(@"类名为空");
        }
    }];
    
    SR2Unlock(self.lockRule);
}

- (SR2ModuleRuleContext *)moduleFromName:(NSString *)name
{
    SR2ModuleRuleContext *ctx = nil;
    
    SR2Lock(self.lockRule);
    ctx = [self.dictModuleRules objectForKey:name];
    if (ctx == nil) {
        NSString *tmpName = [self.dictMapName objectForKey:name];
        ctx = [self.dictModuleRules objectForKey:tmpName];
    }
    SR2Unlock(self.lockRule);
    
    return ctx;
}

- (void)clearAllModuleRules
{
    SR2Lock(self.lockRule);
    [self.dictModuleRules removeAllObjects];
    SR2Unlock(self.lockRule);
}

- (void)removeModuleRule:(NSString *)name
{
    SR2Lock(self.lockRule);
    [self.dictModuleRules removeObjectForKey:name];
    SR2Unlock(self.lockRule);
}

#pragma mark - 自动释放的类
- (void)addAutoReleaseObject:(id)obj withKey:(NSString *)keyName;
{
    if (obj && keyName) {
        if ([self.dictTmpObject objectForKey:keyName] == nil) {
            [self.dictTmpObject setObject:obj forKey:keyName];
        }
    }
}

- (id)autoReleaseForKey:(NSString *)keyName
{
    SR2WeakObject *retImp = nil;
    
    retImp = [self.dictTmpObject objectForKey:keyName];
    
    return retImp.router_weakObject;
}

- (void)removeAutoReleaseObjectName:(NSString *)keyName
{
    if (keyName) {
        [self.dictTmpObject removeObjectForKey:keyName];
    }
}

#pragma mark - 服务类相关
- (NSDictionary *)allServers
{
    NSDictionary *retServers = nil;
    
    SR2Lock(self.lockSvr);
    retServers = self.dictServer;
    SR2Unlock(self.lockSvr);
    
    return retServers;
}

- (id)serverForName:(NSString *)className
{
    id retImp = nil;
    
    SR2Lock(self.lockSvr);
    retImp = [self.dictServer objectForKey:className];
    SR2Unlock(self.lockSvr);
    
    return retImp;
}

- (id)instanceForName:(NSString *)className
{
    id retImp = [self serverForName:className];
    if (retImp == nil) {
        retImp = [self autoReleaseForKey:className];
    }
    
    return retImp;
}

- (void)registeServiceImp:(id)classImp
{
    if (classImp == nil) {
        return;
    }
    
    
    NSString *className = NSStringFromClass([classImp class]);
    SR2Lock(self.lockSvr);
    
    if ([self.dictServer objectForKey:className] == nil) {
        [self.dictServer setObject:classImp forKey:className];
    }
    
    SR2Unlock(self.lockSvr);
}

- (id)registeService:(NSString *)className
{
    if (className == nil || [className isEqualToString:@""] || NSClassFromString(className) == nil) {
        return nil;
    }
    
    id retImp = nil;
    SR2Lock(self.lockSvr);
    
    if ([self.dictServer objectForKey:className] == nil) {
        retImp = [[NSClassFromString(className) alloc] init];
        [self.dictServer setObject:retImp forKey:className];
    }
    
    SR2Unlock(self.lockSvr);
    
    return retImp;
}

- (void)unregisteService:(NSString *)className
{
    if (className == nil) {
        return;
    }
    
    SR2Lock(self.lockSvr);
    [self.dictServer removeObjectForKey:className];
    SR2Unlock(self.lockSvr);
}

- (void)clearAllService
{
    SR2Lock(self.lockSvr);
    [self.dictServer removeAllObjects];
    SR2Unlock(self.lockSvr);
}

#pragma mark - lazy load

- (NSMutableDictionary *)dictBlock
{
    if (_dictBlock == nil) {
        _dictBlock = [NSMutableDictionary dictionary];
    }
    
    return _dictBlock;
}

- (NSMutableDictionary *)dictServer
{
    if (_dictServer == nil) {
        _dictServer = [NSMutableDictionary dictionary];
    }
    
    return _dictServer;
}

- (NSMutableDictionary *)dictTmpObject
{
    if (_dictTmpObject == nil) {
        _dictTmpObject = [NSMutableDictionary dictionary];
    }
    
    return _dictTmpObject;
}

- (NSMutableDictionary *)dictProtocol
{
    if (_dictProtocol == nil) {
        _dictProtocol = [NSMutableDictionary dictionary];
    }
    
    return _dictProtocol;
}

- (NSMutableDictionary *)dictMapName
{
    if (_dictMapName == nil) {
        _dictMapName = [NSMutableDictionary dictionary];
    }
    
    return _dictMapName;
}

- (NSMutableDictionary *)dictModuleRules
{
    if (_dictModuleRules == nil) {
        _dictModuleRules = [NSMutableDictionary dictionary];
    }
    
    return _dictModuleRules;
}

SR2_LockInit(lockBlock);
SR2_LockInit(lockProtocol);
SR2_LockInit(lockSvr);
SR2_LockInit(lockRule);

@end
