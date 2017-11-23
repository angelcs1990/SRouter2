//
//  SR2Macro.h
//  SRouter2Demo
//
//  Created by cs on 16/12/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#ifndef SR2Macro_h
#define SR2Macro_h

#pragma once

#import "SR2Config.h"
#import "SR2InnerMacro.h"

//#define SR2_DEBUG

//#ifdef SR2_DEBUG
#define __SR2Log(_t, _err) do{\
    if([SR2Config shareInstance].debugMode) { \
        if([SR2Config shareInstance].alwaysException && _err) {\
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:_t userInfo:nil]; \
        } else { \
            NSLog(@"文件：%@ 函数：%s(%d)--%@", [[NSString stringWithUTF8String: __FILE__] lastPathComponent], __func__, __LINE__, _t); \
        }\
    } \
}while(0)

//#else
//#define __SR2Log(_t, _err) {}
//#endif

#define SR2ErrLog(_t) __SR2Log(_t, YES)
#define SR2Log(_t) __SR2Log(_t, NO)

#define SR2String(_output ,_text, ...) NSString *_output = [NSString stringWithFormat:_text, __VA_ARGS__];
#define SR2Declare(_key_, _v) static NSString *const _key_ = _v

#define SR2QueryBlock(_params) [_params.block copy]
#define SR2QueryDelegate(_params) _params.delegate

#define SR2Unused(_params) (void)(_params)

#define SR2ParameterAssert(condition) NSAssert((condition), @"Invalid parameter not satisfying: %@", @#condition)

#define SR2NullParam(_nstring) (_nstring == nil ? [NSNull null] : _nstring)

#define SR2_LockOpen

SR2Declare(keySR2_Param_Scheme, @"SR2_Scheme");
SR2Declare(keySR2_Param_Target, @"SR2_Target");
SR2Declare(keySR2_Param_Source, @"SR2_Source");
SR2Declare(keySR2_Param_Url, @"SR2_Url");
SR2Declare(keySR2_Param_Params, @"SR2_Params");
SR2Declare(keySR2_Param_Protocol, @"SR2_Protocol");
SR2Declare(keySR2_Param_Block, @"SR2_Block");
SR2Declare(keySR2_Param_Cmd, @"SR2_Cmd");


SR2Declare(kSRouter2Scheme, @"srouter2");

#endif /* SR2Macro_h */
