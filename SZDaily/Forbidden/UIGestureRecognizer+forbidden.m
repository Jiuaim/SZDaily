//
//  UIGestureRecognizer+forbidden.m
//  ControlTest
//
//  Created by hsz on 2020/1/2.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "UIGestureRecognizer+forbidden.h"
#import <Aspects/Aspects.h>
#import <objc/runtime.h>
#import "NSObject+forbidden.h"
#import "SZShortMacro.h"

@implementation UIGestureRecognizer (forbidden)

+ (void)load {
    Method method = class_getInstanceMethod(self, @selector(initWithTarget:action:));
    Method sz_method = class_getInstanceMethod(self, @selector(xt_initWithTarget:action:));
    method_exchangeImplementations(method, sz_method);
}

- (instancetype)xt_initWithTarget:(id)target action:(SEL)action {
    @WeakObj(target);
    [target aspect_hookSelector:action withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo){
        @StrongObj(target);
        NSObject *ob = (NSObject *)target;
        if (!ob.eventUnavailable) {
            ob.eventUnavailable = YES;
            NSInvocation *invocation = aspectInfo.originalInvocation;
            [invocation invoke];
            [ob performSelector:@selector(setEventUnavailable:) withObject:@(NO) afterDelay:ob.sz_eventInterval];
        }
    } error:NULL];
    return [self xt_initWithTarget:target action:action];
}

@end
