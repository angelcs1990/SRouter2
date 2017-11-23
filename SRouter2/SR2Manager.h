//
//  SR2Manager.h
//  SRouter2Demo
//
//  Created by cs on 16/12/26.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SR2Context.h"
#import <UIKit/UIKit.h>

//NS_ASSUME_NONNULL_BEGIN

@interface SR2Manager : NSObject

/**
 *  提交命令
 *  其他的都是调用的它
 *
 *  @param cmd  发往中间件的命令
 *  @param params 参数
 *  @param from 来自本地还是远程
 *
 *  @return 根据命令不同而不同
 */
+ (nullable id)router_handleMsg:(SR2ServerCmds)cmd params:(nullable SR2Params *)params from:(SR2CmdFrom)from;

/**
 *  根据类名实例化类
 *
 *  @param className  类名
 *
 *  @return 实例化对象
 */
+ (nullable id)router_InstanceClass:(nonnull NSString *)className;
#pragma mark - 初始化
/**
 *  核心处理服务初始化
 *  如果传nil，会使用默认的SR2CoreServer做服务处理模块
 *
 *  @param handler  处理服务名
 *
 */
+ (void)router_InitWithHandler:(nullable NSString *)handler finish:(nullable SR2Finish)finishBlk error:(nullable SR2Error)errorBlk;

#pragma mark - 界面跳转
/**
 *  界面跳转
 *
 *  @param targetClassName  将要跳转的类名
 *  @param params 参数
 *  @param blk 回调Block
 *
 *  @return 目标实例对象
 */
+ (nullable id)router_Push:(nonnull NSString *)targetClassName params:(nullable NSDictionary *)params handler:(nullable SR2BlockHandler)blk;
+ (nullable id)router_Push:(nonnull NSString *)targetClassName sourceVC:(nullable UIViewController *)sourceVC params:(nullable NSDictionary *)params handler:(nullable SR2BlockHandler)blk;

/**
 *  界面跳转
 *
 *  @param targetClassName  将要跳转的类名
 *  @param params 参数
 *  @param prol 回调协议实现方
 *
 *  @return 目标实例对象
 */
+ (nullable id)router_Push:(nonnull NSString *)targetClassName params:(nullable NSDictionary *)params protocol:(nullable id<SR2Protocol>)prol;
+ (nullable id)router_Push:(nonnull NSString *)targetClassName sourceVC:(nullable UIViewController *)sourceVC params:(nullable NSDictionary *)params protocol:(nullable id<SR2Protocol>)prol;

/**
 *  界面跳转
 *
 *  @param targetClassName  将要跳转的类名
 *  @param params 参数
 *  @param blk 回调Block
 *
 *  @return 目标实例对象
 */
+ (nullable id)router_Present:(nonnull NSString *)targetClassName params:(nullable NSDictionary *)params handler:(nullable SR2BlockHandler)blk;
+ (nullable id)router_Present:(nonnull NSString *)targetClassName sourceVC:(nullable UIViewController *)sourceVC params:(nullable NSDictionary *)params handler:(nullable SR2BlockHandler)blk;
/**
 *  界面跳转
 *
 *  @param targetClassName  将要跳转的类名
 *  @param params 参数
 *  @param prol 回调协议实现方
 *
 *  @return 目标实例对象
 */
+ (nullable id)router_Present:(nonnull NSString *)targetClassName params:(nullable NSDictionary *)params protocol:(nullable id<SR2Protocol>)prol;
+ (nullable id)router_Present:(nonnull NSString *)targetClassName sourceVC:(nullable UIViewController *)sourceVC params:(nullable NSDictionary *)params protocol:(nullable id<SR2Protocol>)prol;

#pragma mark - 消息订阅
/**
 *  消息订阅（使用该消息订阅的消息，需要手动取消）
 *
 *  @param msg  要订阅的消息编号
 *  @param className 谁要订阅
 *  @param block 回调实例（如果为空的话，会使用SR2ModuleNotify命令回调)
 *
 */
+ (void)router_SubscribMsg:(NSInteger)msg withName:(nonnull NSString *)className handler:(nullable SR2BlockHandler)block;

/**
 *  消息订阅
 *
 *  @param msg  要订阅的消息编号
 *  @param className 谁要订阅
 *  @param block 回调实例（如果为空的话，会使用SR2ModuleNotify命令回调)
 *  @param count 接收次数，超过次数后自动删除该订阅
 *
 */
+ (void)router_SubscribMsg:(NSInteger)msg withName:(nonnull NSString *)className handler:(nullable SR2BlockHandler)block recvCount:(NSInteger)count;

///**
// * 同上，简洁方法（block回调），只接收一次
// */
//+ (void)router_SubscribMsg:(NSInteger)msg handler:(nullable SR2BlockHandler)block;

/**
 * 同上，简洁方法（delegate回调），只接收一次
 */
+ (void)router_SubscribMsg:(NSInteger)msg withName:(nonnull NSString *)className;



/**
 *  消息订阅（扩展版本）
 *  订阅指定类的消息,配合router_Notify扩展使用
 
 *  @param msg 消息编号
 *  @param srcName 订阅者
 *  @param desName 订阅对象
 *  @param count 消息接收次数（超过自动销毁）
 *  @param block 收到订阅消息的回调函数
 */
+ (void)router_SubscribMsg:(NSInteger)msg srcName:(nonnull NSString *)srcName desName:(nonnull NSString *)desName countLimit:(NSInteger)count handler:(nullable SR2BlockHandler)block;

/**
 *  消息订阅（扩展版本）
 *  订阅指定类的消息，配合router_Notify扩展使用
 
 *  @param msg 消息编号
 *  @param srcName 订阅者
 *  @param desName 订阅对象
 *  @param block 收到订阅消息的回调函数
 */
+ (void)router_SubscribMsg:(NSInteger)msg srcName:(nonnull NSString *)srcName desName:(nonnull NSString *)desName handler:(nullable SR2BlockHandler)block;

/**
 * 同上，简洁方法（block回调），只接收一次
 */
//+ (void)router_SubscribMsg:(NSInteger)msg desName:(nonnull NSString *)desName handler:(nullable SR2BlockHandler)block;

/**
 * 同上，简洁方法（delegate回调），只接收一次
 */
+ (void)router_SubscribMsg:(NSInteger)msg srcName:(nonnull NSString *)srcName desName:(nonnull NSString *)desName;


/**
 *  订阅消息通知
 *  订阅的时候设置block的话，block的优先级高于SR2ModuleProtocol协议，其后的SR2ModuleProtocol不会走
 *
 *  @param msg  消息编号
 *  @param params 参数
 *
 */
+ (void)router_Notify:(NSInteger)msg withParams:(nullable NSDictionary *)params;

/**
 *  订阅消息通知扩展
 *  只有当订阅者指定了目标类名才有效
 *
 *  @param msg  消息编号
 *  @param srcName 消息发送着的类名
 *  @param params 参数
 *
 */
+ (void)router_Notify:(NSInteger)msg withSrcName:(nonnull NSString *)srcName withParams:(nullable NSDictionary *)params;

/**
 *  取消订阅
 *
 *  @param msg  消息编号
 *  @param className 订阅的源对象
 *
 */
+ (void)router_CancelSubscribMsg:(NSInteger)msg withName:(nonnull NSString *)className;

#pragma mark - 模块消息传递
/**
 *  模块间消息传递
 *  注意：正常流程需要注册targetClass才能使用，非正常流程直接使用，会创建临时实例对象
 *
 *  @param targetClass  目标对象
 *  @param cmd 消息编号
 *  @param params 参数
 *
 *  @return 自定义
 */
+ (nullable id)router_TellModuleMessage:(nonnull NSString *)targetClass withCmd:(NSInteger)cmd withParams:(nullable NSDictionary *)params;

/**
 *  通知所有的已经注册的模块
 *  注意：未注册到服务里面的模块不会通知
 *
 *  @param cmd  消息编号
 *  @param params 参数
 *
 */
+ (void)router_TellAllModulesMessage:(NSInteger)cmd withParams:(nullable NSDictionary *)params;

/**
 *  模块间消息传递（重载）
 *  为实现更多变化
 *
 *  @param targetClass  目标对象
 *  @param params 参数
 *
 *  @return 自定义
 */
+ (nullable id)router_TellModule:(nonnull NSString *)targetClass withMessage:(nonnull SR2Params *)params;

/**
 *  通知所有的已经注册的模块（重载）
 *  为实现更多变化
 *
 *  @param params  参数
 *
 */
+ (void)router_TellAllModulesMessage:(nonnull SR2Params *)params;

#pragma mark - 注册相关、查询


/**
 *  实例对象查询
 *
 *  @param key  类名
 *
 *  @return 实例对象
 */
+ (nullable id)router_QueryInstance:(nonnull NSString *)key;

#pragma mark - 服务类相关
/**
 *  服务注册
 *  注意：一切需要长持有的就使用该方法注册
 *
 *  @param servClass  类名
 *
 *  @return 实例对象
 */
+ (nullable id)router_RegisteServer:(nonnull NSString *)servClass;

/**
 *  服务反注册
 *
 *  @param servClass  类名
 *
 */
+ (void)router_UnregisteServer:(nonnull NSString *)servClass;

/**
 *  已注册服务查询
 *
 *  @param servClass  类名
 *
 *  @return 实例对象
 */
+ (nullable id)router_QueryServer:(nonnull NSString *)servClass;

#pragma mark - plist规则相关
/**
 *  plist规则注册
 *  注意：主要是用来做验证的，看调用的类是否是plist文件中的
 *
 *  @param plistName plist文件名
 *
 *  @return 无
 */
+ (BOOL)router_RegisteRules:(nonnull NSString *)plistName;

/**
 *  plist反注册
 *
 *  @param plistName plist文件名
 *
 */
+ (void)router_UnregisteRules:(nonnull NSString *)plistName;

#pragma mark - 查看SRouter2
+ (void)router_printServers;

+ (void)router_printSubscribe;

#pragma mark - 远程调用
/**
 *  远程URL调用
 *
 *  @param url 远程url
 *  @param completion 完成block
 *
 *  @return YES：允许远程调用
 */
+ (BOOL)router_OpenRemoteUrl:(nonnull NSURL *)url comletion:(void (^__nullable)(NSDictionary * __nullable))completion;





#pragma mark - catagory
+ (nullable NSDictionary *)SR2ModuleNotifyParams:(nonnull SR2Params *)params;

@end

//NS_ASSUME_NONNULL_END
