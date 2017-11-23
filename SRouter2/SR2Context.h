//
//  SR2HandleContext.h
//  SRouter2Demo
//
//  Created by cs on 16/12/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SR2ServerCommands.h"
#import "SR2Protocol.h"

typedef void(^SR2Finish)(int msg);
typedef void(^SR2Error)(int err);
typedef void (^SR2BlockHandler)(NSDictionary *dictParams);

typedef NS_ENUM(NSInteger, SR2CmdFrom) {
    SR2CmdFromLocal,
    SR2CmdFromRemote
};



@interface SR2Params : NSObject

+ (instancetype)parmasWithCmd:(NSInteger)cmd;

@property (nonatomic) NSInteger cmd;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, weak) id<SR2Protocol> delegate;
@property (nonatomic, copy) SR2BlockHandler block;
@property (nonatomic, strong) SR2Params *subCmd;

@end



@interface SR2HandleContext : NSObject

@property (nonatomic) SR2ServerCmds cmd;
@property (nonatomic, strong) SR2Params *params;
@property (nonatomic) SR2CmdFrom from;

@end



typedef NS_ENUM(NSInteger, SR2ModuleType) {
    SR2ModuleNormal = 0,  //一般的类，不是专门做模块的
    SR2ModuleServer,   //需要长久保持，提供服务的类
//    SR2ModuleSubscriber,
    SR2ModuleModule,  //专门实现模块协议做模块入口的类
    SR2ModuleOther
};


@interface SR2ModuleRuleContext : NSObject

@property (nonatomic, copy) NSString *className;
@property (nonatomic) SR2ModuleType moduleType;
@property (nonatomic, copy) NSString *shortName;
@property (nonatomic, copy) NSString *macroName;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic) BOOL supportRemote;

@end
