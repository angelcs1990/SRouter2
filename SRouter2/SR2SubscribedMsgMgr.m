//
//  SR2SubscribedMessageManager.m
//  SRouter2Demo
//
//  Created by cs on 16/12/24.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SR2SubscribedMsgMgr.h"
#import "SR2Launcher.h"
#import "SR2Macro.h"

#define SAFE_STR(_str_name_) ((_str_name_ == nil) ? @"None" : _str_name_)

@interface _SR2SubscribeMsgContext : NSObject

@property (nonatomic, copy) SR2BlockHandler block;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *desName;

@property (nonatomic, assign) NSInteger countLimit;

@end

@implementation _SR2SubscribeMsgContext

- (instancetype)init
{
    self = [super init];
    if (self) {
        _countLimit = 1;
    }
    
    return self;
}

- (NSString *)description
{
    if (_block == nil) {
        return [NSString stringWithFormat:@"%@", @{@"block":@"None", @"name":SAFE_STR(self.name), @"desName":SAFE_STR(self.desName), @"limitNum":@(_countLimit)}];
    } else {
        return [NSString stringWithFormat:@"%@", @{@"block":_block, @"name":SAFE_STR(self.name), @"desName":SAFE_STR(self.desName), @"limitNum":@(_countLimit)}];
    }
    
}

- (NSString *)debugDescription
{
    if (_block == nil) {
        return [NSString stringWithFormat:@"<%@:%p>:%@", [self class], &self, @{@"block":@"None", @"name":SAFE_STR(self.name), @"desName":SAFE_STR(self.desName), @"limitNum":@(_countLimit)}];
    } else {
        return [NSString stringWithFormat:@"<%@:%p>:%@", [self class], &self, @{@"block":_block, @"name":SAFE_STR(self.name), @"desName":SAFE_STR(self.desName), @"limitNum":@(_countLimit)}];
    }
    
}

@end





@interface SR2SubscribedMsgMgr ()

SR2LockDefine(lockDw);

@property (nonatomic, strong) NSMutableDictionary *dictDataWho;

@end

@implementation SR2SubscribedMsgMgr

+ (instancetype)shareInstance
{
    static SR2SubscribedMsgMgr *subMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        subMgr = [SR2SubscribedMsgMgr new];
    });
    
    return subMgr;
}

- (void)subscribMsg:(NSInteger)msg srcName:(NSString *)srcName desName:(NSString *)desName handler:(SR2BlockHandler)block countLimit:(NSInteger)count
{
    NSAssert(msg >= 0, @"订阅消息必须大于0");
    
    NSNumber *msgKey = [NSNumber numberWithInteger:msg];
    
    SR2Lock(self.lockDw);
    if ([self.dictDataWho objectForKey:msgKey] == nil) {
        self.dictDataWho[msgKey] = [NSMutableArray array];
    }
    
    _SR2SubscribeMsgContext *context = [_SR2SubscribeMsgContext new];
    context.name = srcName;
    context.block = [block copy];
    context.countLimit = count;
    context.desName = [desName isEqualToString:@""] ? nil : desName;
    
    if (![self.dictDataWho[msgKey] containsObject:context]) {
        [self.dictDataWho[msgKey] addObject:context];
    }
    SR2Unlock(self.lockDw);
}

- (void)notify:(SR2Params *)params
{
    NSNumber *msgKey = [NSNumber numberWithInteger:params.subCmd.cmd];
    
    NSMutableArray *arrayWillDel = [NSMutableArray array];
    
    SR2Lock(self.lockDw);
    if ([self.dictDataWho objectForKey:msgKey]) {
        SR2Launcher *launcher = [SR2Launcher shareInstance];
        NSArray *whos = self.dictDataWho[msgKey];
        SR2Unlock(self.lockDw);

        [whos enumerateObjectsUsingBlock:^(_SR2SubscribeMsgContext * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            BOOL bGoFunction = NO;
            NSString *destName = [params.params objectForKey:keySR2_Param_Target];
            if (obj.desName) {
                if (destName && [obj.desName isEqualToString:destName]) {
                    bGoFunction = YES;
                }
            } else {
                bGoFunction = YES;
            }
            
            if (bGoFunction) {
                if (obj.block) {
                    obj.block(params.subCmd.params);
                } else {
                    [launcher tellModuleMessage:obj.name withParams:params];
                }
                
                obj.countLimit -= 1;

                if (obj.countLimit <= 0) {
                    //删除
                    [arrayWillDel addObject:obj];
                }
            }
        }];
        
        if (arrayWillDel.count > 0) {
            
            [arrayWillDel enumerateObjectsUsingBlock:^(_SR2SubscribeMsgContext *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SR2String(info, @"%@订阅的消息：(%ld)-自动移除", obj.name, params.subCmd.cmd);
                SR2Log(info);
            }];
            
            SR2Lock(self.lockDw);
            [self.dictDataWho[msgKey] removeObjectsInArray:arrayWillDel];
            if ([self.dictDataWho[msgKey] count] == 0) {
                [self.dictDataWho removeObjectForKey:msgKey];
            }
            SR2Unlock(self.lockDw);
            
  
        }
    } else {
        SR2Unlock(self.lockDw);
    }
    
}

- (void)cancelSubscribMsg:(NSInteger)msg withName:(NSString *)className
{
    NSNumber *msgKey = @(msg);
    
    SR2Lock(self.lockDw);
    if (msg != -1 && className != nil) {
        [self.dictDataWho[msgKey] enumerateObjectsUsingBlock:^(_SR2SubscribeMsgContext *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([className isEqualToString:obj.name]) {
                [self.dictDataWho[msgKey] removeObjectAtIndex:idx];
                *stop = YES;
            }
        }];
    } else if (msg != -1 && className == nil) {
        [self.dictDataWho[msgKey] removeAllObjects];
    } else {
        [self.dictDataWho removeAllObjects];
    }
    
    if ([self.dictDataWho objectForKey:msgKey] != nil && [self.dictDataWho[msgKey] count] == 0) {
        [self.dictDataWho removeObjectForKey:msgKey];
    }
    
    SR2Unlock(self.lockDw);
}

- (void)printDebug
{
    __block NSInteger idxMsg = 0;
    SR2Lock(self.lockDw);
    [self.dictDataWho enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSInteger msgNo = [key integerValue];
        NSArray *arrayData = (NSArray *)obj;
        SR2String(info, @"%ld)  (消息号：%ld)", idxMsg, msgNo)
        NSLog(@"%@", info);
        [arrayData enumerateObjectsUsingBlock:^(_SR2SubscribeMsgContext * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"-%ld) (%@)", idx, obj);
            
        }];
        idxMsg++;
    }];
    SR2Unlock(self.lockDw);
}

#pragma mark - lazy load
- (NSMutableDictionary *)dictDataWho
{
    if (_dictDataWho == nil) {
        _dictDataWho = [NSMutableDictionary dictionary];
    }
    
    return _dictDataWho;
}

SR2_LockInit(lockDw);

@end
