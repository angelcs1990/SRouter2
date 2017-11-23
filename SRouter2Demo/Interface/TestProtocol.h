//
//  TestProtocol.h
//  SRouter2Demo
//
//  Created by cs on 17/1/12.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestProtocol <SR2Protocol>

- (void)testPassValue:(NSString *)value;

@end
