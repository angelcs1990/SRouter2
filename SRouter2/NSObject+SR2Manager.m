//
//  NSObject+SR2Manager.m
//  SRouter2Demo
//
//  Created by cs on 17/3/24.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "NSObject+SR2Manager.h"
#import "SR2Macro.h"
#import <UIKit/UIKit.h>

@implementation NSObject (SR2Manager)

- (void)router_SetValue:(id)value forKey:(NSString *)key
{
    @try {
        [self setValue:value forKey:key];
    } @catch (NSException *exception) {
        SR2String(info, @"(%@-%@)kvo赋值出错:%@", NSStringFromClass([self class]), key, exception.reason);
        SR2Log(info);
    } @finally {
        
    }
}

- (id)router_ValueForKey:(NSString *)key
{
    id retValue = nil;
    @try {
        retValue = [self valueForKey:key];
    } @catch (NSException *exception) {
        SR2String(info, @"(%@-%@)kvo获取出错:%@", NSStringFromClass([self class]), key, exception.reason);
        SR2Log(info);
    } @finally {
        
    }
    
    return retValue;
}

- (void)router_SetValue:(id)value forKeyPath:(NSString *)keyPath
{
    @try {
        [self setValue:value forKeyPath:keyPath];
    } @catch (NSException *exception) {
        SR2String(info, @"(%@-%@)kvo赋值出错:%@", NSStringFromClass([self class]), keyPath, exception.reason);
        SR2Log(info);
    } @finally {
        
    }
}

- (id)router_ValueForKeyPath:(NSString *)keyPath
{
    id retValue = nil;
    @try {
        retValue = [self valueForKeyPath:keyPath];
    } @catch (NSException *exception) {
        SR2String(info, @"(%@-%@)kvo获取出错:%@", NSStringFromClass([self class]), keyPath, exception.reason);
        SR2Log(info);
    } @finally {
        
    }
    
    return retValue;
}

@end
