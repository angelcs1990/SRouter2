//
//  SR2HandleContext.m
//  SRouter2Demo
//
//  Created by cs on 16/12/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SR2Context.h"



@implementation SR2Params
+ (instancetype)parmasWithCmd:(NSInteger)cmd
{
    SR2Params *params = [SR2Params new];
    params.cmd = cmd;
    
    return params;
}

- (void)setSubCmd:(SR2Params *)subCmd
{
    if (subCmd == self) {
        return;
    }
    _subCmd = subCmd;
}

@end

@implementation SR2HandleContext


@end

@implementation SR2ModuleRuleContext


@end
