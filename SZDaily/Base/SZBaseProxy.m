//
//  SZBaseProxy.m
//  SZDaily_Example
//
//  Created by hsz on 2020/9/29.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "SZBaseProxy.h"

@interface SZBaseProxy ()

@property (nonatomic, weak) id target;

@end

@implementation SZBaseProxy

+ (id)allocWithTarget:(id)target {
    SZBaseProxy *proxy = [SZBaseProxy alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    if ([self.target respondsToSelector:sel]) {
        return [self.target methodSignatureForSelector:sel];
    }
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([self.target respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.target];
    }
}

@end
