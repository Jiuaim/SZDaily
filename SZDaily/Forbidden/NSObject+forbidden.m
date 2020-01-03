//
//  NSObject+forbidden.m
//  ControlTest
//
//  Created by hsz on 2019/11/14.
//  Copyright © 2019 hsz. All rights reserved.
//

#import "NSObject+forbidden.h"
#import <objc/runtime.h>

static char * const sz_eventIntervalKey = "sz_eventIntervalKey";
static char * const eventUnavailableKey = "eventUnavailableKey";
static NSTimeInterval defaultActionTime = 1.0;

@implementation NSObject (forbidden)

- (NSTimeInterval)sz_eventInterval {
    NSTimeInterval interval = [objc_getAssociatedObject(self, sz_eventIntervalKey) doubleValue];
    NSTimeInterval finalInterval = interval ? interval : defaultActionTime;
    return finalInterval;
}

- (void)setSz_eventInterval:(NSTimeInterval)qi_eventInterval {
    objc_setAssociatedObject(self, sz_eventIntervalKey, @(qi_eventInterval?:defaultActionTime), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)eventUnavailable {
    return [objc_getAssociatedObject(self, eventUnavailableKey) boolValue];
}

- (void)setEventUnavailable:(BOOL)eventUnavailable {
    objc_setAssociatedObject(self, eventUnavailableKey, @(eventUnavailable), OBJC_ASSOCIATION_ASSIGN);
}

@end
