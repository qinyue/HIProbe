//
//  NSObject+HIHook.h
//  Media
//
//  Created by hushaohua on 8/31/16.
//  Copyright © 2016 hsh-init. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HIHook)

+ (void) swizzlingSelector:(SEL)originSelector toSelector:(SEL)selector inClass:(Class)inClass;

@end
