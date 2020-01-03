//
//  UIControl+forbidden.m
//  ControlTest
//
//  Created by hsz on 2019/11/14.
//  Copyright © 2019 hsz. All rights reserved.
//

#import "UIControl+forbidden.h"
#import <Aspects/Aspects.h>
#import <objc/runtime.h>
#import "NSObject+forbidden.h"

#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

@interface UIControl ()
@property (nonatomic, assign) BOOL eventUnavailable;
@end

@implementation UIControl (forbidden)

+ (void)load {
    Method method = class_getInstanceMethod(self, @selector(addTarget:action:forControlEvents:));
    Method sz_method = class_getInstanceMethod(self, @selector(sz_addTarget:action:forControlEvents:));
    method_exchangeImplementations(method, sz_method);
}

- (void)sz_addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if (controlEvents == UIControlEventTouchUpInside) {// 只劫持点击事件
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
        [self sz_addTarget:target action:action forControlEvents:controlEvents];
    } else {
        [self sz_addTarget:target action:action forControlEvents:controlEvents];
    }
}


@end
