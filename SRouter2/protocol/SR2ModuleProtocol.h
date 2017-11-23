//
//  SModuleProtocol.h
//  SRouter2Demo
//
//  Created by cs on 16/12/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SR2Protocol.h"

@protocol SR2ModuleProtocol <SR2Protocol>

@required
- (id)SR2Module_Command:(SR2Params *)params;
@optional
+ (id)SR2Module_ClassCommand:(SR2Params *)params stop:(BOOL *)stop;

@end



