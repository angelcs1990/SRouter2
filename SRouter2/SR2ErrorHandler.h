//
//  SR2ErrorHandler.h
//  SRouter2Demo
//
//  Created by cs on 17/3/6.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SR2ModuleCommands.h"

@protocol SR2ErrorHandleDelegate <NSObject>

@required
- (id)router_ErrorHandleCmd:(SR2ModuleErrorCmds)cmd target:(id)target;

@end

@interface SR2ErrorHandler : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, weak) id<SR2ErrorHandleDelegate> delegate;

+ (id)sendErrorCmd:(SR2ModuleErrorCmds)cmd target:(id)target;

@end
