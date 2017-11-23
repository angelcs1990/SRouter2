//
//  SR2Manager+Extension.h
//  SRouter2Demo
//
//  Created by cs on 17/3/1.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SR2Manager.h"



@interface SR2Manager (Extension)

+ (id)router_PushEx:(UIViewController *)target params:(NSDictionary *)params handler:(SR2BlockHandler)blk;
+ (id)router_PushEx:(UIViewController *)target sourceVC:(UIViewController *)sourceVC params:(NSDictionary *)params handler:(SR2BlockHandler)blk;
+ (id)router_PushEx:(UIViewController *)target params:(NSDictionary *)params protocol:(id<SR2Protocol>)prol;
+ (id)router_PushEx:(UIViewController *)target sourceVC:(UIViewController *)sourceVC params:(NSDictionary *)params protocol:(id<SR2Protocol>)prol;

+ (id)router_PresentEx:(UIViewController *)target params:(NSDictionary *)params handler:(SR2BlockHandler)blk;
+ (id)router_PresentEx:(UIViewController *)target sourceVC:(UIViewController *)sourceVC params:(NSDictionary *)params handler:(SR2BlockHandler)blk;
+ (id)router_PresentEx:(UIViewController *)target params:(NSDictionary *)params protocol:(id<SR2Protocol>)prol;
+ (id)router_PresentEx:(UIViewController *)target sourceVC:(UIViewController *)sourceVC params:(NSDictionary *)params protocol:(id<SR2Protocol>)prol;


+ (void)router_RegisteServerEx:(id)service;


+ (UIViewController *)currentViewController;

@end
