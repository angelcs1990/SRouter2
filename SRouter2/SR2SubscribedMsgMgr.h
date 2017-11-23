//
//  SR2SubscribedMessageManager.h
//  SRouter2Demo
//
//  Created by cs on 16/12/24.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SR2Context.h"

@interface SR2SubscribedMsgMgr : NSObject

+ (instancetype)shareInstance;

/**
 *  消息订阅

 *  @param msg 消息号
 *  @param srcName 订阅者名
 *  @param desName 订阅对象名
 *  @param block block回调
 *  @param count 接受通知次数
 */
- (void)subscribMsg:(NSInteger)msg srcName:(NSString *)srcName desName:(NSString *)desName handler:(SR2BlockHandler)block countLimit:(NSInteger)count;

/**
 *  消息通知

 *  @param params 参数
 */
- (void)notify:(SR2Params *)params;

/**
 *  取消消息订阅

 *  @param msg 消息号
 *  @param className 订阅者名
 */
- (void)cancelSubscribMsg:(NSInteger)msg withName:(NSString *)className;

/**
 *  输出订阅消息池
 */
- (void)printDebug;

@end
