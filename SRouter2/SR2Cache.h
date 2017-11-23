//
//  SR2Cache.h
//  SRouter2Demo
//
//  Created by cs on 16/12/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SR2Context.h"

@interface SR2WeakProxy : NSObject

@property (nonatomic, strong) NSString *router_weakObjectKeyName;

@end

@interface SR2WeakObject : NSObject

@property (nonatomic, weak) id router_weakObject;

@end


@interface SR2Cache : NSObject

+ (instancetype)shareInstance;

- (BOOL)registeBlock:(SR2BlockHandler)block name:(NSString *)keyName;
- (void)unregisteBlock:(NSString *)keyName;
- (SR2BlockHandler)blockForName:(NSString *)keyName;

- (BOOL)registeProtocol:(Protocol *)keyProtocol withInstance:(id)inst;
- (void)unregisteProtocol:(Protocol *)keyPRotocol withInstance:(id)inst;
- (id)instanceForProtocol:(Protocol *)keyProtocol;


- (void)addAutoReleaseObject:(id)obj withKey:(NSString *)keyName;
- (void)removeAutoReleaseObjectName:(NSString *)keyName;
- (id)autoReleaseForKey:(NSString *)keyName;

- (void)registeServiceImp:(id)classImp;
- (id)registeService:(NSString *)className;
- (id)serverForName:(NSString *)className;
- (id)instanceForName:(NSString *)className;
- (NSDictionary *)allServers;
- (void)unregisteService:(NSString *)className;
- (void)clearAllService;

- (void)addModuleRules:(NSArray<SR2ModuleRuleContext *> *)rules;
- (SR2ModuleRuleContext *)moduleFromName:(NSString *)name;
- (void)clearAllModuleRules;
- (void)removeModuleRule:(NSString *)name;


@end
