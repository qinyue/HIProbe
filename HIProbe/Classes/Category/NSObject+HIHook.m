//
//  NSObject+HHook.m
//  Media
//
//  Created by hushaohua on 8/31/16.
//  Copyright © 2016 hsh-init. All rights reserved.
//

#import "NSObject+HIHook.h"
#import <objc/runtime.h>

@implementation NSObject (HIHook)

+ (void) swizzlingSelector:(SEL)originSelector toSelector:(SEL)selector inClass:(Class)inClass{
    Method originMethod = class_getInstanceMethod(inClass, originSelector);
    Method method = class_getInstanceMethod(inClass, selector);
    
    IMP originIMP = method_getImplementation(originMethod);
    const char* originTypes = method_getTypeEncoding(originMethod);
    
    IMP imp = method_getImplementation(method);
    const char* types = method_getTypeEncoding(method);
    
    if (class_addMethod(inClass, originSelector, imp, types)){
        class_replaceMethod(inClass, selector, originIMP, originTypes);
    }else{
        method_exchangeImplementations(originMethod, method);
    }
}





@end
