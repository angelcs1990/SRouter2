//
//  SR2RemoteHandler.m
//  SRouter2Demo
//
//  Created by cs on 16/12/24.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SR2RemoteHandler.h"
#import "SR2Context.h"
#import "SR2Macro.h"
#import "SR2ServerCommands.h"
#import "SR2ModuleProtocol.h"
#import "SR2ModuleCommands.h"
#import <UIKit/UIKit.h>
#import "SR2Manager.h"
#import "SR2Cache.h"
#import "SR2Manager+Extension.h"

@implementation SR2RemoteHandler

- (id)handleCommand:(SR2HandleContext *)context
{
    NSURL *url = [context.params.params objectForKey:keySR2_Param_Url];
    if (url == nil) {
        SR2Log(@"url地址为空");
        return @(NO);
    }
    
    SR2BlockHandler completion = [context.params.block copy];
    
//    NSString *scheme = url.scheme;
//    if ([scheme isEqualToString:kSRouter2Scheme]) {
//        return nil;
//    } else if ([[UIApplication sharedApplication] canOpenURL:url]) {
//        [[UIApplication sharedApplication] openURL:url];
//        return nil;
//    }
    
    NSDictionary *dictUrl = [SR2RemoteHandler extractParametersFromURL:[url absoluteString]];
    if (dictUrl == nil) {
        return @(NO);
    }
    
    if (dictUrl[keySR2_Param_Target] == nil) {
        SR2Log(@"远程调用传参错误");
        return @(NO);
    }
    
    NSDictionary *dictParams = dictUrl[keySR2_Param_Params];
    BOOL bContinue = YES;
    //proxy delegate judge and continue?
    if (bContinue == NO) {
        return @(NO);
    }
    
    SR2ModuleRuleContext *targetContext = [[SR2Cache shareInstance] moduleFromName:dictUrl[keySR2_Param_Target]];
    UIViewController *vc = [SR2Manager currentViewController];
    if (targetContext == nil) {
        SR2String(info, @"%@:本地获取不到该条规则，如需要请在模块plist文件中添加", dictUrl[keySR2_Param_Target]);
        SR2Log(info);
        return @(NO);
    }
    
    id retValue = nil;
    if (targetContext.supportRemote) {
        if (vc.navigationController != nil) {
            retValue = [SR2Manager router_Push:targetContext.className params:dictParams handler:completion];
        } else {
            retValue = [SR2Manager router_Present:targetContext.className params:dictParams handler:completion];
        }
    } else {
        SR2String(info, @"%@:不支持远程调用", targetContext.className);
        SR2Log(info);
    }
    
    return (retValue == nil) ? @(NO) : @(YES);
}

- (BOOL)canOpenURL:(NSURL *)url
{
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
//        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    
    return NO;
}



+ (NSMutableDictionary *)extractParametersFromURL:(NSString *)url
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    
    NSArray *arrayKeys = @[keySR2_Param_Scheme, keySR2_Param_Target];
    
    NSArray* pathComponents = [self pathComponentsFromURL:url];
    if (pathComponents.count < arrayKeys.count) {
        return  nil;
    }
    //    int i = 0;
    //    for (NSString *tmp in pathComponents) {
    //        parameters[arrayKeys[i++]] = tmp;
    //    }
    
    int indexStart = 1;
    parameters[keySR2_Param_Scheme] = pathComponents[0];
//    if ([pathComponents[1] isEqualToString:keySRouterRemoteAction_Push] || [pathComponents[1] isEqualToString:keySrouterRemoteAction_Present]) {
//        parameters[keySRouterRemote_Action] = pathComponents[1];
//        indexStart = 2;
//    } else {
//        parameters[keySRouterRemote_Action] = keySRouterRemoteAction_Push;  //默认push
//        indexStart = 1;
//    }
    
    NSString *targets;
    NSMutableArray *arrayTargets = [NSMutableArray array];
    for (int i = indexStart; i < pathComponents.count; ++i) {
        [arrayTargets addObject:pathComponents[i]];
    }
    targets = [arrayTargets componentsJoinedByString:@"/"];
    parameters[keySR2_Param_Target] = targets;
    
    
    // Extract Params From Query.
    NSArray* pathInfo = [url componentsSeparatedByString:@"?"];
    if (pathInfo.count > 1) {
        
        NSMutableDictionary *dictParams = [NSMutableDictionary dictionary];
        NSString* parametersString = [pathInfo objectAtIndex:1];
        NSArray* paramStringArr = [parametersString componentsSeparatedByString:@"&"];
        for (NSString* paramString in paramStringArr) {
            NSArray* paramArr = [paramString componentsSeparatedByString:@"="];
            if (paramArr.count > 1) {
                NSString* key = [paramArr objectAtIndex:0];
                NSString* value = [paramArr objectAtIndex:1];
                dictParams[key] = value;
            }
        }
        
        parameters[keySR2_Param_Params] = dictParams;
    }
    
    return parameters;
}
//+ (BOOL)checkIfContainsSpecialCharacter:(NSString *)checkedString {
//    NSCharacterSet *specialCharactersSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
//    return [checkedString rangeOfCharacterFromSet:specialCharactersSet].location != NSNotFound;
//}
+ (NSArray*)pathComponentsFromURL:(NSString*)URL
{
    NSMutableArray *pathComponents = [NSMutableArray array];
    if ([URL rangeOfString:@"://"].location != NSNotFound) {
        NSArray *pathSegments = [URL componentsSeparatedByString:@"://"];
        // 如果 URL 包含协议，那么把协议作为第一个元素放进去
        [pathComponents addObject:pathSegments[0]];
        
        //        // 如果只有协议，那么放一个占位符
        //        if ((pathSegments.count == 2 && ((NSString *)pathSegments[1]).length) || pathSegments.count < 2) {
        //            [pathComponents addObject:MGJ_ROUTER_WILDCARD_CHARACTER];
        //        }
        
        URL = [URL substringFromIndex:[URL rangeOfString:@"://"].location + 3];
    }
    
    for (NSString *pathComponent in [[NSURL URLWithString:URL] pathComponents]) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:pathComponent];
    }
    return [pathComponents copy];
}

@end
