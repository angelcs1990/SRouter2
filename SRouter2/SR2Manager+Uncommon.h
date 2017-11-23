//
//  SR2Manager+Uncommon.h
//  SRouter2Demo
//
//  Created by cs on 17/3/2.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SR2Manager.h"

@interface SR2Manager (Uncommon)

/**
 *  Block注册
 *  注意：注册后请手动解除注册
 *
 *  @param block  回调block
 *  @param keyName 标记名
 *
 *  @return 无
 */
+ (BOOL)router_RegisteBlock:(SR2BlockHandler)block name:(NSString *)keyName;

/**
 *  协议注册
 *  注意：注册后请手动解除注册
 *
 *  @param keyProtocol  协议
 *  @param inst 实例对象
 *
 *  @return 无
 */
+ (BOOL)router_RegisteProtocol:(Protocol *)keyProtocol withInstance:(id)inst;


/**
 *  已注册协议对象查询
 *
 *  @param protocol  协议
 *
 *  @return 协议对象
 */
+ (id)router_QueryProtocol:(Protocol *)protocol;

/**
 *  已注册Block查询
 *
 *  @param key  标记名
 *
 *  @return block
 */
+ (id)router_QueryBlock:(NSString *)key;



#pragma mark - 反注册
/**
 *  block反注册
 *
 *  @param keyName  标记名
 *
 */
+ (void)router_UnregisteBlock:(NSString *)keyName;

/**
 *  协议反注册
 *
 *  @param protocol  协议
 *
 */
+ (void)router_UnregisteProtocol:(Protocol *)protocol;

@end
