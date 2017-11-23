//
//  SR2InnerMacro.h
//  SRouter2Demo
//
//  Created by cs on 16/12/24.
//  Copyright © 2016年 cs. All rights reserved.
//

#ifndef SR2InnerMacro_h
#define SR2InnerMacro_h


#ifndef SR2Lock
    #ifdef SR2_LockOpen
        #define SR2Lock(_l) [_l lock]
    #else
        #define SR2Lock(_l)
    #endif
#endif

#ifndef SR2Unlock
    #ifdef SR2_LockOpen
        #define SR2Unlock(_l) [_l unlock]
    #else
        #define SR2Unlock(_l)
    #endif
#endif

#define _SR2_LockInit(_t, _v) \
- (_t *)_##_v \
{ \
    if (_##_v == nil) { \
        _##_v = [_t new]; \
    } \
    return _##_v; \
}
#define SR2_LockInit(_v) _SR2_LockInit(NSLock, _v)

#define SR2LockDefine(_v) @property (nonatomic, strong) NSLock *_v


#define SR2DefaultPlist @"SR2Default"




#endif /* SR2InnerMacro_h */
