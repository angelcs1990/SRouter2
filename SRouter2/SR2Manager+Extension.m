//
//  SR2Manager+Extension.m
//  SRouter2Demo
//
//  Created by cs on 17/3/1.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SR2Manager+Extension.h"
#import "SR2Macro.h"

@implementation SR2Manager (Extension)

+ (id)router_PushEx:(nonnull UIViewController *)target params:(NSDictionary *)params handler:(SR2BlockHandler)blk
{
    return [self router_PushEx:target sourceVC:nil params:params handler:blk];
}

+ (id)router_PushEx:(nonnull UIViewController *)target sourceVC:(UIViewController *)sourceVC params:(NSDictionary *)params handler:(SR2BlockHandler)blk
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2JumpPush];
    NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
    [dictParams setObject:target forKey:keySR2_Param_Target];
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

+ (id)router_PushEx:(nonnull UIViewController *)target params:(NSDictionary *)params protocol:(id<SR2Protocol>)prol
{
    return [self router_PushEx:target sourceVC:nil params:params protocol:prol];
}

+ (id)router_PushEx:(nonnull UIViewController *)target sourceVC:(UIViewController *)sourceVC params:(NSDictionary *)params protocol:(id<SR2Protocol>)prol
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2JumpPush];
    NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
    [dictParams setObject:target forKey:keySR2_Param_Target];
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


+ (id)router_PresentEx:(nonnull UIViewController *)target params:(NSDictionary *)params handler:(SR2BlockHandler)blk
{
    return [self router_PresentEx:target sourceVC:nil params:params handler:blk];
}

+ (id)router_PresentEx:(nonnull UIViewController *)target sourceVC:(UIViewController *)sourceVC params:(NSDictionary *)params handler:(SR2BlockHandler)blk
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2JumpPresent];
    NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
    [dictParams setObject:target forKey:keySR2_Param_Target];
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

+ (id)router_PresentEx:(nonnull UIViewController *)target params:(NSDictionary *)params protocol:(id<SR2Protocol>)prol
{
    return [self router_PresentEx:target sourceVC:nil params:params protocol:prol];
}

+ (id)router_PresentEx:(nonnull UIViewController *)target sourceVC:(UIViewController *)sourceVC params:(NSDictionary *)params protocol:(id<SR2Protocol>)prol
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2JumpPresent];
    NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
    [dictParams setObject:target forKey:keySR2_Param_Target];
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


+ (void)router_RegisteServerEx:(id)service
{
    SR2Params *subParams = [SR2Params parmasWithCmd:SR2RegisteService];
    subParams.params = @{keySR2_Param_Target:service};
    
    [self router_handleMsg:SR2HandleRegiste params:subParams from:SR2CmdFromLocal];
}


+ (UIViewController *)currentViewController
{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (rootVC == nil) {
        rootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    }
    UIViewController *sourceVC = nil;
    
    sourceVC = [self _topViewController:rootVC];
    while (sourceVC.presentedViewController) {
        sourceVC = [self _topViewController:sourceVC.presentedViewController];
    }
    
    return sourceVC;
    
    //    if ([rootVC isKindOfClass:[UINavigationController class]]) {
    //        sourceVC = [((UINavigationController *)rootVC) visibleViewController];
    //    } else {
    //        if (rootVC.presentedViewController) {
    //            sourceVC = rootVC.presentedViewController;
    //        } else {
    //            sourceVC = rootVC;
    //        }
    //    }
    //
    //    if ([sourceVC isKindOfClass:[UITabBarController class]]) {
    //        sourceVC = [((UITabBarController *)sourceVC) selectedViewController];
    //    }
    //
    //    return sourceVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
}

@end
