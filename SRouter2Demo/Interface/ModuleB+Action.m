//
//  ModuleB+Action.m
//  SRouter2Demo
//
//  Created by cs on 16/12/28.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "ModuleB+Action.h"

@implementation SR2Manager (ModuleB)

+ (void)ModuleB_PushViewController
{
    [SR2Manager router_Push:@"ModuleBViewController" params:nil handler:nil];
}

@end
