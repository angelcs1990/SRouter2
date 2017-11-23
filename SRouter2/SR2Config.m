//
//  SR2Config.m
//  SRouter2Demo
//
//  Created by cs on 16/12/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SR2Config.h"
#import "SR2Macro.h"

@implementation SR2Config

+ (instancetype)shareInstance
{
    static SR2Config *cig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cig = [SR2Config new];
    });
    
    return cig;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupData];
    }
    
    return self;
}

- (void)setupData
{
    self.checkAll = NO;
    self.checkLocal = YES;
    self.checkRemote = YES;
    self.plistPrefix = @"SR2";
    self.alwaysException = NO;
    self.autoLoadPlist = YES;
    self.autoRegisteSvr = NO;
    self.strictCheck = NO;
    self.asyncLoadPlist = YES;
    self.moduleConfigName = SR2DefaultPlist;
    self.debugMode = NO;
}

@end
