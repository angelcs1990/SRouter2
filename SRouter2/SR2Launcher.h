//
//  SR2Frame.h
//  SRouter2Demo
//
//  Created by cs on 16/12/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SR2ServerProtocol.h"
#import "SR2Context.h"
#import "SR2ServerCommands.h"



@interface SR2Launcher : NSObject

@property (nonatomic, strong, readonly) id<SR2ServerProtocol> coreServer;

+ (instancetype)shareInstance;

- (BOOL)registerCoreServer:(NSString *)servName;

- (void)startAutoload:(NSString *)plistName finish:(SR2Finish)finishBlk error:(SR2Error)errorBlk;
- (void)loadModulesWithPlist:(NSString *)plistName;
- (BOOL)checkValidWithClassName:(NSString *)className from:(SR2CmdFrom)from;

- (id)tellModuleMessage:(NSString *)targetClass withParams:(SR2Params *)params;
- (void)tellAllModulesMessage:(SR2Params *)params;
- (id)targetForName:(NSString *)className;

@end
