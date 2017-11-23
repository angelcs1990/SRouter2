//
//  NSObject+SR2Manager.h
//  SRouter2Demo
//
//  Created by cs on 17/3/24.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SR2Manager)

- (void)router_SetValue:(id)value forKey:(NSString *)key;
- (id)router_ValueForKey:(NSString *)key;

- (void)router_SetValue:(id)value forKeyPath:(NSString *)keyPath;
- (id)router_ValueForKeyPath:(NSString *)keyPath;

@end
