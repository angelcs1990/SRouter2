//
//  SServerNormalProtocol.h
//  SRouter2Demo
//
//  Created by cs on 16/12/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SR2Protocol.h"

@class SR2HandleContext;
@protocol SR2ServerProtocol <SR2Protocol>

@required
- (id)handleCommand:(SR2HandleContext *)context;

@end
