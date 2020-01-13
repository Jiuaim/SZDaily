//
//  UIView+Preview.m
//  test
//
//  Created by hsz on 2020/1/10.
//  Copyright © 2020 hsz. All rights reserved.
//

#import "UIView+Preview.h"
#import <objc/runtime.h>

static char * const SZIsPreView = "SZIsPreView";
static char * const SZHiddenAllSubviews = "SZHiddenAllSubviews";
@implementation UIView (Preview)

- (BOOL)isPreView {
    return [objc_getAssociatedObject(self, SZIsPreView) boolValue];
}

- (void)setIsPreView:(BOOL)isPreView {
    objc_setAssociatedObject(self, SZIsPreView, @(isPreView), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)hiddenAllSubViews {
    return [objc_getAssociatedObject(self, SZHiddenAllSubviews) boolValue];
}

- (void)setHiddenAllSubViews:(BOOL)hiddenAllSubViews {
    objc_setAssociatedObject(self, SZHiddenAllSubviews, @(hiddenAllSubViews), OBJC_ASSOCIATION_ASSIGN);
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = hiddenAllSubViews;
    }];
}

@end
