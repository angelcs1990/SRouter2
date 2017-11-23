//
//  SR2CoreServer.m
//  SRouter2Demo
//
//  Created by cs on 16/12/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SR2CoreServer.h"
#import "SR2Context.h"
#import "SR2LocalHandler.h"
#import "SR2RemoteHandler.h"

@interface SR2CoreServer ()

@property (nonatomic, strong) SR2LocalHandler *localHandler;
@property (nonatomic, strong) SR2RemoteHandler *remoteHandler;

@end

@implementation SR2CoreServer
#pragma mark - SR2ServerProtocol
- (id)handleCommand:(SR2HandleContext *)context
{
    if (context.from == SR2CmdFromLocal) {
        return [self.localHandler handleCommand:context];
    } else {
        return [self.remoteHandler handleCommand:context];
    }
}

#pragma mark - 懒加载
- (SR2LocalHandler *)localHandler
{
    if (_localHandler == nil) {
        _localHandler = [SR2LocalHandler new];
    }
    
    return _localHandler;
}

- (SR2RemoteHandler *)remoteHandler
{
    if (_remoteHandler == nil) {
        _remoteHandler = [SR2RemoteHandler new];
    }
    
    return _remoteHandler;
}

@end
