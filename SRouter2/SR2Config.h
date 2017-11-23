//
//  SR2Config.h
//  SRouter2Demo
//
//  Created by cs on 16/12/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SR2Config : NSObject

/**
 *  是否开启错误处理，会在模块的SR2ModuleProtocol协议中体现,default:NO（这要为了加快）
 */
@property (nonatomic) BOOL openModuleErrorHandle;

/**
 *  是否自动载入配置,默认配置文件是SR2Default.plist,default:NO
 */
@property (nonatomic) BOOL autoLoadPlist;

/**
 *  是否异步载入，Default:YES
 */
@property (nonatomic) BOOL asyncLoadPlist;

/**
 *  是否验证所有,default:NO
 */
@property (nonatomic) BOOL checkAll;

/**
 *  是否只验证本地调用，default：YES
 */
@property (nonatomic) BOOL checkLocal;

/**
 *  是否只验证远程调用，default：YES
 */
@property (nonatomic) BOOL checkRemote;

/**
 *  是否总是抛出异常，如果不设置，那么只会log输出，设置后总是抛出异常，
 *  只在debug模式下有用，default：NO
 */
@property (nonatomic) BOOL alwaysException;

/**
 *  是否开启调试模式
 */
@property (nonatomic) BOOL debugMode;

/**
 *  plist文件前缀，如果设置后，那么在载入plist配置的时候回检查是否符合该前缀
 */
@property (nonatomic, copy) NSString *plistPrefix;


@property (nonatomic, copy) NSString *scheme;

/**
 *  是否严格按照注册服务调用服务这样的逻辑做，如果为NO，在检测到没注册的服务时，会临时创建，default:YES
 */
@property (nonatomic) BOOL strictCheck;

/**
 *  在strictCheck为NO的时候有效，如果autoRegisteSvr=YES，那么会自动注册服务，如果NO就临时创建，default:NO
 */
@property (nonatomic) BOOL autoRegisteSvr;

@property (nonatomic, copy) NSString *moduleConfigName;



+ (instancetype)shareInstance;

@end
