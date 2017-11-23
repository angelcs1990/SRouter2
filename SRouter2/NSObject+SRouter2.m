//
//  NSObject+SRouter2.m
//  SRouter2Demo
//
//  Created by cs on 17/3/6.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "NSObject+SRouter2.h"
#import "SR2Cache.h"
#import <objc/runtime.h>






@implementation NSObject (SRouter2)

//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//        
//        SEL originalSelector = sel_registerName("dealloc");
//        SEL swizzledSelector = @selector(_router_dealloc);
//        
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//        
//        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//        if (success) {
//            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    });
//}

//- (void)_router_dealloc
//{
//    [[SR2Cache shareInstance] removeAutoReleaseObject:[self _router_addWeakBag:nil]];
//    
//    [self _router_dealloc];
//}

- (void)addAutoRelease
{
    if ([[SR2Cache shareInstance] autoReleaseForKey:NSStringFromClass([self class])]) {
        return;
    }
    SR2WeakProxy *weakObj = [SR2WeakProxy new];
    SR2WeakObject *weakObj2 = [SR2WeakObject new];
    
    weakObj2.router_weakObject = self;
    weakObj.router_weakObjectKeyName = NSStringFromClass([self class]);
    
    [weakObj _router_addWeakBag:weakObj2];
    [self _router_addWeakBag:weakObj];
    
    [[SR2Cache shareInstance] addAutoReleaseObject:weakObj2 withKey:weakObj.router_weakObjectKeyName];
}

- (void )_router_addWeakBag:(id)weakObj
{
    id bag = objc_getAssociatedObject(self, _cmd);
    if (!bag && weakObj) {
//        bag = [[SR2WeakObject alloc] init];
        objc_setAssociatedObject(self, _cmd, weakObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
