//
//  ModuleA+Action.h
//  SRouter2Demo
//
//  Created by cs on 16/12/28.
//  Copyright © 2016年 cs. All rights reserved.
//

//#import "ModuleA.h"
#import <UIKit/UIKit.h>
#import "SRouter2.h"

typedef NS_ENUM(NSInteger, ModuleACmds){
    ModuleA_ShowToast = SR2ModuleOtherCmd + 1,
    ModuleA_ShowAlert,
    ModuleA_ShowImg
};

typedef NS_ENUM(NSInteger, ErrModuleType){
    ErrModuleSystem,
    ErrModuleUser
};

@interface SR2Manager (ModuleA)

+ (void)ModulaA_showToast:(UIView *)view withMsg:(NSString *)msg;


@end
