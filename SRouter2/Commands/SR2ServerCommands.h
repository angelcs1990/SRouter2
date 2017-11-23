//
//  SR2Commands.h
//  SRouter2Demo
//
//  Created by cs on 16/12/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#ifndef SR2Commands_h
#define SR2Commands_h

typedef NS_ENUM(NSInteger, SR2ServerCmds){
    SR2HandleRegiste,
    SR2HandleUnregiste,
    SR2HandleJump,
    SR2HandleQuery,
    SR2HandleSubscribe,
    SR2HandleOther
};

typedef NS_ENUM(NSInteger, SR2OtherCmds){
    SR2OtherTellMsg,
    SR2OtherTellAllMsg,
    SR2OtherPrintServers,
    SR2OtherPrintSubscribe,
};

typedef NS_ENUM(NSInteger, SR2UnregisteCmds){
    SR2UnregisteRules,
    SR2UnregisteBlock,
    SR2UnregisteProtocol,
    SR2UnregisteServer,
//    SR2UnregisteMappingName,
    SR2UnregisteOther
};

typedef NS_ENUM(NSInteger, SR2SubscribeCmds){
    SR2SubscribRegiste,
    SR2SubscribUnregiste,
    SR2SubscribNotify
};

typedef NS_ENUM(NSInteger, SR2QueryCmds){
    SR2QueryObject,
    SR2QueryServer,
    SR2QueryProtocol,
    SR2QueryBlock,
    SR2QueryOther,
};

typedef NS_ENUM(NSInteger, SR2JumpCmds){
    SR2JumpPush,
    SR2JumpPresent,
    SR2JumpOther
};

typedef NS_ENUM(NSInteger, SR2RegisteCmds){
    SR2RegisteRules,
    SR2RegisteBlock,
    SR2RegisteProtocl,
    SR2RegisteService,
//    SR2RegisteMappingName,
    SR2RegisteOther
};


#endif /* SR2Commands_h */
